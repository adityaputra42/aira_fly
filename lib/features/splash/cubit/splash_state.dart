part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashToOnboarding extends SplashState {}

class SplashToHome extends SplashState {}
