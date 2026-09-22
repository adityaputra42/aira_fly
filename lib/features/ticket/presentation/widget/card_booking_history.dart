import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/entities/pnr_entity.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

class CardBookingHistory extends StatelessWidget {
  const CardBookingHistory({super.key, required this.pnr, required this.onTap});

  final PnrSummaryEntity pnr;
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
            height(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pnr.createdAt == null
                      ? '-'
                      : DateFormat('dd MMM yyyy, HH:mm').format(pnr.createdAt!),
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(
                  formatIDR(pnr.totalAmount ?? 0),
                  style: AppFont.medium14.copyWith(color: AppColor.primaryColor),
                ),
              ],
            ),
            if (pnr.status == 'HOLD' && pnr.expiresAt != null) ...[
              height(4),
              Text(
                'Pay before ${DateFormat('dd MMM yyyy, HH:mm').format(pnr.expiresAt!)}',
                style: AppFont.reguler12.copyWith(color: Colors.orange.shade800),
              ),
            ],
            height(4),
            Text(
              'Payment: ${pnr.paymentStatus ?? '-'}',
              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
