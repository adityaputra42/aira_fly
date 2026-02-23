part of '../screen/flight_result_screen.dart';

class FlightTimeline extends StatelessWidget {
  const FlightTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CardGeneral(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
      ),
    );
  }
}
