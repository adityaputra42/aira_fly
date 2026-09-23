import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:intl/intl.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/utils/clipper.dart';
import '../../../../core/utils/dashed_divider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../flight/domain/entities/pnr_entity.dart';

class CardTikcetList extends StatelessWidget {
  const CardTikcetList({super.key, required this.pnr, required this.onTap});

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Aira Fly", style: AppFont.medium14),
                      Text(pnr.bookingCode ?? '', style: AppFont.reguler14),
                    ],
                  ),
                  height(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        first?.flightNumber ?? "",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                      CardGeneral(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        background: _statusColor(pnr.status).withValues(alpha: 0.12),
                        radius: 6,

                        child: Text(
                          pnr.status ?? '-',
                          style: AppFont.medium12.copyWith(color: _statusColor(pnr.status)),
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
                          "Jakarta",
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
                          "Denpasar",
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("CGK", style: AppFont.medium24),
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
                      Text("DPS", style: AppFont.medium24),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("HH:mm").format(DateTime.now()),
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
                        DateFormat("HH:mm")
                            .format(DateTime.now().add(Duration(hours: 2, minutes: 45))),
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
