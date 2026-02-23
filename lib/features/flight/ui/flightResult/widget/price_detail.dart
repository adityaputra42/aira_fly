part of '../screen/flight_result_screen.dart';

class PriceDetail extends StatelessWidget {
  const PriceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CardGeneral(margin: EdgeInsets.symmetric(horizontal: 16)),
    );
  }
}
