import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/common/widget/selectable_box.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/flight/domain/entities/flight_seat_entity.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/custom_tab_bar_pax.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';

import '../../../../../../app/init_dependencies.dart';
import '../../../../../../core/utils/top_snackbar_helper.dart';
import '../../../../domain/repository/booking_repository.dart';

class SelectingSeatScreen extends StatefulWidget {
  const SelectingSeatScreen({super.key, required this.arguments});

  final SeatPickerArguments arguments;

  @override
  State<SelectingSeatScreen> createState() => _SelectingSeatScreenState();
}

class _SelectingSeatScreenState extends State<SelectingSeatScreen> {
  late final FlightBloc _flightBloc;
  int _selectedPassengerIndex = 0;

  late final Map<int, FlightSeatEntity> _selectionByPassenger;

  final List<PassengerInput> _passengers = [];

  final List<int> _originalIndexes = [];

  Object? _staleState;
  @override
  void initState() {
    super.initState();

    final all = widget.arguments.passengers;
    for (var i = 0; i < all.length; i++) {
      if (all[i].passengerType != 'INF') {
        _passengers.add(all[i]);
        _originalIndexes.add(i);
      }
    }

    _selectionByPassenger = {
      for (final s in widget.arguments.currentSelections)
        if (_originalIndexes.contains(s.passengerIndex)) s.passengerIndex: s.seat,
    };

// initState
    _flightBloc = serviceLocator<FlightBloc>();
    _staleState = _flightBloc.state;
    _loadSeats();
  }



  void _loadSeats() {
    _flightBloc.add(
      LoadFlightSeatsRequested(
        flightId: widget.arguments.leg.flightId,
        seatClassId: widget.arguments.leg.fareFlight?.seatClassId,
      ),
    );
  }

  int? get _activeKey => _passengers.isEmpty ? null : _originalIndexes[_selectedPassengerIndex];

  String _passengerLabel(int tabIndex) {
    final p = _passengers[tabIndex];
    final parts = [if (p.title != null) p.title, p.firstName, if (p.lastName != null) p.lastName];
    return parts.whereType<String>().join(' ');
  }

  String _labelForKey(int originalIndex) {
    final tab = _originalIndexes.indexOf(originalIndex);
    return tab < 0 ? 'another passenger' : _passengerLabel(tab);
  }

  void _selectSeat(FlightSeatEntity seat) {
    final activeKey = _activeKey;
    if (activeKey == null || !seat.isAvailable) return;

    for (final entry in _selectionByPassenger.entries) {
      if (entry.value.id == seat.id && entry.key != activeKey) {
        TopSnackbarHelper.info(
          context,
          message: 'That seat is already assigned to ${_labelForKey(entry.key)}.',
        );
        return;
      }
    }

    setState(() {
      _selectionByPassenger[activeKey] = seat;
    });
  }

  void _onDone() {
    final results = _selectionByPassenger.entries
        .map(
          (entry) => SelectedSeat(
        seat: entry.value,
        flightId: widget.arguments.leg.flightId,
        passengerIndex: entry.key,
      ),
    )
        .toList();

    context.pop(results);
  }

  List<int> _getCluster(int columnCount) {
    switch (columnCount) {
      case 4:
        return [2, 2];
      case 5:
        return [3, 2];
      case 6:
        return [3, 3];
      case 8:
        return [2, 4, 2];
      case 9:
        return [3, 3, 3];
      case 10:
        return [3, 4, 3];
      default:
        return [columnCount];
    }
  }

  List<String> _getAllColumns(List<FlightSeatEntity> seats) {
    final letters = <String>{};

    for (final seat in seats) {
      final letter = seat.seatLetter;
      if (letter != null && letter.isNotEmpty) {
        letters.add(letter);
      }
    }

    return letters.toList()..sort();
  }

  List<String> _applyClusterToColumns(List<String> columns, List<int> cluster) {
    final result = <String>[];
    int index = 0;

    for (final clusterSize in cluster) {
      if (index >= columns.length) break;

      final end = (index + clusterSize) > columns.length ? columns.length : index + clusterSize;

      result.addAll(columns.sublist(index, end));
      index = end;

      if (index < columns.length) {
        result.add('|');
      }
    }

    // Kolom sisa tidak boleh hilang diam-diam.
    if (index < columns.length) {
      result.addAll(columns.sublist(index));
    }

    return result;
  }

  // ---- ukuran layout (satu sumber kebenaran) ----
  double _seatSize(int columnCount) => columnCount < 8 ? context.w(0.14) : context.w(0.085);
  double _seatHPadding(int columnCount) => columnCount < 8 ? 3 : 2;
  double _aisleWidth(int columnCount) => columnCount < 8 ? 20 : 10;
  double _seatFont(int columnCount) => columnCount < 8 ? 10 : 8;

  FlightSeatEntity? _findSeat(List<FlightSeatEntity> rowSeats, String column) {
    for (final item in rowSeats) {
      if (item.seatLetter == column) return item;
    }
    return null;
  }

