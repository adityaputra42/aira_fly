part of 'fare_class_bloc.dart';

sealed class FareClassState extends Equatable {
  const FareClassState();

  @override
  List<Object?> get props => [];
}

final class FareClassInitial extends FareClassState {}

class FareClassLoading extends FareClassState {}

class FareClassLoaded extends FareClassState {
  final List<FareClassEntity> fareClasses;

  const FareClassLoaded(this.fareClasses);

  Map<int, FareClassEntity> get byId => {
    for (final f in fareClasses)
      if (f.id != null) f.id!: f,
  };

  @override
  List<Object?> get props => [fareClasses];
}

class FareClassError extends FareClassState {
  final String message;

  const FareClassError(this.message);

  @override
  List<Object?> get props => [message];
}
