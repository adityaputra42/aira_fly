import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/utils/show_snackbar.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/repository/booking_repository.dart';

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
  static const _titleOptions = ['Mr.', 'Mrs.', 'Ms.', 'Mstr.', 'Miss'];
  static const _documentTypeOptions = ['KTP', 'Passport', 'KIA'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _nationalityController;
  late final TextEditingController _documentNumberController;

  String? _title;
  String? _gender; // M | F
  DateTime? _birthDate;
  String? _documentType;
  DateTime? _documentExpiredAt;
  bool get _birthDateRequired => widget.passengerType != 'ADT';

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _firstNameController = TextEditingController(text: initial?.firstName ?? '');
    _lastNameController = TextEditingController(text: initial?.lastName ?? '');
    _nationalityController = TextEditingController(text: initial?.nationality ?? '');
    _documentNumberController = TextEditingController(text: initial?.documentNumber ?? '');
    _title = initial?.title;
    _gender = initial?.gender;
    _birthDate = _tryParseDate(initial?.birthDate);
    _documentType = initial?.documentType;
    _documentExpiredAt = _tryParseDate(initial?.documentExpiredAt);
  }

  DateTime? _tryParseDate(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalityController.dispose();
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
        nationality: _nationalityController.text.trim().isEmpty
            ? null
            : _nationalityController.text.trim(),
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

  Widget _dropdownField<T>({
    required String label,
    required T? value,
    required List<T> options,
    required String Function(T) display,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.medium12.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        widget.height(8),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: AppFont.medium12.copyWith(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.secondaryColor),
            ),
          ),
          hint: Text(
            "Select",
            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
          ),
          items: options
              .map((option) => DropdownMenuItem<T>(value: option, child: Text(display(option))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: CardGeneral(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label, style: AppFont.medium16),
                  widget.height(4),
                  Text(
                    "As it appears on their ID or passport.",
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                  widget.height(16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 96,
                        child: _dropdownField<String>(
                          label: "Title",
                          value: _title,
                          options: _titleOptions,
                          display: (v) => v,
                          onChanged: (v) => setState(() => _title = v),
                        ),
                      ),
                      widget.width(12),
                      Expanded(
                        child: InputText(
                          title: "First Name",
                          hintText: "e.g. Aditya",
                          controller: _firstNameController,
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? "First name is required" : null,
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
                  _dropdownField<String>(
                    label: "Gender (optional)",
                    value: _gender,
                    options: const ['M', 'F'],
                    display: (v) => v == 'M' ? 'Male' : 'Female',
                    onChanged: (v) => setState(() => _gender = v),
                  ),
                  widget.height(12),
                  _dateField(
                    label: _birthDateRequired ? "Birth Date" : "Birth Date (optional)",
                    hintText: "Select birth date",
                    value: _birthDate,
                    onTap: _pickBirthDate,
                  ),
                  widget.height(12),
                  InputText(
                    title: "Nationality (optional)",
                    hintText: "e.g. Indonesia",
                    controller: _nationalityController,
                    textInputAction: TextInputAction.next,
                  ),
                  widget.height(12),
                  _dropdownField<String>(
                    label: "Document Type (optional)",
                    value: _documentType,
                    options: _documentTypeOptions,
                    display: (v) => v,
                    onChanged: (v) => setState(() => _documentType = v),
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
        ),
      ),
    );
  }
}
