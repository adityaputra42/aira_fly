import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/constants/images.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/utils/clipper.dart';
import '../../../../core/utils/dashed_divider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../flight/domain/entities/pnr_entity.dart';

class CardTikcetList extends StatelessWidget {
  const CardTikcetList({super.key, required this.pnr, required this.onTap});

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
      onTap: () {
        context.goNamed(RouteNames.ticketDetail);
      },
      child: Column(
        children: [
          ClipPath(
            clipper: TicketTopClipper(radius: 8),
            child: CardGeneral(
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      CardGeneral(
                        background: Theme.of(context).colorScheme.surface,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.zero,
                        radius: 8,
                        useShadow: false,
                        child: Image.asset(
                          AppImages.whiteLogo,
                          width: 28,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Aira Fly", style: AppFont.medium14),
                                Text(pnr.bookingCode ?? '', style: AppFont.reguler14),
                              ],
                            ),
                            height(2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pnr.flightNumber ?? "",
                                  style: AppFont.reguler12.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                CardGeneral(
                                  margin: EdgeInsets.zero,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  background: _statusColor(pnr.status).withValues(alpha: 0.12),
                                  radius: 4,

                                  child: Text(
                                    pnr.paymentStatus ?? '-',
                                    style: AppFont.medium10.copyWith(
                                      color: _statusColor(pnr.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  height(16),
                  generateDashedDivider(context.w(0.82)),
                ],
              ),
            ),
          ),
          ClipPath(
            clipper: TicketBottomClipper(radius: 8),
            child: CardGeneral(
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pnr.departureCity ?? "",
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("dd MMM yyyy").format(DateTime.now()),
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pnr.arrivalCity ?? "",
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(pnr.departure ?? '', style: AppFont.medium24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            generateDashedDivider(
                              context.w(0.15),
                              dashColor: AppColor.secondaryColor,
                            ),
                            width(4),
                            Transform.rotate(
                              angle: -math.pi / 0.66,
                              child: Iconify(
                                Bx.bxs_plane,
                                color: AppColor.secondaryColor,
                                size: 20,
                              ),
                            ),
                            width(4),
                            generateDashedDivider(
                              context.w(0.15),
                              dashColor: AppColor.secondaryColor,
                            ),
                          ],
                        ),
                      ),
                      Text(pnr.arrival ?? '', style: AppFont.medium24),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("HH:mm").format(pnr.departureTime ?? DateTime.now()),
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                      Expanded(
                        child: Text(
                          "2h 45m",
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        DateFormat("HH:mm").format(pnr.arrivalTime ?? DateTime.now()),
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
