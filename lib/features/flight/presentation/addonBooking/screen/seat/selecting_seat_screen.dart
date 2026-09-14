import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/common/widget/selectable_box.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
import 'package:pss_app/core/utils/show_snackbar.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/flight/domain/entities/flight_seat_entity.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/custom_tab_bar_pax.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';

import '../../../../../../app/init_dependencies.dart';

class SelectingSeatScreen extends StatefulWidget {
  const SelectingSeatScreen({super.key, required this.arguments});

  final SeatPickerArguments arguments;

  @override
  State<SelectingSeatScreen> createState() => _SelectingSeatScreenState();
}

class _SelectingSeatScreenState extends State<SelectingSeatScreen> {
  late final FlightBloc _flightBloc;

  int _selectedPassengerIndex = 0;

  late Map<int, FlightSeatEntity> _selectionByPassenger;

  @override
  void initState() {
    super.initState();

    _selectionByPassenger = {
      for (final s in widget.arguments.currentSelections) s.passengerIndex: s.seat,
    };

    _flightBloc = serviceLocator<FlightBloc>()
      ..add(LoadFlightSeatsRequested(flightId: widget.arguments.leg.flightId));
  }

  String _passengerLabel(int index) {
    final p = widget.arguments.passengers[index];

    final parts = [if (p.title != null) p.title, p.firstName, if (p.lastName != null) p.lastName];

    return parts.whereType<String>().join(' ');
  }

  void _selectSeat(FlightSeatEntity seat) {
    if (!seat.isAvailable) return;

    MapEntry<int, FlightSeatEntity>? heldByOther;

    for (final entry in _selectionByPassenger.entries) {
      if (entry.value.id == seat.id && entry.key != _selectedPassengerIndex) {
        heldByOther = entry;
        break;
      }
    }

    if (heldByOther != null) {
      showSnackBar(
        context,
        'That seat is already assigned to '
        '${_passengerLabel(heldByOther.key)}.',
      );

      return;
    }

    setState(() {
      _selectionByPassenger[_selectedPassengerIndex] = seat;
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

  List<int> _getCluster(int maxColumns) {
    switch (maxColumns) {
      case 4:
        return [2, 2];

      case 6:
        return [3, 3];

      case 8:
        return [2, 4, 2];

      case 9:
        return [3, 3, 3];

      case 10:
        return [3, 4, 3];

      default:
        return [maxColumns];
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

    final sorted = letters.toList()..sort();

    return sorted;
  }

  int _getMaxColumns(List<FlightSeatEntity> seats) {
    final rows = <int, Set<String>>{};

    for (final seat in seats) {
      final row = seat.rowNumber ?? 0;
      final letter = seat.seatLetter;

      if (letter == null || letter.isEmpty) {
        continue;
      }

      rows.putIfAbsent(row, () => <String>{}).add(letter);
    }

    if (rows.isEmpty) {
      return 0;
    }

    return rows.values.map((columns) => columns.length).reduce((a, b) => a > b ? a : b);
  }

  List<String> _applyClusterToColumns(List<String> columns, List<int> cluster) {
    final result = <String>[];

    int index = 0;

    for (final clusterSize in cluster) {
      final end = index + clusterSize;

      if (end > columns.length) {
        break;
      }

      result.addAll(columns.sublist(index, end));

      index = end;

      if (index < columns.length) {
        result.add('|');
      }
    }

    return result;
  }

  Widget _buildSeatRow({
    required List<FlightSeatEntity> rowSeats,
    required List<String> clusteredColumns,
    required int maxColumns,
    required FlightSeatEntity? currentSeat,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: clusteredColumns.map((column) {
        if (column == '|') {
          return _buildAisle(maxColumns);
        }
        FlightSeatEntity? seat;

        for (final item in rowSeats) {
          if (item.seatLetter == column) {
            seat = item;
            break;
          }
        }

        if (seat == null) {
          return _buildEmptySeat(maxColumns);
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: maxColumns < 8 ? 2 : 2),
          child: SelectableBox(
            text: seat.seatNumber ?? seat.seatLetter ?? '?',
            width: maxColumns < 8 ? 40 : 32,
            height: maxColumns < 8 ? 36 : 30,
            fontsize: maxColumns < 8 ? 10 : 8,
            isEnable: seat.isAvailable,
            isSelected: currentSeat?.id != null && currentSeat!.id == seat.id,
            onTap: () => _selectSeat(seat!),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAisle(int maxColumns) {
    return SizedBox(width: maxColumns < 8 ? 20 : 16, height: maxColumns < 8 ? 40 : 36);
  }

  Widget _buildEmptySeat(int maxColumns) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: maxColumns < 8 ? 4 : 2),
      child: SizedBox(width: maxColumns < 8 ? 44 : 36, height: maxColumns < 8 ? 40 : 36),
    );
  }

  Widget _buildSeatHeader({required List<String> clusteredColumns, required int maxColumns}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: clusteredColumns.map((column) {
        // Aisle
        if (column == '|') {
          return SizedBox(width: maxColumns < 8 ? 20 : 16);
        }

        return SizedBox(
          width: maxColumns < 8 ? 44 : 36,
          child: Center(child: Text(column, style: AppFont.medium14)),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passengerLabels = List.generate(
      widget.arguments.passengers.length,
      (i) => _passengerLabel(i),
    );

    final segments = widget.arguments.leg.itinerary.segments ?? const [];

    final routeLabel = segments.isEmpty
        ? widget.arguments.leg.label
        : "${widget.arguments.leg.label} • "
              "${segments.first.departureAirportCode ?? '-'} "
              "→ "
              "${segments.last.arrivalAirportCode ?? '-'}";

    final currentSeat = _selectionByPassenger[_selectedPassengerIndex];

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
                titles: passengerLabels.isEmpty ? const ["-"] : passengerLabels,
                selectedIndex: _selectedPassengerIndex,
                value: currentSeat?.seatNumber,
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
                  if (state is FlightError) {
                    return Empty(
                      title: state.message,
                      actionLabel: "Retry",
                      onAction: () {
                        _flightBloc.add(
                          LoadFlightSeatsRequested(flightId: widget.arguments.leg.flightId),
                        );
                      },
                    );
                  }
                  if (state is! FlightSeatsLoaded) {
                    return CardGeneral(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: List.generate(
                          6,
                          (_) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ShimmerLoading(height: 40, radius: 6),
                          ),
                        ),
                      ),
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

                  final maxColumns = _getMaxColumns(seats);

                  final columns = _getAllColumns(seats);

                  final cluster = _getCluster(maxColumns);

                  final clusteredColumns = _applyClusterToColumns(columns, cluster);

                  return SingleChildScrollView(
                    child: CardGeneral(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            maxColumns: maxColumns,
                          ),

                          widget.height(8),

                          for (final row in sortedRows)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildSeatRow(
                                rowSeats: seatsByRow[row]!,
                                clusteredColumns: clusteredColumns,
                                maxColumns: maxColumns,
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
                      "${_selectionByPassenger.length} "
                      "of "
                      "${widget.arguments.passengers.length}",
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
