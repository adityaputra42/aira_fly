import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;

  ProfileBloc({required this.getProfileUseCase, required this.updateProfileUseCase})
    : super(ProfileInitial()) {
    on<LoadProfileRequested>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future _onLoadProfile(LoadProfileRequested event, Emitter emit) async {
    emit(ProfileLoading());

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future _onUpdateProfile(UpdateProfileRequested event, Emitter emit) async {
    emit(ProfileLoading());

    final result = await updateProfileUseCase(
      UpdateProfileParams(fullName: event.fullName, email: event.email),
    );

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileUpdated(profile)),
    );
  }
}
