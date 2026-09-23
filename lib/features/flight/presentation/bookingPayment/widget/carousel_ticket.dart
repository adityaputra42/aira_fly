part of '../screen/booking_detail_screen.dart';

class CarouselTicket extends StatefulWidget {
  const CarouselTicket({super.key, required this.legs});

  final List<TicketLeg> legs;

  @override
  State<CarouselTicket> createState() => _CarouselTicketState();
}

class TicketLeg {
  final String label;
  final ItineraryEntity itinerary;
  final String? bookingCode;
  final String paxLabel;
  final String? seatsLabel;
  final String? baggageLabel;
  final String? mealsLabel;

  const TicketLeg({
    required this.label,
    required this.itinerary,
    this.bookingCode,
    required this.paxLabel,
    this.seatsLabel,
    this.baggageLabel,
    this.mealsLabel,
  });
}

class _CarouselTicketState extends State<CarouselTicket> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.legs.isEmpty) return const SizedBox.shrink();
    if (widget.legs.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildCard(widget.legs.first),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.legs.length,
          itemBuilder: (context, index, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              child: _buildCard(widget.legs[index]),
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            disableCenter: true,
            aspectRatio: 35 / 36,
            height: null,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        widget.height(4),
        _CarouselIndicator(
          pageLength: widget.legs.length,
          pageIndex: currentIndex,
          carouselDuration: const Duration(seconds: 1),
        ),
      ],
    );
  }

  Widget _buildCard(TicketLeg leg) {
    return CardTicketBookingDetail(
      legLabel: leg.label,
      itinerary: leg.itinerary,
      bookingCode: leg.bookingCode,
      paxLabel: leg.paxLabel,
      seatsLabel: leg.seatsLabel,
      baggageLabel: leg.baggageLabel,
      mealsLabel: leg.mealsLabel,
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  final Duration carouselDuration;
  final int pageIndex;
  final int pageLength;

  const _CarouselIndicator({
    required this.pageIndex,
    required this.pageLength,
    required this.carouselDuration,
  });

  final double activeLength = 32;
  final double inactiveLength = 8;

  final double borderRadius = 999;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageLength, (index) {
        final bool isActive = pageIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: isActive ? activeLength : inactiveLength,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              width: isActive ? activeLength : inactiveLength,
              height: inactiveLength,
              duration: carouselDuration,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
              child: Container(
                decoration: BoxDecoration(
                  color: isActive ? AppColor.secondaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
