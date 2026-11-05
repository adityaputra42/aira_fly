import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/ai_assistant_entity.dart';
import 'package:pss_app/features/AiAssistant/presentation/bloc/ai_assistant_bloc.dart';
import 'package:pss_app/features/AiAssistant/presentation/widget/contact_information_conservation_dialog.dart';
import 'package:pss_app/features/AiAssistant/presentation/widget/passanger_conservation_form_dialog.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../core/common/widget/primary_button.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../../../../core/utils/top_snackbar_helper.dart';
import '../../../../../core/utils/widget_helper.dart';

String? passengerFormTotalText(AiTurnEntity turn) {
  final offers = turn.offers;
  final fareId = turn.selectedFareClassId;
  if (offers == null || fareId == null || turn.selectedOffers.isEmpty) return null;

  AiFareEntity? pick(List<AiOfferEntity> list, String optionId) {
    for (final o in list) {
      if (o.optionId != optionId) continue;
      for (final f in o.fares) {
        if (f.fareClassId == fareId) return f;
      }
    }
    return null;
  }

  final dep = pick(offers.departure, turn.selectedOffers.first);
  if (dep == null) return null;
  if (turn.selectedOffers.length == 1) return dep.totalText.isEmpty ? null : dep.totalText;

  final ret = pick(offers.returnOffers, turn.selectedOffers[1]);
  if (ret == null) return null;
  final sum = (double.tryParse(dep.total) ?? 0) + (double.tryParse(ret.total) ?? 0);
  return sum <= 0 ? null : 'Rp ${_thousands(sum.round())}';
}

String _thousands(int v) =>
    v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');

class PassangerContactFormScreen extends StatefulWidget {
  const PassangerContactFormScreen({super.key, required this.pax, this.totalText});

  final AiPassengerSummaryEntity pax;
  final String? totalText;

  @override
  State<PassangerContactFormScreen> createState() => _PassangerContactFormScreenState();
}

class _PassangerContactFormScreenState extends State<PassangerContactFormScreen> {
  late final List<({String type, String label})> _slots;
  late final List<AiPassengerEntity?> _passengers;
  late final List<TextEditingController> _controllers;
  AiContactEntity? _contact;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _slots = widget.pax.slots;
    _passengers = List<AiPassengerEntity?>.filled(_slots.length, null);
    _controllers = List.generate(_slots.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isComplete => _contact != null && _passengers.every((p) => p != null);

  String _passengerDisplayName(AiPassengerEntity p) =>
      [if (p.title != null) p.title!, p.firstName, if (p.lastName.isNotEmpty) p.lastName].join(' ');

  Future<void> _editContact() async {
    final result = await showZoomDialog<AiContactEntity>(
      context: context,
      child: ContactInformationConservationDialog(initial: _contact),
    );
    if (result == null || !mounted) return;
    setState(() => _contact = result);
  }

  Future<void> _editPassenger(int index) async {
    final slot = _slots[index];
    final result = await showZoomDialog<AiPassengerEntity>(
      context: context,
      child: PassangerConservationFormDialog(
        passengerType: slot.type,
        label: slot.label,
        initial: _passengers[index],
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _passengers[index] = result;
      _controllers[index].text = _passengerDisplayName(result);
    });
  }

  void _onContinue() {
    if (_submitting) return;
    if (!_isComplete) {
      TopSnackbarHelper.info(
        context,
        message: 'Please fill in contact and all passenger details first.',
      );
      return;
    }
    Navigator.pop(context);
    final bloc = context.read<AiAssistantBloc>();
    if (bloc.state.isBusy) return;
    setState(() => _submitting = true);
    bloc.add(
      AiPassengersSubmitted(
        contact: _contact!,
        passengers: _passengers.whereType<AiPassengerEntity>().toList(),
      ),
    );
  }

  void _onBlocChanged(BuildContext context, AiAssistantState state) {
    if (!_submitting) return;
    if (state.status == AiChatStatus.failure) {
      setState(() => _submitting = false);
    } else if (state.status == AiChatStatus.ready) {
      setState(() => _submitting = false);
      final turn = state.turn;
      if (turn != null && turn.can(AiAction.submitPassengers)) {
        TopSnackbarHelper.error(
          context,
          message: turn.message.isEmpty ? 'Data penumpang ditolak. Periksa kembali.' : turn.message,
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hint = Theme.of(context).hintColor;
    return BlocListener<AiAssistantBloc, AiAssistantState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: _onBlocChanged,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          context: context,
          title: "Contact Passenger Form Flight",
          color: AppColor.primaryColor,
          titleColor: AppColor.darkText1,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.height(16),
                Text("Contact Information", style: AppFont.semibold16),
                widget.height(8),
                CardGeneral(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _contact == null
                            ? Text(
                                "No contact set yet. Tap Add to enter who we should reach about this booking.",
                                style: AppFont.reguler12.copyWith(color: hint),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_contact!.fullName, style: AppFont.medium14),
                                  widget.height(4),
                                  if (_contact!.email.isNotEmpty) ...[
                                    Text(
                                      _contact!.email,
                                      style: AppFont.reguler12.copyWith(color: hint),
                                    ),
                                    widget.height(4),
                                  ],
                                  Text(
                                    _contact!.phone,
                                    style: AppFont.reguler12.copyWith(color: hint),
                                  ),
                                ],
                              ),
                      ),
                      widget.width(8),
                      InkWell(
                        onTap: _editContact,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.secondaryColor.withValues(alpha: 0.1),
                            border: Border.all(color: AppColor.secondaryColor, width: 0.5),
                          ),
                          child: Text(
                            _contact == null ? "Add" : "Edit",
                            style: AppFont.medium14.copyWith(color: AppColor.secondaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.height(16),
                Text("Passenger Information", style: AppFont.semibold16),
                widget.height(12),
                for (var i = 0; i < _slots.length; i++) ...[
                  InputText(
                    hintText: "Tap to fill in ${_slots[i].label.toLowerCase()}'s details",
                    title: _slots[i].label,
                    controller: _controllers[i],
                    filled: true,
                    readOnly: true,
                    cursor: false,
                    ontaped: () => _editPassenger(i),
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    filledColor: Theme.of(context).cardColor,
                  ),
                  if (i != _slots.length - 1) widget.height(12),
                ],
                widget.height(16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 0.5,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
            child: PrimaryButton(
              title: _submitting ? "Sending..." : "Continue",
              disable: _submitting,
              onPressed: _onContinue,
              borderRadius: 8,
            ),
          ),
        ),
      ),
    );
  }
}
