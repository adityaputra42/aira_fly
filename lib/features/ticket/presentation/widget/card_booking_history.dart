import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/entities/pnr_entity.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

class CardBookingHistory extends StatelessWidget {
  const CardBookingHistory({super.key, required this.pnr, required this.onTap});

  final PnrDetailEntity pnr;
  final VoidCallback onTap;

  Color _statusColor(String? status) {
    switch (status) {
      case 'BOOKED':
        return AppColor.greenColor;
      case 'HOLD':
        return Colors.orange;
      case 'CANCELLED':
      case 'EXPIRED':
        return Colors.red;
      default:
        return AppColor.greenColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final segments = pnr.segments;
    final first = segments.isNotEmpty ? segments.first : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: CardGeneral(
        width: double.infinity,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(pnr.bookingCode ?? '-', style: AppFont.semibold16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(pnr.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    pnr.status ?? '-',
                    style: AppFont.medium12.copyWith(color: _statusColor(pnr.status)),
                  ),
                ),
              ],
            ),
            if (first != null) ...[
              height(6),
              Text(
                segments.length > 1
                    ? "${first.flightNumber ?? '-'} +${segments.length - 1} more"
                    : (first.flightNumber ?? '-'),
                style: AppFont.medium14,
              ),
              height(4),
              Text(
                first.departureTime == null
                    ? '-'
                    : DateFormat('dd MMM yyyy, HH:mm').format(first.departureTime!),
                style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
            height(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${pnr.passengers.length} passenger(s)",
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(
                  formatIDR(pnr.totalAmount ?? 0),
                  style: AppFont.medium14.copyWith(color: AppColor.secondaryColor),
                ),
              ],
            ),
            if (pnr.status == 'HOLD' && pnr.holdExpiresAt != null) ...[
              height(4),
              Text(
                'Pay before ${DateFormat('dd MMM yyyy, HH:mm').format(pnr.holdExpiresAt!)}',
                style: AppFont.reguler12.copyWith(color: Colors.orange.shade800),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
