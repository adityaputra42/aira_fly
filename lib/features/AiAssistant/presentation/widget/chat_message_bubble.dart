import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pss_app/app/theme/app_color.dart';
import 'package:pss_app/app/theme/app_font.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/ai_assistant_entity.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/chat_entity.dart';

import '../../../../core/common/widget/card_general.dart';
import '../../../../core/constants/images.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final void Function(AiOfferEntity departure, AiFareEntity fare, AiOfferEntity? returnOffer)?
  onSelectFlight;
  final VoidCallback? onConfirmBooking;
  final ValueChanged<String>? onPay; // channel
  final VoidCallback? onRefreshPayment;
  final VoidCallback? onFillPassengers;
  final VoidCallback? onRetry;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onSelectFlight,
    this.onConfirmBooking,
    this.onPay,
    this.onRefreshPayment,
    this.onFillPassengers,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          margin: const EdgeInsets.only(bottom: 12, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(message.text, style: AppFont.medium12.copyWith(color: AppColor.darkText1)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: colors.secondary.withValues(alpha: .14),
            child: Image.asset(AppImages.aiIcon, width: 20),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(message.text, style: AppFont.medium12),
                ),
                if (message.type == ChatMessageType.flightResults && message.turn?.offers != null)
                  _FlightResultCard(offers: message.turn!.offers!, onSelect: onSelectFlight),
                if (message.type == ChatMessageType.bookingDetails &&
                    message.turn?.confirmation != null)
                  _BookingDetailsCard(
                    confirmation: message.turn!.confirmation!,
                    onConfirm: onConfirmBooking,
                  ),
                if (message.type == ChatMessageType.paymentConfirmation &&
                    message.turn?.confirmation != null)
                  _PaymentConfirmationCard(confirmation: message.turn!.confirmation!, onPay: onPay),
                if (message.type == ChatMessageType.paymentStatus && message.turn?.payment != null)
                  _PaymentStatusCard(turn: message.turn!, onRefresh: onRefreshPayment),
                if (message.type == ChatMessageType.passengerForm)
                  _PassengerFormCard(onFill: onFillPassengers),
                if (message.type == ChatMessageType.error) _ErrorCard(onRetry: onRetry),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.createdAt),
                  style: AppFont.reguler10.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

class _FlightResultCard extends StatefulWidget {
  final AiOffersEntity offers;
  final void Function(AiOfferEntity departure, AiFareEntity fare, AiOfferEntity? returnOffer)?
  onSelect;

  const _FlightResultCard({required this.offers, this.onSelect});

  @override
  State<_FlightResultCard> createState() => _FlightResultCardState();
}

class _FlightResultCardState extends State<_FlightResultCard> {
  AiOfferEntity? _offer;
  AiFareEntity? _fare;
  AiOfferEntity? _return;

  bool get _needsReturn => widget.offers.returnOffers.isNotEmpty;
  bool get _ready => _offer != null && _fare != null && (!_needsReturn || _return != null);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CardGeneral(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_needsReturn) const Text('Departure', style: AppFont.semibold14),
          for (final offer in widget.offers.departure) ...[
            _OfferHeader(offer: offer),
            Wrap(
              spacing: 8,
              children: [
                for (final fare in offer.fares)
                  ChoiceChip(
                    backgroundColor: colors.surface,
                    selectedColor: AppColor.primaryColor,
                    disabledColor: colors.shadow,

                    label: Text(
                      '${fare.name} • ${fare.totalText}',
                      style: AppFont.medium12.copyWith(color: colors.onSurface),
                    ),
                    selected: _offer == offer && _fare == fare,
                    onSelected: widget.onSelect == null || fare.availableSeats <= 0
                        ? null
                        : (_) => setState(() {
                            _offer = offer;
                            _fare = fare;
                          }),
                  ),
              ],
            ),
            const Divider(height: 20),
          ],
          if (_needsReturn) ...[
            const Text('Return', style: AppFont.semibold14),
            for (final offer in widget.offers.returnOffers)
              InkWell(
                onTap: widget.onSelect == null ? null : () => setState(() => _return = offer),
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _return == offer ? colors.primary : colors.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _OfferHeader(offer: offer),
                ),
              ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onSelect == null || !_ready
                  ? null
                  : () => widget.onSelect!(_offer!, _fare!, _return),
              child: const Text('Select this flight', style: AppFont.medium12),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferHeader extends StatelessWidget {
  final AiOfferEntity offer;
  const _OfferHeader({required this.offer});

  @override
  Widget build(BuildContext context) {
    if (offer.segments.isEmpty) return const SizedBox.shrink();
    final first = offer.segments.first;
    final last = offer.segments.last;
    final flights = offer.segments.map((s) => s.flightNumber).join(' + ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flight_takeoff_rounded, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${first.fromCity ?? first.from}  →  ${last.toCity ?? last.to}',
                  style: AppFont.semibold14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${first.from} ${first.departText}  →  ${last.to} ${last.arriveText}',
            style: AppFont.medium12,
          ),
          Text(
            '$flights  •  ${offer.durationText}${offer.stops > 0 ? '  •  ${offer.stops} stop' : ''}',
            style: AppFont.medium12,
          ),
        ],
      ),
    );
  }
}

