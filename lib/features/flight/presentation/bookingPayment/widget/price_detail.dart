part of '../screen/booking_detail_screen.dart';

class FareLineItem {
  final String label;
  final double amount;

  const FareLineItem({required this.label, required this.amount});
}

class FareSegmentBreakdown {
  final String routeLabel;
  final List<FareLineItem> lines;
  final double subtotal;

  const FareSegmentBreakdown({
    required this.routeLabel,
    required this.lines,
    required this.subtotal,
  });
}

class PriceDetail extends StatelessWidget {
  const PriceDetail({
    super.key,
    required this.segments,
    this.baggageTotal = 0,
    this.mealTotal = 0,
    required this.total,
    this.currency = 'IDR',
  });

  final List<FareSegmentBreakdown> segments;
  final double baggageTotal;
  final double mealTotal;
  final double total;
  final String currency;

  String _format(double value) =>
      currency == 'IDR' ? formatIDR(value) : '$currency ${value.toStringAsFixed(2)}';

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
          for (var i = 0; i < segments.length; i++) ...[
            if (i > 0) height(8),
            CardPricePerSegment(segment: segments[i]),
          ],
          if (baggageTotal > 0) ...[
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Baggage", style: AppFont.reguler14),
                Text(_format(baggageTotal), style: AppFont.medium14),
              ],
            ),
          ],
          if (mealTotal > 0) ...[
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Meal", style: AppFont.reguler14),
                Text(_format(mealTotal), style: AppFont.medium14),
              ],
            ),
          ],
          height(8),
          SizedBox(height: 1, child: Divider(thickness: 1, color: Theme.of(context).hintColor)),
          height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: AppFont.reguler14),
              Text(_format(total), style: AppFont.medium14.copyWith(color: AppColor.greenColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class CardPricePerSegment extends StatelessWidget {
  const CardPricePerSegment({super.key, required this.segment});

  final FareSegmentBreakdown segment;

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
            children: [Expanded(child: Text(segment.routeLabel, style: AppFont.medium14))],
          ),
          height(12),
          for (final line in segment.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    line.label,
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                  Text(formatIDR(line.amount), style: AppFont.medium12),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
