part of '../screen/flight_result_screen.dart';

class PriceDetail extends StatelessWidget {
  const PriceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CardGeneral(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price Detail", style: AppFont.medium14),
            height(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fare Adult 2x",
                  style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(2000000),
                  style: AppFont.medium14,
                ),
              ],
            ),
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fare Child 1x",
                  style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(1000000),
                  style: AppFont.medium14,
                ),
              ],
            ),
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tax", style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor)),
                Text(
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(1200000),
                  style: AppFont.medium14,
                ),
              ],
            ),
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service Fee",
                  style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(300000),
                  style: AppFont.medium14,
                ),
              ],
            ),
            height(8),
            SizedBox(height: 1, child: Divider(thickness: 1, color: Theme.of(context).hintColor)),
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(4500000),
                  style: AppFont.medium14.copyWith(color: AppColor.greenColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