  Widget _buildSeatRow({
    required List<FlightSeatEntity> rowSeats,
    required List<String> clusteredColumns,
    required int columnCount,
    required FlightSeatEntity? currentSeat,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: clusteredColumns.map((column) {
        if (column == '|') {
          return SizedBox(width: _aisleWidth(columnCount), height: _seatSize(columnCount));
        }

        final seat = _findSeat(rowSeats, column);

        if (seat == null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: _seatHPadding(columnCount)),
            child: SizedBox(width: _seatSize(columnCount), height: _seatSize(columnCount)),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: _seatHPadding(columnCount)),
          child: SelectableBox(
            text: seat.seatNumber ?? seat.seatLetter ?? '?',
            width: _seatSize(columnCount),
            height: _seatSize(columnCount),
            fontsize: _seatFont(columnCount),
            isEnable: seat.isAvailable,
            isSelected: currentSeat?.id != null && currentSeat!.id == seat.id,
            onTap: () => _selectSeat(seat),
          ),
        );
      }).toList(),
    );
  }

  /// Header harus memakai struktur yang SAMA dengan baris kursi
  /// (center + padding horizontal), kalau tidak huruf kolom tidak sejajar.
  Widget _buildSeatHeader({required List<String> clusteredColumns, required int columnCount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: clusteredColumns.map((column) {
        if (column == '|') {
          return SizedBox(width: _aisleWidth(columnCount));
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: _seatHPadding(columnCount)),
          child: SizedBox(
            width: _seatSize(columnCount),
            child: Center(child: Text(column, style: AppFont.medium14)),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passengerLabels = List.generate(_passengers.length, _passengerLabel);

    final segments = widget.arguments.leg.itinerary.segments ?? const [];

    final routeLabel = segments.isEmpty
        ? widget.arguments.leg.label
        : "${widget.arguments.leg.label} • "
        "${segments.first.departureAirportCode ?? '-'} "
        "→ "
        "${segments.last.arrivalAirportCode ?? '-'}";

    final activeKey = _activeKey;
    final currentSeat = activeKey == null ? null : _selectionByPassenger[activeKey];

    return BlocProvider.value(
      value: _flightBloc,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          context: context,
          title: "Selecting Seat",
          color: AppColor.primaryColor,
          titleColor: AppColor.darkText1,
        ),
        body: Column(
          children: [
            widget.height(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  routeLabel,
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            ),
            widget.height(12),
            DefaultTabController(
              length: passengerLabels.isEmpty ? 1 : passengerLabels.length,
              child: CustomTabBarPassager(
                titles: passengerLabels.isEmpty ? const ['-'] : passengerLabels,
                selectedIndex: _selectedPassengerIndex,
                values: List.generate(
                  passengerLabels.length,
                      (i) => _selectionByPassenger[_originalIndexes[i]]?.seatNumber,
                ),
                onTap: (index) {
                  setState(() {
                    _selectedPassengerIndex = index;
                  });
                },
              ),
            ),
            widget.height(12),
            Expanded(
              child: BlocBuilder<FlightBloc, FlightState>(
                builder: (context, state) {
                  if (identical(state, _staleState)) {
                    return CardGeneral(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(child: generateSeatLoading()),
                    );
                  }
                  if (state is FlightError) {
                    return Empty(
                      title: state.message,
                      actionLabel: "Retry",
                      onAction: _loadSeats,
                    );
                  }
                  if (state is! FlightSeatsLoaded) {
                    return CardGeneral(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(child: generateSeatLoading()),
                    );
                  }

                  final seats = state.seats;

                  if (seats.isEmpty) {
                    return const Empty(title: "No seat map available for this flight.");
                  }

                  final seatsByRow = <int, List<FlightSeatEntity>>{};

                  for (final seat in seats) {
                    final row = seat.rowNumber ?? 0;
                    seatsByRow.putIfAbsent(row, () => []).add(seat);
                  }

                  final sortedRows = seatsByRow.keys.toList()..sort();

                  for (final row in sortedRows) {
                    seatsByRow[row]!.sort(
                          (a, b) => (a.seatLetter ?? '').compareTo(b.seatLetter ?? ''),
                    );
                  }

                  final columns = _getAllColumns(seats);

                  // Pakai jumlah kolom GABUNGAN, bukan max per-baris,
                  // supaya tidak ada kolom yang terpotong.
                  final columnCount = columns.length;

                  final cluster = _getCluster(columnCount);
                  final clusteredColumns = _applyClusterToColumns(columns, cluster);

                  return CardGeneral(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _legendItem(context, label: "Available", isEnable: true),
                              _legendItem(context, label: "Unavailable", isEnable: false),
                              _legendItem(context, label: "Selected", isSelected: true),
                            ],
                          ),
                          widget.height(16),
                          _buildSeatHeader(
                            clusteredColumns: clusteredColumns,
                            columnCount: columnCount,
                          ),
                          widget.height(8),
                          for (final row in sortedRows)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildSeatRow(
                                rowSeats: seatsByRow[row]!,
                                clusteredColumns: clusteredColumns,
                                columnCount: columnCount,
                                currentSeat: currentSeat,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
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
                    Text("Seats Selected", style: AppFont.reguler12),
                    Text(
                      "${_selectionByPassenger.length} of ${_passengers.length}",
                      style: AppFont.medium14,
                    ),
                  ],
                ),
                PrimaryButton(
                  title: "Done",
                  onPressed: _onDone,
                  width: context.w(0.4),
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column generateSeatLoading() {
    final widgets = <Widget>[];
    for (int i = 0; i < 10; i++) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < 5 ? 8 : 0,
                bottom: 8,
                left: (index == 3) ? context.w(0.05) : 0,
              ),
              child: ShimmerLoading(height: context.w(0.115), width: context.w(0.115), radius: 4),
            );
          }),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: widgets);
  }

  Widget _legendItem(
      BuildContext context, {
        required String label,
        bool isEnable = true,
        bool isSelected = false,
      }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableBox(
          text: "",
          onTap: () {},
          width: 16,
          height: 16,
          radius: 4,
          isEnable: isEnable,
          isSelected: isSelected,
        ),
        widget.width(4),
        Text(label, style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
      ],
    );
  }
}