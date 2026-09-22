import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/entities/pnr_entity.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

Future<void> showBookingDetailSheet(BuildContext context, PnrDetailEntity pnr) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => _BookingDetailSheet(pnr: pnr),
  );
}

class _BookingDetailSheet extends StatelessWidget {
  const _BookingDetailSheet({required this.pnr});

  final PnrDetailEntity pnr;

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AppFont.medium14),
  );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            height(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(pnr.bookingCode ?? '-', style: AppFont.semibold20),
                Text(
                  pnr.status ?? '-',
                  style: AppFont.medium14.copyWith(color: AppColor.primaryColor),
                ),
              ],
            ),
            height(4),
            Text(
              'Payment: ${pnr.paymentStatus ?? '-'}  ·  ${formatIDR(pnr.totalAmount ?? 0)}',
              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
            ),
            if (pnr.status == 'HOLD' && pnr.holdExpiresAt != null) ...[
              height(4),
              Text(
                'Pay before ${DateFormat('dd MMM yyyy, HH:mm').format(pnr.holdExpiresAt!)}',
                style: AppFont.reguler12.copyWith(color: Colors.orange.shade800),
              ),
            ],
            height(20),
            _sectionTitle('Contact'),
            Text(pnr.contactName ?? '-', style: AppFont.reguler14),
            if ((pnr.contactEmail ?? '').isNotEmpty)
              Text(pnr.contactEmail!, style: AppFont.reguler12),
            Text(pnr.contactPhone ?? '-', style: AppFont.reguler12),
            height(20),
            _sectionTitle('Passengers (${pnr.passengers.length})'),
            for (final p in pnr.passengers)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  [
                    if (p.title != null) p.title,
                    p.firstName,
                    p.lastName,
                  ].whereType<String>().join(' '),
                  style: AppFont.reguler14,
                ),
              ),
            if (pnr.passengers.isEmpty) Text('-', style: AppFont.reguler14),
            height(20),
            _sectionTitle('Flights (${pnr.segments.length})'),
            for (final s in pnr.segments)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.flightNumber ?? '-', style: AppFont.medium14),
                    Text(
                      s.departureTime == null
                          ? '-'
                          : DateFormat('dd MMM, HH:mm').format(s.departureTime!),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            if (pnr.segments.isEmpty) Text('-', style: AppFont.reguler14),
            if (pnr.ancillaries.isNotEmpty) ...[
              height(20),
              _sectionTitle('Add-ons (${pnr.ancillaries.length})'),
              for (final a in pnr.ancillaries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${a.ancillaryName ?? '-'} x${a.quantity ?? 1}',
                          style: AppFont.reguler14,
                        ),
                      ),
                      Text(formatIDR(a.totalPrice ?? 0), style: AppFont.reguler12),
                    ],
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
