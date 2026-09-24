part of 'seat_class_bloc.dart';

sealed class SeatClassState extends Equatable {
  const SeatClassState();

  @override
  List<Object?> get props => [];
}

final class SeatClassInitial extends SeatClassState {}

class SeatClassLoading extends SeatClassState {}

class SeatClassLoaded extends SeatClassState {
  final List<SeatClassEntity> seatClasses;

  const SeatClassLoaded(this.seatClasses);

  Map<int, SeatClassEntity> get byId => {
    for (final s in seatClasses)
      if (s.id != null) s.id!: s,
  };
  @override
  List<Object?> get props => [seatClasses];
}

class SeatClassError extends SeatClassState {
  final String message;

  const SeatClassError(this.message);

  @override
  List<Object?> get props => [message];
}
