import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/dropdown_custom.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/ai_assistant_entity.dart';
import 'package:pss_app/features/AiAssistant/domain/rules/ai_passenger_rules.dart';
import 'package:pss_app/features/master/domain/entities/country_code_entity.dart';
import 'package:pss_app/features/master/domain/usecases/list_country_codes.dart';
import 'package:pss_app/features/master/presentation/widget/country_search_dialog.dart';

import '../../../../../core/utils/top_snackbar_helper.dart';

class PassangerConservationFormDialog extends StatefulWidget {
  const PassangerConservationFormDialog({
    super.key,
    required this.passengerType,
    required this.label,
    this.initial,
    this.firstTravel,
    this.lastTravel,
  });

  final String passengerType;
  final String label;
  final AiPassengerEntity? initial;

  final DateTime? firstTravel;
  final DateTime? lastTravel;

  @override
  State<PassangerConservationFormDialog> createState() => _PassangerConservationFormDialogState();
}

class _PassangerConservationFormDialogState extends State<PassangerConservationFormDialog> {
  static const _dateFormat = 'yyyy-MM-dd';
  static const _adultTitleOptions = ['Mr.', 'Mrs.', 'Ms.'];

  static const _childTitleOptions = ['Mstr.', 'Miss'];
  static const _documentTypeOptions = ['KTP', 'Passport', 'KIA'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _documentNumberController;

  String? _title;
  String? _gender; // M | F
  DateTime? _birthDate;
  String? _nationality;
  String? _documentType;
  DateTime? _documentExpiredAt;
  bool get _birthDateRequired => widget.passengerType != 'ADT';

  List<CountryCodeEntity>? _countries;
  String? _countriesError;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _firstNameController = TextEditingController(text: initial?.firstName ?? '');
    _lastNameController = TextEditingController(text: initial?.lastName ?? '');
    _documentNumberController = TextEditingController(text: initial?.documentNumber ?? '');
    _title = initial?.title;
    _gender = initial?.gender;
    _birthDate = _tryParseDate(initial?.birthDate);
    _nationality = initial?.nationality;
    _documentType = initial?.documentType;
    _documentExpiredAt = _tryParseDate(initial?.documentExpiredAt);
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final result = await serviceLocator<ListCountryCodes>()(const ListCountryCodesParams());
    if (!mounted) return;
    result.fold((failure) => setState(() => _countriesError = failure.message), (countries) {
      setState(() {
        _countries = countries;

        if (_nationality != null && !countries.any((c) => c.alpha2 == _nationality)) {
          _nationality = null;
        }
      });
    });
  }

  DateTime? _tryParseDate(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _documentNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    var firstDate = DateTime(now.year - 100);
    var lastDate = now;
    var initialDate = _birthDate ?? (_birthDateRequired ? now : DateTime(now.year - 25));

    final travelStart = widget.firstTravel;
    if (travelStart != null) {
      final (first, last, initial) = AiPassengerRules.birthPickerRange(
        type: widget.passengerType,
        firstTravel: travelStart,
        lastTravel: widget.lastTravel ?? travelStart,
      );
      firstDate = first;
      lastDate = last;
      initialDate = _birthDate ?? initial;
      if (initialDate.isBefore(firstDate) || initialDate.isAfter(lastDate)) initialDate = lastDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickDocumentExpiry() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _documentExpiredAt ?? now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: DateTime(now.year + 20),
    );

    if (picked != null) setState(() => _documentExpiredAt = picked);
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_birthDateRequired && _birthDate == null) {
      TopSnackbarHelper.info(
        context,
        message:
            'Birth date is required for ${widget.passengerType == 'CHD' ? 'child' : 'infant'} passengers.',
      );
      return;
    }

    final travelStart = widget.firstTravel;
    if (travelStart != null) {
      final problem = AiPassengerRules.birthDate(
        type: widget.passengerType,
        birth: _birthDate,
        firstTravel: travelStart,
        lastTravel: widget.lastTravel ?? travelStart,
      );
      if (problem != null) {
        TopSnackbarHelper.info(context, message: problem);
        return;
      }
    }

