part of 'fare_class_bloc.dart';

sealed class FareClassEvent extends Equatable {
  const FareClassEvent();

  @override
  List<Object?> get props => [];
}

class LoadFareClassesRequested extends FareClassEvent {
  final int page;
  final int limit;

  final bool forceRefresh;

  const LoadFareClassesRequested({this.page = 1, this.limit = 200, this.forceRefresh = false});

  @override
  List<Object?> get props => [page, limit, forceRefresh];
}
