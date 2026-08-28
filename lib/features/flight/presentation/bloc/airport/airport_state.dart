part of 'airport_bloc.dart';

sealed class AirportState extends Equatable {
  const AirportState();
  
  @override
  List<Object> get props => [];
}

final class AirportInitial extends AirportState {}
