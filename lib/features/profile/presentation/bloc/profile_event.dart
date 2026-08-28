part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileRequested extends ProfileEvent {}

class UpdateProfileRequested extends ProfileEvent {
  final String? fullName;
  final String? email;

  const UpdateProfileRequested({this.fullName, this.email});

  @override
  List<Object?> get props => [fullName, email];
}
