import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/repository/booking_repository.dart';

class ContactInformationDialog extends StatefulWidget {
  const ContactInformationDialog({super.key, this.initial});

  final ContactInput? initial;

  @override
  State<ContactInformationDialog> createState() => _ContactInformationDialogState();
}

class _ContactInformationDialogState extends State<ContactInformationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.fullName ?? '');
    _emailController = TextEditingController(text: widget.initial?.email ?? '');
    _phoneController = TextEditingController(text: widget.initial?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _emailValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null; // optional, per ContactInput.email
    final looksValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    return looksValid ? null : 'Enter a valid email address';
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pop(
      ContactInput(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Contact Information", style: AppFont.medium16),
                        widget.height(4),
                        Text(
                          "Who should we contact about this booking? Doesn't have to be a passenger.",
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
              InputText(
                title: "Full Name",
                hintText: "e.g. Aditya Pratama",
                controller: _nameController,
                textInputAction: TextInputAction.next,
                validator: (v) => _requiredValidator(v, "Full name"),
              ),
              widget.height(12),
              InputText(
                title: "Email (optional)",
                hintText: "e.g. aditya@email.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _emailValidator,
              ),
              widget.height(12),
              InputText(
                title: "Phone Number",
                hintText: "e.g. 081234567890",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                validator: (v) => _requiredValidator(v, "Phone number"),
              ),
              widget.height(24),
              PrimaryButton(title: "Save", onPressed: _onSave),
            ],
          ),
        ),
      ),
    );
  }
}