    Navigator.of(context).pop(
      AiPassengerEntity(
        passengerType: widget.passengerType,
        title: _title,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim().isEmpty ? "" : _lastNameController.text.trim(),
        gender: _gender,
        birthDate: _birthDate != null ? DateFormat(_dateFormat).format(_birthDate!) : null,
        nationality: _nationality,
        documentType: _documentType,
        documentNumber: _documentNumberController.text.trim().isEmpty
            ? null
            : _documentNumberController.text.trim(),
        documentExpiredAt: _documentExpiredAt != null
            ? DateFormat(_dateFormat).format(_documentExpiredAt!)
            : null,
      ),
    );
  }

  Widget _dateField({
    required String label,
    required String hintText,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InputText(
      title: label,
      hintText: hintText,
      readOnly: true,
      cursor: false,
      ontaped: onTap,
      controller: TextEditingController(
        text: value != null ? DateFormat('dd MMM yyyy').format(value) : '',
      ),
      icon: const Icon(Icons.calendar_today_rounded, size: 16),
    );
  }

  Widget _nationalityField() {
    if (_countriesError != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              "Couldn't load the country list: $_countriesError",
              style: AppFont.reguler12.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _countriesError = null);
              _loadCountries();
            },
            child: const Text("Retry"),
          ),
        ],
      );
    }

    final countries = _countries;
    if (countries == null) {
      return Row(
        children: [
          const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
          widget.width(8),
          Text(
            "Loading country list...",
            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      );
    }

    CountryCodeEntity? selected;
    for (final c in countries) {
      if (c.alpha2 == _nationality) {
        selected = c;
        break;
      }
    }

    return InputText(
      title: "Nationality (optional)",
      hintText: "Tap to search",
      readOnly: true,
      cursor: false,
      ontaped: () async {
        final picked = await showCountrySearchDialog(
          context,
          countries: countries,
          initialAlpha3: selected?.alpha3,
        );
        if (picked != null) setState(() => _nationality = picked.alpha2);
      },
      controller: TextEditingController(
        text: selected == null ? '' : "${selected.name ?? '-'} (${selected.alpha2})",
      ),
      icon: const Icon(Icons.expand_more, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.h(0.85)),
        child: CardGeneral(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.label, style: AppFont.medium16),
                          widget.height(4),
                          Text(
                            "As it appears on their ID or passport.",
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),

                widget.height(16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: widget.passengerType != "INF",
                              child: SizedBox(
                                width: context.w(0.25),
                                child: DropDownCustom(
                                  listData:
                                      (widget.passengerType == "ADT"
                                              ? _adultTitleOptions
                                              : _childTitleOptions)
                                          .map(
                                            (item) => DropdownItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: AppFont.reguler12.copyWith(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  hint: "Select title",
                                  title: "Title ",
                                  value: _title == "" ? null : _title,

                                  onChange: (v) => setState(() => _title = v),
                                ),
                              ),
                            ),

                            Expanded(
                              child: InputText(
                                title: "First Name",
                                hintText: "e.g. Aditya",
                                controller: _firstNameController,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? "First name is required"
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        widget.height(12),
                        InputText(
                          title: "Last Name (optional)",
                          hintText: "e.g. Pratama",
                          controller: _lastNameController,
                          textInputAction: TextInputAction.next,
                        ),
                        widget.height(12),
                        DropDownCustom(
                          listData: ['M', 'F']
                              .map(
                                (item) => DropdownItem<String>(
                                  value: item,
                                  child: Text(
                                    item == 'M' ? 'Male' : 'Female',
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          hint: "Select gender",
                          title: "Gender (optional)",
                          value: (_gender == "" || _gender == null) ? null : _gender,

                          onChange: (v) => setState(() => _gender = v),
                        ),

                        widget.height(12),
                        _dateField(
                          label: _birthDateRequired ? "Birth Date" : "Birth Date (optional)",
                          hintText: "Select birth date",
                          value: _birthDate,
                          onTap: _pickBirthDate,
                        ),
                        widget.height(12),
                        _nationalityField(),
                        widget.height(12),

                        DropDownCustom(
                          listData: _documentTypeOptions
                              .map(
                                (item) => DropdownItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          hint: "Select document type",
                          title: "Document Type (optional)",
                          value: _documentType == "" ? null : _documentType,

                          onChange: (v) => setState(() => _documentType = v),
                        ),

                        widget.height(12),
                        InputText(
                          title: "Document Number (optional)",
                          hintText: "e.g. 3171234567890001",
                          controller: _documentNumberController,
                          textInputAction: TextInputAction.next,
                        ),
                        widget.height(12),
                        _dateField(
                          label: "Document Expiry (optional)",
                          hintText: "Select expiry date",
                          value: _documentExpiredAt,
                          onTap: _pickDocumentExpiry,
                        ),
                        widget.height(24),
                        PrimaryButton(title: "Save", onPressed: _onSave),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
