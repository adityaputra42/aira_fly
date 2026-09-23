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
import 'package:pss_app/core/utils/show_snackbar.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/repository/booking_repository.dart';
import 'package:pss_app/features/master/domain/entities/country_code_entity.dart';
import 'package:pss_app/features/master/domain/usecases/list_country_codes.dart';
import 'package:pss_app/features/master/presentation/widget/country_search_dialog.dart';

class PassengerInformationDialog extends StatefulWidget {
  const PassengerInformationDialog({
    super.key,
    required this.passengerType,
    required this.label,
    this.initial,
  });

  final String passengerType; // ADT | CHD | INF
  final String label; // e.g. "Adult 1", shown as the dialog title
  final PassengerInput? initial;

  @override
  State<PassengerInformationDialog> createState() => _PassengerInformationDialogState();
}

class _PassengerInformationDialogState extends State<PassengerInformationDialog> {
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
  // Stores the ISO 3166-1 alpha-3 code (e.g. "IDN"), not the display
  // name -- see CountryCodeEntity.alpha3. Was free text before this was
  // wired to GET /master/country-codes.
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
        // A previously-saved nationality that isn't one of the codes we
        // just got back (e.g. old free-text data like "Indonesia" from
        // before this was wired to the country list, or a country
        // dropped from the reference table) would silently render as a
        // blank field with no way to tell "unset" apart from "set to
        // something we can no longer display". Clear it so the person
        // re-picks explicitly rather than unknowingly resubmitting a
        // stale, unverifiable value.
        if (_nationality != null && !countries.any((c) => c.alpha3 == _nationality)) {
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
    final initialDate = _birthDate ?? (_birthDateRequired ? now : DateTime(now.year - 25));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 100),
      lastDate: now,
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
      showSnackBar(
        context,
        'Birth date is required for ${widget.passengerType == 'CHD' ? 'child' : 'infant'} passengers.',
      );
      return;
    }

    Navigator.of(context).pop(
      PassengerInput(
        passengerType: widget.passengerType,
        title: _title,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim().isEmpty ? null : _lastNameController.text.trim(),
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
          initialAlpha3: _nationality,
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