class _BookingDetailsCard extends StatelessWidget {
  final AiConfirmationEntity confirmation;
  final VoidCallback? onConfirm;
  const _BookingDetailsCard({required this.confirmation, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CardGeneral(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking summary', style: AppFont.semibold14),
          const SizedBox(height: 10),
          if (confirmation.priceChanged)
            CardGeneral(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              useShadow: false,
              background: colors.errorContainer,
              child: Text(
                'Harga berubah'
                '${confirmation.previousTotalText != null ? ' dari ${confirmation.previousTotalText}' : ''}'
                '. Periksa total baru sebelum melanjutkan.',
                style: AppFont.medium14.copyWith(color: colors.errorContainer),
              ),
            ),
          for (final line in confirmation.lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(line, style: AppFont.medium12),
            ),
          for (final seat in confirmation.seats)
            _InfoRow(
              label: 'Seat • ${seat.flightNumber} • Pax ${seat.passengerIndex + 1}',
              value: seat.seatNumber,
            ),
          const Divider(height: 20),
          _InfoRow(label: 'Total', value: confirmation.totalText, bold: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onConfirm,
              child: Text('Confirm booking', style: AppFont.medium12.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentConfirmationCard extends StatefulWidget {
  final AiConfirmationEntity confirmation;
  final ValueChanged<String>? onPay;
  const _PaymentConfirmationCard({required this.confirmation, this.onPay});

  @override
  State<_PaymentConfirmationCard> createState() => _PaymentConfirmationCardState();
}

class _PaymentConfirmationCardState extends State<_PaymentConfirmationCard> {
  String? _channel;

  @override
  void initState() {
    super.initState();
    final ch = widget.confirmation.channels;
    if (ch.isNotEmpty) _channel = ch.first;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.confirmation;
    final colors = Theme.of(context).colorScheme;
    return CardGeneral(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment confirmation', style: AppFont.semibold14),
          const SizedBox(height: 10),
          for (final line in c.lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(line, style: AppFont.reguler12),
            ),
          const SizedBox(height: 8),
          const Text('Payment method', style: AppFont.medium14),
          Wrap(
            spacing: 8,
            children: [
              for (final ch in c.channels)
                ChoiceChip(
                  backgroundColor: colors.surface,
                  selectedColor: AppColor.primaryColor,
                  disabledColor: colors.shadow,

                  avatar: AiPaymentChannel.isWallet(ch)
                      ? const Icon(Icons.account_balance_wallet_outlined, size: 18)
                      : null,
                  label: Text(AiPaymentChannel.label(ch), style: AppFont.medium12),
                  selected: _channel == ch,
                  onSelected: widget.onPay == null ? null : (_) => setState(() => _channel = ch),
                ),
            ],
          ),
          const Divider(height: 20),
          _InfoRow(label: 'Amount', value: c.totalText, bold: true),
          const SizedBox(height: 8),
          Text('Payment will only be processed after your confirmation.', style: AppFont.reguler12),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onPay == null || _channel == null
                  ? null
                  : () => widget.onPay!(_channel!),
              child: Text(
                _channel == null ? 'Pay' : 'Pay with ${AiPaymentChannel.label(_channel!)}',
                style: AppFont.medium14.copyWith(color: AppColor.darkText1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStatusCard extends StatelessWidget {
  final AiTurnEntity turn;
  final VoidCallback? onRefresh;
  const _PaymentStatusCard({required this.turn, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final p = turn.payment!;
    final booking = turn.booking;
    final va = p.virtualAccountNo;

    return CardGeneral(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.isPaid ? 'Payment received' : 'Waiting for payment', style: AppFont.semibold14),
          const SizedBox(height: 10),
          if (booking != null)
            _InfoRow(label: 'Booking code', value: booking.bookingCode, bold: true),
          _InfoRow(label: 'Channel', value: p.channel),
          _InfoRow(label: 'Amount', value: p.amountText, bold: true),
          _InfoRow(label: 'Status', value: p.status),
          if (va != null && va.isNotEmpty && !p.isPaid)
            Row(
              children: [
                Expanded(
                  child: _InfoRow(label: 'Virtual account', value: va, bold: true),
                ),
                IconButton(
                  tooltip: 'Copy',
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  onPressed: () => Clipboard.setData(ClipboardData(text: va)),
                ),
              ],
            ),
          if (p.expiresAt != null && p.isPending)
            _InfoRow(
              label: 'Pay before',
              value: p.expiresAt!.toLocal().toString().substring(0, 16),
            ),
          if (p.isPending) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onRefresh,
                child: Text(
                  'Check payment status',
                  style: AppFont.medium12.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PassengerFormCard extends StatelessWidget {
  final VoidCallback? onFill;
  const _PassengerFormCard({this.onFill});

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Passenger details', style: AppFont.medium14),
          const SizedBox(height: 6),
          Text('Data penumpang diisi lewat formulir, bukan lewat chat.', style: AppFont.reguler12),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onFill,
              child: Text(
                'Fill passenger details',
                style: AppFont.medium12.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final VoidCallback? onRetry;
  const _ErrorCard({this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(top: 9),
      child: ListTile(
        leading: Icon(Icons.error_outline_rounded, color: colors.error),
        title: const Text('Something went wrong'),
        subtitle: const Text('Please try again.'),
        trailing: onRetry == null
            ? null
            : TextButton(onPressed: onRetry, child: const Text('Retry')),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _InfoRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppFont.medium12)),
          Text(value, style: AppFont.medium12),
        ],
      ),
    );
  }
}
