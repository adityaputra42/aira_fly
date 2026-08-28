part of '../screen/booking_detail_screen.dart';

class PriceDetail extends StatelessWidget {
  const PriceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Detail", style: AppFont.semibold16),
          height(8),
          CardPricePerSegment(),
          height(8),
          CardPricePerSegment(isReturn: true),

          height(8),
          SizedBox(height: 1, child: Divider(thickness: 1, color: Theme.of(context).hintColor)),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: AppFont.reguler14),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(8400000),
                style: AppFont.medium14.copyWith(color: AppColor.greenColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardPricePerSegment extends StatelessWidget {
  const CardPricePerSegment({super.key, this.isReturn = false});
  final bool isReturn;
  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(8),
      background: AppColor.secondaryColor.withValues(alpha: 0.1),
      useShadow: false,
      radius: 8,
      child: Column(
        children: [
          Row(
            children: [
              Text(isReturn ? "Denpasar (DPS)" : "Jakarta (CGK)", style: AppFont.medium14),
              width(8),
              Transform.rotate(
                angle: -math.pi / 0.66,
                child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20),
              ),
              width(8),
              Text(isReturn ? "Jakarta (CGK)" : "Denpasar (DPS)", style: AppFont.medium14),
            ],
          ),
          height(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fare Adult 2x",
                style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
              ),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(2000000),
                style: AppFont.medium12,
              ),
            ],
          ),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fare Child 1x",
                style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
              ),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(1000000),
                style: AppFont.medium12,
              ),
            ],
          ),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tax", style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(150000),
                style: AppFont.medium12,
              ),
            ],
          ),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Baggage",
                style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
              ),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(180000),
                style: AppFont.medium12,
              ),
            ],
          ),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Meal", style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(120000),
                style: AppFont.medium12,
              ),
            ],
          ),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Seat", style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
              Text(
                NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(750000),
                style: AppFont.medium12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
