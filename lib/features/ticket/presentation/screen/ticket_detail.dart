

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';

import '../../../../app/init_dependencies.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/utils/widget_helper.dart';
import '../../../flight/domain/entities/itinerary_entity.dart';
import '../../../flight/domain/entities/pnr_entity.dart';
import '../../../flight/presentation/bloc/booking/booking_bloc.dart';
import '../../../flight/presentation/bookingPayment/screen/booking_detail_screen.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key, required this.bookingCode});

  final String bookingCode;

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late final BookingBloc _bookingBloc;

  @override
  void initState() {
    super.initState();
    _bookingBloc = serviceLocator<BookingBloc>();
    _bookingBloc.add(LoadPnrByBookingCodeRequested(bookingCode: widget.bookingCode));
  }

  String _paxLabel(List<PassengerDetailEntity> passengers) {
    if (passengers.isEmpty) return '-';
    final adult = passengers.where((p) => p.passengerType == 'ADT').length;
    final child = passengers.where((p) => p.passengerType == 'CHD').length;
    final infant = passengers.where((p) => p.passengerType == 'INF').length;

    final parts = <String>[];
    if (adult > 0) parts.add("$adult Adult");
    if (child > 0) parts.add("$child Child");
    if (infant > 0) parts.add("$infant Infant");
    return parts.isEmpty ? '-' : parts.join(', ');
  }
  String _passengerLabel(PassengerDetailEntity passenger ) {

    final parts = [if (passenger.title != null) passenger.title, passenger.firstName, if (passenger.lastName != null) passenger.lastName];
    return parts.whereType<String>().join(' ');
  }
  String? _seatsLabel(PnrDetailEntity pnr, int? segmentId) {
    if (segmentId == null) return null;
    final seats = pnr.seats
        .where((s) => s.segmentId == segmentId)
        .map((s) => s.seatNumber)
        .whereType<String>()
        .toList();
    return seats.isEmpty ? null : seats.join(', ');
  }

  List<TicketLeg> _buildLegs(PnrDetailEntity pnr) {
    final paxLabel = _paxLabel(pnr.passengers);
    final segments = pnr.segments;

    String legLabel(int index) {
      if (segments.length == 1) return "Flight Detail";
      if (segments.length == 2) return index == 0 ? "Departure Flight" : "Return Flight";
      return "Flight ${index + 1}";
    }

    return List.generate(segments.length, (index) {
      final segment = segments[index];
      final duration = (segment.departureTime != null && segment.arrivalTime != null)
          ? segment.arrivalTime!.difference(segment.departureTime!).inMinutes
          : null;

      return TicketLeg(
        label: legLabel(index),
        bookingCode: pnr.bookingCode,
        paxLabel: paxLabel,
        seatsLabel: _seatsLabel(pnr, segment.id),
        itinerary: ItineraryEntity(
          stops: 0,
          durationMinutes: duration,
          segments: [
            SegmentEntity(
              flightId: segment.flightId,
              flightNumber: segment.flightNumber,
              departureTime: segment.departureTime,
              departureAirportCity: segment.departureCity,
              departureAirportCode: segment.departure,
              departureAirportName: segment.departureName,
              arrivalAirportCode: segment.arrival,
              arrivalAirportCity: segment.arrivalCity,
              arrivalAirportName: segment.arrivalName,
              arrivalTime: segment.arrivalTime,
              status: segment.status,
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Detail Ticket",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        bloc: _bookingBloc,
        builder: (context, state) {
          if (state is BookingError) {
            return Empty(
              title: state.message,
              actionLabel: 'Retry',
              onAction: () =>
                  _bookingBloc.add(LoadPnrByBookingCodeRequested(bookingCode: widget.bookingCode)),
            );
          }

          if (state is! PnrByBookingCodeLoaded) {
            return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor));
          }

          final pnr = state.pnr;

          return ListView(
            children: [
              widget.height(12),
              CarouselTicket(legs: _buildLegs(pnr)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Contact", style: AppFont.medium14),
              ),
              widget.height(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CardGeneral(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pnr.contactName??"", style: AppFont.medium14),
                      widget.height(4),
                      if (pnr.contactEmail != null)
                        Text(
                          pnr.contactEmail??'',
                          style: AppFont.reguler12.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      Text(
                        pnr.contactPhone??'',
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
              ),
              widget.height(16),
              // Passenger detail.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Passengers", style: AppFont.medium14),
              ),
              widget.height(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CardGeneral(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (var i = 0; i < pnr.passengers .length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == pnr.passengers.length - 1 ? 0 : 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_passengerLabel(pnr.passengers[i]), style: AppFont.reguler14),
                              Text(
                                pnr.passengers[i].passengerType??"",
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              PriceDetail(
                segments: const [],
                total: pnr.totalAmount ?? 0,
                currency: pnr.currency ?? 'IDR',
              ),
              PrimaryButton(
                title: "Print Ticket",
                onPressed: () {},
                margin: EdgeInsets.fromLTRB(16, 8, 16, 24),
              ),
            ],
          );
        },
      ),
    );
  }
}
