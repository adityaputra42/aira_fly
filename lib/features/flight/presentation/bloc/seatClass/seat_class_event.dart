part of 'seat_class_bloc.dart';

sealed class SeatClassEvent extends Equatable {
  const SeatClassEvent();

  @override
  List<Object?> get props => [];
}

class LoadSeatClassesRequested extends SeatClassEvent {
  final int page;
  final int limit;

  final bool forceRefresh;

  const LoadSeatClassesRequested({this.page = 1, this.limit = 200, this.forceRefresh = false});

  @override
  List<Object?> get props => [page, limit, forceRefresh];
}
