part of '../screen/search_airport_screen.dart';

class CardSearchAirport extends StatelessWidget {
  const CardSearchAirport({super.key});

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColor.secondaryColor.withValues(alpha: 0.1),
            ),
            child: Center(child: Iconify(Mdi.plane, color: AppColor.secondaryColor)),
          ),
          width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Jakarta", style: AppFont.medium14),
                    width(8),
                    Text(
                      "(CGK)",
                      style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                height(4),
                Text(
                  "Soekarno Hatta",
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
