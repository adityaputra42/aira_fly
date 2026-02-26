part of '../screen/booking_detail_screen.dart';

class CarouselTicket extends StatefulWidget {
  const CarouselTicket({super.key});

  @override
  State<CarouselTicket> createState() => _CarouselTicketState();
}

class _CarouselTicketState extends State<CarouselTicket> {
  List<String> segment = ["1", "2", "3", "4"];
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 4,
          itemBuilder: (context, index, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              child: CardTicketBookingDetail(),
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            disableCenter: true,
            aspectRatio: 9 / 12,
            height: null,
            enableInfiniteScroll: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        widget.height(4),
        _CarouselIndicator(
          pageLength: segment.length,
          pageIndex: currentIndex,
          carouselDuration: const Duration(seconds: 1),
        ),
      ],
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
