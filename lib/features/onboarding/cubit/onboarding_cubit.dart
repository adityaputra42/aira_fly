import 'package:bloc/bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void nextPage(int page) => emit(page);

  void skip() => emit(-1);

  void finish() => emit(-2);
}
