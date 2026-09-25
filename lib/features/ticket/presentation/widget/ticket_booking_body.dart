import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/features/flight/domain/entities/pnr_entity.dart';
import 'package:pss_app/features/flight/domain/usecases/booking/list_my_pnrs.dart';
import 'package:pss_app/features/flight/presentation/bloc/booking/booking_bloc.dart';
import 'package:pss_app/features/ticket/presentation/widget/card_ticket_loading.dart';
import 'package:pss_app/features/ticket/presentation/widget/card_tikcet_list.dart';

import '../../../../core/animation/stagger_in.dart';
import 'booking_detail_sheet.dart';

class TicketBookingBody extends StatefulWidget {
  const TicketBookingBody({super.key});

  @override
  State<TicketBookingBody> createState() => _TicketBookingBodyState();
}

class _TicketBookingBodyState extends State<TicketBookingBody> {
  late final BookingBloc _bookingBloc;
  // late final GetPnrByBookingCode _getPnrByBookingCode;
  final _codeController = TextEditingController();
  bool? _lastLoggedIn;

  List<PnrSummaryEntity>? _active;
  List<PnrSummaryEntity>? _history;
  String? _loadError;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _bookingBloc = serviceLocator<BookingBloc>();
    // _getPnrByBookingCode = serviceLocator<GetPnrByBookingCode>();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _loadIfLoggedIn(bool isLoggedIn) {
    if (isLoggedIn && _lastLoggedIn != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadAndClassify();
      });
    }
    _lastLoggedIn = isLoggedIn;
  }

  Future<void> _loadAndClassify() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    final listResult = await serviceLocator<ListMyPnrs>()(const ListMyPnrsParams(limit: 50));
    if (!mounted) return;

    await listResult.fold(
      (failure) async {
        setState(() {
          _loading = false;
          _loadError = failure.message;
        });
      },
      (summaries) async {
        // final codes = summaries.map((s) => s.bookingCode).whereType<String>().toList();

        // final details = await Future.wait(
        //   codes.map((code) async {
        //     final result = await _getPnrByBookingCode(GetPnrByBookingCodeParams(bookingCode: code));
        //     return result.fold((_) => null, (d) => d);
        //   }),
        // );

        if (!mounted) return;

        final now = DateTime.now();
        final active = <PnrSummaryEntity>[];
        final history = <PnrSummaryEntity>[];
        for (final summary in summaries) {
          (_isHistory(summary, now) ? history : active).add(summary);
        }
        active.sort((a, b) => _earliestDeparture(a, now).compareTo(_earliestDeparture(b, now)));
        history.sort((a, b) => _earliestDeparture(b, now).compareTo(_earliestDeparture(a, now)));

        setState(() {
          _loading = false;
          _active = active;
          _history = history;
        });
      },
    );
  }

  DateTime _earliestDeparture(PnrSummaryEntity pnr, DateTime fallback) {
    DateTime? earliest;

    earliest = pnr.departureTime;

    return earliest ?? fallback;
  }

  bool _isHistory(PnrSummaryEntity pnr, DateTime now) {
    if (pnr.status == 'CANCELLED' || pnr.status == 'EXPIRED') return true;

    return pnr.departureTime!.isBefore(now);
  }

  void _searchByCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    _bookingBloc.add(LoadPnrByBookingCodeRequested(bookingCode: code));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookingBloc,
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final isLoggedIn = userState is UserLoggedIn;
          _loadIfLoggedIn(isLoggedIn);

          if (!isLoggedIn) {
            return _buildGuestSearch(context);
          }

          return _buildTabs(context);
        },
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          CardGeneral(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            height: 42,
            padding: const EdgeInsets.all(2),
            child: TabBar(
              physics: const NeverScrollableScrollPhysics(),
              automaticIndicatorColorAdjustment: false,
              indicator: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              isScrollable: false,
              dividerColor: Colors.transparent,
              indicatorColor: Theme.of(context).colorScheme.surface,
              labelColor: AppColor.darkText1,
              labelPadding: EdgeInsets.zero,
              labelStyle: AppFont.medium14,
              unselectedLabelColor: Theme.of(context).hintColor,
              unselectedLabelStyle: AppFont.reguler14,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(child: Text("Active Ticket")),
                Tab(child: Text("Ticket History")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildList(_active, emptyText: "You have no upcoming tickets."),
                _buildList(_history, emptyText: "You have no past tickets yet."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<PnrSummaryEntity>? items, {required String emptyText}) {
    if (_loadError != null) {
      return Empty(title: _loadError!, actionLabel: 'Retry', onAction: _loadAndClassify);
    }
    if (_loading || items == null) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return CardTicketLoading();
        },
      );
    }
    if (items.isEmpty) {
      return Empty(title: emptyText);
    }
    return RefreshIndicator(
      onRefresh: _loadAndClassify,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pnr = items[index];
          return StaggerItem(
            index: index,
            child: CardTikcetList(pnr: pnr, onTap: () {}),
          );
        },
      ),
    );
  }

  Widget _buildGuestSearch(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is PnrByBookingCodeLoaded) {
          showBookingDetailSheet(context, state.pnr);
        }
      },
      builder: (context, state) {
        return CardGeneral(
          // padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find your booking', style: AppFont.medium16),
              const SizedBox(height: 4),
              Text(
                "Not signed in -- enter the booking code from your confirmation to look it up.",
                style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 16),
              InputText(
                filled: true,
                filledColor: Theme.of(context).colorScheme.surface,
                controller: _codeController,
                hintText: 'e.g. BF47S8',
                textInputAction: TextInputAction.search,
                onComplete: _searchByCode,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                title: state is BookingLoading ? 'Searching...' : 'Search',
                onPressed: state is BookingLoading ? () {} : _searchByCode,
              ),
              if (state is BookingError) ...[
                const SizedBox(height: 16),
                Text(state.message, style: AppFont.reguler12.copyWith(color: Colors.red)),
              ],
            ],
          ),
        );
      },
    );
  }
}
