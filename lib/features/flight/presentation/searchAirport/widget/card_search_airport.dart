part of '../screen/search_airport_screen.dart';

class CardSearchAirport extends StatelessWidget {
  const CardSearchAirport({super.key, required this.airport});

  final AirportEntity airport;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(airport),
      child: CardGeneral(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColor.secondaryColor.withValues(alpha: 0.1),
              ),
              child: Center(child: Iconify(Mdi.airplane, color: AppColor.secondaryColor)),
            ),
            width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          airport.city ?? '-',
                          style: AppFont.medium14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      width(8),
                      Text(
                        "(${airport.code ?? '-'})",
                        style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                  height(4),
                  Text(
                    airport.name ?? '-',
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
