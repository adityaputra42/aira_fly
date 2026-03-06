part of '../screen/wallet_screen.dart';

class CardTransactionHistory extends StatelessWidget {
  const CardTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      radius: 6,
      margin: EdgeInsets.zero,
      useShadow: false,
      padding: EdgeInsets.fromLTRB(6, 6, 12, 6),
      background: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          CardGeneral(
            margin: EdgeInsets.zero,
            useShadow: false,
            background: AppColor.secondaryColor.withValues(alpha: 0.1),
            padding: EdgeInsets.all(8),
            radius: 4,
            child: Iconify(Mdi.instant_deposit, size: 24, color: AppColor.secondaryColor),
          ),
          width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Top Up Balance", style: AppFont.medium14),
                height(2),
                Text(
                  DateFormat("dd MMM yyyy, HH:mm:ss").format(DateTime.now()),
                  style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          Text(
            NumberFormat.currency(locale: "id_ID", symbol: "Rp ", decimalDigits: 0).format(120000),
            style: AppFont.medium14.copyWith(color: AppColor.greenColor),
          ),
        ],
      ),
    );
  }
}
