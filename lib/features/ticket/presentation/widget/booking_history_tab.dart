import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/presentation/bloc/booking/booking_bloc.dart';

import 'booking_detail_sheet.dart';
import 'card_booking_history.dart';

class BookingHistoryTab extends StatefulWidget {
  const BookingHistoryTab({super.key});

  @override
  State<BookingHistoryTab> createState() => _BookingHistoryTabState();
}

class _BookingHistoryTabState extends State<BookingHistoryTab> {
  late final BookingBloc _bookingBloc;
  final _codeController = TextEditingController();
  bool? _lastLoggedIn;

  @override
  void initState() {
    super.initState();
    _bookingBloc = serviceLocator<BookingBloc>();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _loadHistoryIfLoggedIn(bool isLoggedIn) {
    if (isLoggedIn && _lastLoggedIn != true) {
      _bookingBloc.add(const LoadMyPnrListRequested());
    }
    _lastLoggedIn = isLoggedIn;
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
          _loadHistoryIfLoggedIn(isLoggedIn);

          return BlocConsumer<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is PnrByBookingCodeLoaded) {
                showBookingDetailSheet(context, state.pnr).then((_) {
                  if (mounted && isLoggedIn) {
                    _bookingBloc.add(const LoadMyPnrListRequested());
                  }
                });
              }
            },
            builder: (context, state) {
              if (isLoggedIn) {
                return _buildLoggedInList(state);
              }
              return _buildGuestSearch(context, state);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoggedInList(BookingState state) {
    if (state is BookingLoading || state is BookingInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is BookingError) {
      return Empty(
        title: state.message,
        actionLabel: 'Retry',
        onAction: () => _bookingBloc.add(const LoadMyPnrListRequested()),
      );
    }
    if (state is MyPnrListLoaded) {
      if (state.pnrs.isEmpty) {
        return const Empty(title: 'You have no bookings yet.');
      }
      return RefreshIndicator(
        onRefresh: () async => _bookingBloc.add(const LoadMyPnrListRequested()),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: state.pnrs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final pnr = state.pnrs[index];
            return CardBookingHistory(
              pnr: pnr,
              onTap: () {
                if (pnr.bookingCode == null) return;
                _bookingBloc.add(LoadPnrByBookingCodeRequested(bookingCode: pnr.bookingCode!));
              },
            );
          },
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGuestSearch(BuildContext context, BookingState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Find your booking', style: AppFont.medium16),
          widget.height(4),
          Text(
            "Not signed in -- enter the booking code from your confirmation to look it up.",
            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
          ),
          widget.height(16),
          InputText(
            controller: _codeController,
            hintText: 'e.g. BF47S8',
            textInputAction: TextInputAction.search,
            onComplete: _searchByCode,
          ),
          widget.height(12),
          PrimaryButton(
            title: state is BookingLoading ? 'Searching...' : 'Search',
            onPressed: state is BookingLoading ? () {} : _searchByCode,
          ),
          if (state is BookingError) ...[
            widget.height(16),
            Text(state.message, style: AppFont.reguler12.copyWith(color: Colors.red)),
          ],
        ],
      ),
    );
  }
}
