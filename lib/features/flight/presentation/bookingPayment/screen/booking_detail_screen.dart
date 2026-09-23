import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/dropdown_custom.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/utils/clipper.dart';
import 'package:pss_app/core/utils/dashed_divider.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/flight/domain/entities/itinerary_entity.dart';
import 'package:pss_app/features/flight/domain/entities/payment_entity.dart';
import 'package:pss_app/features/flight/domain/entities/pnr_entity.dart';
import 'package:pss_app/features/flight/domain/repository/booking_repository.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/bloc/ancillary/ancillary_bloc.dart';
import 'package:pss_app/features/flight/presentation/bloc/booking/booking_bloc.dart';
import 'package:pss_app/features/flight/presentation/bloc/payment/payment_bloc.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

import '../../../../../app/init_dependencies.dart';
import '../../../../../app/routes/route_names.dart';
import '../../flightResult/screen/flight_result_screen.dart';

part '../widget/card_ticket_booking_detail.dart';
part '../widget/carousel_ticket.dart';
part '../widget/price_detail.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key, required this.result});

  final AddonBookingResult result;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

enum _Step { review, processing, done, error }

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late final BookingBloc _bookingBloc;
  late final AncillaryBloc _ancillaryBloc;
  late final PaymentBloc _paymentBloc;

  _Step _step = _Step.review;
  String? _processingMessage;
  String? _errorMessage;

  PnrDetailEntity? _pnr;
  final List<String> _ancillaryFailures = [];
  String _paymentMethod = 'DOKU_VA';
  CreatePaymentResponseEntity? _payment;

  @override
  void initState() {
    super.initState();
    _bookingBloc = serviceLocator<BookingBloc>();
    _ancillaryBloc = serviceLocator<AncillaryBloc>();
    _paymentBloc = serviceLocator<PaymentBloc>();
  }

  FlightResultArguments get _search => widget.result.paxBookingResult.searchArguments;
  ContactInput get _contact => widget.result.paxBookingResult.contact;
  List<PassengerInput> get _passengers => widget.result.paxBookingResult.passengers;

  List<SegmentEntity> get _allSegments => [
    ...(_search.departure.segments ?? const []),
    ...(_search.returnItinerary?.segments ?? const []),
  ];
  double get _estimatedTotal {
    final departureFare = _search.departureFare; // CHANGED
    final returnFare = _search.returnFare; // CHANGED
    final fareTotal =
        FareCalculator.totalForFare(departureFare, _search.pax) +
        (returnFare != null ? FareCalculator.totalForFare(returnFare, _search.pax) : 0);
    return fareTotal +
        sumAncillaryPrices(widget.result.baggage) +
        sumAncillaryPrices(widget.result.meals);
  }

  String _passengerLabel(int index) {
    final p = _passengers[index];
    final parts = [if (p.title != null) p.title, p.firstName, if (p.lastName != null) p.lastName];
    return parts.whereType<String>().join(' ');
  }

  Future<void> _confirmAndPay() async {
    setState(() {
      _step = _Step.processing;
      _errorMessage = null;
    });

    var pnr = _pnr;

    if (pnr == null) {
      setState(() => _processingMessage = "Creating your booking...");

      final departureFare = _search.departureFare;
      final returnFare = _search.returnFare;

      if (departureFare.fareClassId == null ||
          (_search.isRoundTrip && returnFare?.fareClassId == null)) {
        setState(() {
          _step = _Step.error;
          _errorMessage =
              "This itinerary has no available fare class to book. Please search again.";
        });
        return;
      }

      final segments = <BookingSegmentInput>[
        for (final s in _search.departure.segments ?? const [])
          if (s.flightId != null)
            BookingSegmentInput(flightId: s.flightId!, fareClassId: departureFare.fareClassId!),
        if (_search.returnItinerary != null)
          for (final s in _search.returnItinerary!.segments ?? const [])
            if (s.flightId != null)
              BookingSegmentInput(flightId: s.flightId!, fareClassId: returnFare!.fareClassId!),
      ];

      final allSegments = _allSegments;
      final seatSelections = <SeatSelectionInput>[
        for (final selected in widget.result.seats)
          if (() {
            final idx = allSegments.indexWhere((s) => s.flightId == selected.flightId);
            return idx != -1;
          }())
            SeatSelectionInput(
              passengerIndex: selected.passengerIndex,
              segmentIndex: allSegments.indexWhere((s) => s.flightId == selected.flightId),
              flightSeatId: selected.seat.id!,
            ),
      ];

      _bookingBloc.add(
        CreatePnrRequested(
          contact: _contact,
          passengers: _passengers,
          segments: segments,
          seatSelections: seatSelections,
        ),
      );

      final bookingResult = await _bookingBloc.stream.firstWhere(
        (s) => s is PnrCreated || s is BookingError,
      );

      if (!mounted) return;

      if (bookingResult is BookingError) {
        setState(() {
          _step = _Step.review;
          _errorMessage = bookingResult.message;
        });
        return;
      }

      pnr = (bookingResult as PnrCreated).pnr;
      setState(() => _pnr = pnr);

      await _purchaseAncillaries(pnr);
      if (!mounted) return;
    }

    setState(() => _processingMessage = "Processing payment...");

    _paymentBloc.add(CreatePaymentRequested(pnrId: pnr.id!, paymentMethod: _paymentMethod));

    final result = await _paymentBloc.stream.firstWhere(
      (s) => s is PaymentCreated || s is PaymentError,
    );

    if (!mounted) return;

    if (result is PaymentError) {
      setState(() {
        _step = _Step.review;
        _errorMessage = result.message;
      });
      return;
    }

    setState(() {
      _payment = (result as PaymentCreated).payment;
      if (_payment?.pnr != null) _pnr = _payment!.pnr;
      _step = _Step.done;
    });
  }

  Future<void> _purchaseAncillaries(PnrDetailEntity pnr) async {
    final allSelections = [...widget.result.baggage, ...widget.result.meals];
    if (allSelections.isEmpty) return;

    setState(() => _processingMessage = "Adding your baggage and meal selections...");

    for (final selection in allSelections) {
      int? matchedSegmentId;
      for (final seg in pnr.segments) {
        if (seg.flightId == selection.flightId) {
          matchedSegmentId = seg.id;
          break;
        }
      }
      final matchedPassengerId = selection.passengerIndex < pnr.passengers.length
          ? pnr.passengers[selection.passengerIndex].id
          : null;

      _ancillaryBloc.add(
        PurchaseAncillaryRequested(
          pnrId: pnr.id!,
          passengerId: matchedPassengerId,
          segmentId: matchedSegmentId,
          ancillaryId: selection.item.id!,
          flightId: selection.flightId,
          quantity: 1,
        ),
      );

      final result = await _ancillaryBloc.stream.firstWhere(
        (s) => s is AncillaryPurchased || s is AncillaryError,
      );

      if (result is AncillaryError) {
        _ancillaryFailures.add("${selection.item.name ?? 'Item'}: ${result.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bookingBloc),
        BlocProvider.value(value: _ancillaryBloc),
        BlocProvider.value(value: _paymentBloc),
      ],
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          context: context,
          title: "Booking Detail",
          color: AppColor.primaryColor,
          titleColor: AppColor.darkText1,
        ),
        body: SafeArea(
          child: switch (_step) {
            _Step.review => _buildReview(context),
            _Step.processing => _buildProcessing(context),
            _Step.done => _buildDone(context),
            _Step.error => _buildError(context),
          },
        ),
      ),
    );
  }

  List<TicketLeg> _buildLegs() {
    String paxLabel() {
      final parts = <String>[];
      if (_search.amountAdult > 0) parts.add("${_search.amountAdult} Adult");
      if (_search.amountChild > 0) parts.add("${_search.amountChild} Child");
      if (_search.amountInfant > 0) parts.add("${_search.amountInfant} Infant");
      return parts.isEmpty ? '-' : parts.join(', ');
    }

    String? labelForLeg(Set<int> flightIds) {
      final seats = widget.result.seats.where((s) => flightIds.contains(s.flightId)).toList();
      return seats.isEmpty ? null : seats.map((s) => s.seat.seatNumber ?? '-').join(', ');
    }

    String? baggageForLeg(Set<int> flightIds) {
      final items = widget.result.baggage.where((s) => flightIds.contains(s.flightId)).toList();
      return items.isEmpty ? null : items.map((s) => s.item.name ?? '-').join(', ');
    }

    String? mealsForLeg(Set<int> flightIds) {
      final items = widget.result.meals.where((s) => flightIds.contains(s.flightId)).toList();
      return items.isEmpty ? null : items.map((s) => s.item.name ?? '-').join(', ');
    }

    final legs = <TicketLeg>[];

    final departureFlightIds = (_search.departure.segments ?? const [])
        .map((s) => s.flightId)
        .whereType<int>()
        .toSet();
    legs.add(
      TicketLeg(
        label: _search.isRoundTrip ? "Departure Flight" : "Flight Detail",
        itinerary: _search.departure,
        bookingCode: _pnr?.bookingCode,
        paxLabel: paxLabel(),
        seatsLabel: labelForLeg(departureFlightIds),
        baggageLabel: baggageForLeg(departureFlightIds),
        mealsLabel: mealsForLeg(departureFlightIds),
      ),
    );

    if (_search.returnItinerary != null) {
      final returnFlightIds = (_search.returnItinerary!.segments ?? const [])
          .map((s) => s.flightId)
          .whereType<int>()
          .toSet();
      legs.add(
        TicketLeg(
          label: "Return Flight",
          itinerary: _search.returnItinerary!,
          bookingCode: _pnr?.bookingCode,
          paxLabel: paxLabel(),
          seatsLabel: labelForLeg(returnFlightIds),
          baggageLabel: baggageForLeg(returnFlightIds),
          mealsLabel: mealsForLeg(returnFlightIds),
        ),
      );
    }

    return legs;
  }

  List<FareSegmentBreakdown> _buildFareBreakdown() {
    FareSegmentBreakdown breakdown(String routeLabel, ItineraryFareEntity fare) {
      final lines = <FareLineItem>[];
      double subtotal = 0;
      for (final entry in [
        ('ADT', 'Adult', _search.amountAdult),
        ('CHD', 'Child', _search.amountChild),
        ('INF', 'Infant', _search.amountInfant),
      ]) {
        final (code, label, count) = entry;
        if (count <= 0) continue;
        final price = FareCalculator.priceForType(fare, code);
        if (price <= 0) continue;
        lines.add(FareLineItem(label: "Fare $label ${count}x", amount: price * count));
        subtotal += price * count;
      }
      return FareSegmentBreakdown(routeLabel: routeLabel, lines: lines, subtotal: subtotal);
    }

    String routeLabel(bool isReturn) {
      final origin = isReturn ? _search.arrivalAirport : _search.departureAirport;
      final dest = isReturn ? _search.departureAirport : _search.arrivalAirport;
      return "${origin.city ?? origin.code ?? '-'} (${origin.code ?? '-'}) \u2192 "
          "${dest.city ?? dest.code ?? '-'} (${dest.code ?? '-'})";
    }

    final segments = <FareSegmentBreakdown>[breakdown(routeLabel(false), _search.departureFare)];
    final returnFare = _search.returnFare;
    if (returnFare != null) {
      segments.add(breakdown(routeLabel(true), returnFare));
    }
    return segments;
  }

  Widget _buildReview(BuildContext context) {
    final fareSegments = _buildFareBreakdown();
    final isRetryingPayment = _pnr != null;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final isLoggedIn = userState is UserLoggedIn;

        if (!isLoggedIn && _paymentMethod == 'BALANCE') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _paymentMethod = 'DOKU_VA');
          });
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Text(
                          _errorMessage!,
                          style: AppFont.reguler12.copyWith(color: Colors.red),
                        ),
                      ),
                    if (_ancillaryFailures.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Some addons could not be attached:",
                              style: AppFont.medium12.copyWith(color: Colors.orange.shade800),
                            ),
                            widget.height(4),
                            for (final failure in _ancillaryFailures)
                              Text(
                                "\u2022 $failure",
                                style: AppFont.reguler12.copyWith(color: Colors.orange.shade800),
                              ),
                          ],
                        ),
                      ),
                    // Booking Detail -- real flight/segment data per leg.
                    CarouselTicket(legs: _buildLegs()),
                    widget.height(4),
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
                            Text(_contact.fullName, style: AppFont.medium14),
                            widget.height(4),
                            if (_contact.email != null)
                              Text(
                                _contact.email!,
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            Text(
                              _contact.phone,
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
                            for (var i = 0; i < _passengers.length; i++)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: i == _passengers.length - 1 ? 0 : 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_passengerLabel(i), style: AppFont.reguler14),
                                    Text(
                                      _passengers[i].passengerType,
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
                    // Price Detail -- real fare breakdown + ancillary totals.
                    PriceDetail(
                      segments: fareSegments,
                      baggageTotal: sumAncillaryPrices(widget.result.baggage),
                      mealTotal: sumAncillaryPrices(widget.result.meals),
                      total: _pnr?.totalAmount ?? _estimatedTotal,
                    ),
                    // Payment method.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Payment Method", style: AppFont.medium14),
                    ),
                    widget.height(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropDownCustom(
                        filled: true,
                        filledColor: Theme.of(context).colorScheme.surface,
                        hint: "Select payment method",
                        value: _paymentMethod,
                        onChange: (value) => setState(() => _paymentMethod = value as String),
                        listData: [
                          DropdownItem<String>(
                            value: 'DOKU_VA',
                            child: Text("Virtual Account (DOKU)", style: AppFont.reguler12),
                          ),
                          if (isLoggedIn)
                            DropdownItem<String>(
                              value: 'BALANCE',
                              child: Text("Wallet Balance", style: AppFont.reguler12),
                            ),
                        ],
                      ),
                    ),
                    if (!isLoggedIn) ...[
                      widget.height(4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Sign in to also pay with your wallet balance.",
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _bottomBar(
              label: isRetryingPayment ? "Total" : "Estimated Total",
              amount: _pnr?.totalAmount ?? _estimatedTotal,
              buttonLabel: isRetryingPayment ? "Retry Payment" : "Confirm & Pay",
              onPressed: () {
                if (_paymentMethod == 'BALANCE' && !isLoggedIn) {
                  setState(() => _errorMessage = "Sign in to pay with your wallet balance.");
                  return;
                }
                _confirmAndPay();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProcessing(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColor.primaryColor),
          widget.height(16),
          Text(
            _processingMessage ?? "Please wait...",
            style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDone(BuildContext context) {
    final payment = _payment?.payment;
    final isInstantlyPaid = payment?.virtualAccountNo == null || payment!.virtualAccountNo!.isEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: AppColor.greenColor, size: 64),
            widget.height(16),
            Text(
              isInstantlyPaid ? "Payment Successful" : "Booking Confirmed",
              style: AppFont.semibold20,
              textAlign: TextAlign.center,
            ),
            widget.height(8),
            Text("Booking code: ${_pnr?.bookingCode ?? '-'}", style: AppFont.medium14),
            if (!isInstantlyPaid) ...[
              widget.height(16),
              CardGeneral(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Transfer to this Virtual Account",
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                    widget.height(4),
                    Text(payment.virtualAccountNo ?? '-', style: AppFont.semibold20),
                    widget.height(8),
                    Text(
                      formatIDR(payment.amount ?? 0),
                      style: AppFont.medium16.copyWith(color: AppColor.primaryColor),
                    ),
                    if (payment.expiredAt != null) ...[
                      widget.height(4),
                      Text(
                        "Expires at ${payment.expiredAt}",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            widget.height(24),
            PrimaryButton(title: "Back to Home", onPressed: () => context.goNamed(RouteNames.main)),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
            widget.height(16),
            Text(
              _errorMessage ?? "Something went wrong.",
              style: AppFont.reguler14,
              textAlign: TextAlign.center,
            ),
            widget.height(24),
            PrimaryButton(
              title: "Try Again",
              onPressed: () => setState(() => _step = _Step.review),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar({
    required String label,
    required double amount,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 0.5,
              offset: const Offset(0, 0.5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: AppFont.reguler12),
                Text(formatIDR(amount), style: AppFont.medium14),
              ],
            ),
            PrimaryButton(
              title: buttonLabel,
              onPressed: onPressed,
              width: context.w(0.4),
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
