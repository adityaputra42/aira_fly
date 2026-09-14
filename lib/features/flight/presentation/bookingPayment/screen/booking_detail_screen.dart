import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/common/widget/secondary_button.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
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

enum _Step { review, processing, paymentMethod, done, error }

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late final BookingBloc _bookingBloc;
  late final AncillaryBloc _ancillaryBloc;
  late final PaymentBloc _paymentBloc;

  _Step _step = _Step.review;
  String? _processingMessage;
  String? _errorMessage;

  PnrEntity? _pnr;
  final List<String> _ancillaryFailures = [];
  String _paymentMethod = 'DOKU_VA';
  PaymentEntity? _payment;

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

  Future<void> _confirmBooking() async {
    setState(() {
      _step = _Step.processing;
      _processingMessage = "Creating your booking...";
      _errorMessage = null;
    });

    final departureFare = _search.departureFare; // CHANGED
    final returnFare = _search.returnFare; // CHANGED

    if (departureFare.fareClassId == null ||
        (_search.isRoundTrip && returnFare?.fareClassId == null)) {
      setState(() {
        _step = _Step.error;
        _errorMessage = "This itinerary has no available fare class to book. Please search again.";
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
        _step = _Step.error;
        _errorMessage = bookingResult.message;
      });
      return;
    }

    final pnr = (bookingResult as PnrCreated).pnr;
    setState(() => _pnr = pnr);

    await _purchaseAncillaries(pnr.pnrId!);
    if (!mounted) return;

    setState(() => _step = _Step.paymentMethod);
  }

  Future<void> _purchaseAncillaries(int pnrId) async {
    final allSelections = [...widget.result.baggage, ...widget.result.meals];
    if (allSelections.isEmpty) return;

    setState(() => _processingMessage = "Adding your baggage and meal selections...");

    for (final selection in allSelections) {
      _ancillaryBloc.add(
        PurchaseAncillaryRequested(
          pnrId: pnrId,
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

  Future<void> _pay() async {
    final pnr = _pnr;
    if (pnr?.pnrId == null) return;

    setState(() {
      _step = _Step.processing;
      _processingMessage = "Processing payment...";
      _errorMessage = null;
    });

    _paymentBloc.add(CreatePaymentRequested(pnrId: pnr!.pnrId!, paymentMethod: _paymentMethod));

    final result = await _paymentBloc.stream.firstWhere(
      (s) => s is PaymentCreated || s is PaymentError,
    );

    if (!mounted) return;

    if (result is PaymentError) {
      setState(() {
        _step = _Step.paymentMethod;
        _errorMessage = result.message;
      });
      return;
    }

    setState(() {
      _payment = (result as PaymentCreated).payment;
      _step = _Step.done;
    });
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
            _Step.paymentMethod => _buildPaymentMethod(context),
            _Step.done => _buildDone(context),
            _Step.error => _buildError(context),
          },
        ),
      ),
    );
  }

  Widget _buildReview(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact", style: AppFont.medium14),
                widget.height(8),
                CardGeneral(
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
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        ),
                      Text(
                        _contact.phone,
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
                widget.height(16),
                Text("Passengers", style: AppFont.medium14),
                widget.height(8),
                CardGeneral(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (var i = 0; i < _passengers.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: i == _passengers.length - 1 ? 0 : 8),
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
                widget.height(16),
                Text("Addons", style: AppFont.medium14),
                widget.height(8),
                CardGeneral(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.result.baggage.isEmpty
                            ? "No baggage added"
                            : "${widget.result.baggage.length} baggage item(s) -- "
                                  "${formatIDR(sumAncillaryPrices(widget.result.baggage))}",
                        style: AppFont.reguler14,
                      ),
                      widget.height(6),
                      Text(
                        widget.result.meals.isEmpty
                            ? "No meals added"
                            : "${widget.result.meals.length} meal(s) -- "
                                  "${formatIDR(sumAncillaryPrices(widget.result.meals))}",
                        style: AppFont.reguler14,
                      ),
                      widget.height(6),
                      Text(
                        widget.result.seats.isEmpty
                            ? "No seats selected"
                            : "${widget.result.seats.length} seat(s) selected",
                        style: AppFont.reguler14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _bottomBar(
          label: "Estimated Total",
          amount: _estimatedTotal,
          buttonLabel: "Confirm Booking",
          onPressed: _confirmBooking,
        ),
      ],
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

  Widget _buildPaymentMethod(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        var isLoggedIn = false;
        if (state is UserLoggedIn) {
          isLoggedIn = true;
        }
        return Column(
          children: [
            if (_ancillaryFailures.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                      "Booking created (${_pnr?.bookingCode ?? '-'}), but some addons could not be attached:",
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
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(_errorMessage!, style: AppFont.reguler12.copyWith(color: Colors.red)),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking Code", style: AppFont.reguler12),
                    Text(_pnr?.bookingCode ?? '-', style: AppFont.semibold20),
                    widget.height(24),
                    Text("Payment Method", style: AppFont.medium14),
                    widget.height(8),
                    _paymentMethodTile(
                      value: 'DOKU_VA',
                      title: "Virtual Account (DOKU)",
                      subtitle: "Pay via bank transfer -- works without signing in.",
                      enabled: true,
                    ),
                    widget.height(8),
                    _paymentMethodTile(
                      value: 'BALANCE',
                      title: "Wallet Balance",
                      subtitle: "Sign in to pay with your wallet balance.",
                      enabled: isLoggedIn,
                    ),
                  ],
                ),
              ),
            ),
            _bottomBar(
              label: "Total",
              amount: _pnr?.totalAmount ?? _estimatedTotal,
              buttonLabel: "Pay Now",
              onPressed: _pay,
            ),
          ],
        );
      },
    );
  }

  Widget _paymentMethodTile({
    required String value,
    required String title,
    required String subtitle,
    required bool enabled,
  }) {
    final isSelected = _paymentMethod == value;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? () => setState(() => _paymentMethod = value) : null,
        child: CardGeneral(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            width: 1.5,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? AppColor.primaryColor : Theme.of(context).hintColor,
              ),
              widget.width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppFont.medium14),
                    Text(
                      subtitle,
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDone(BuildContext context) {
    final payment = _payment;
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
