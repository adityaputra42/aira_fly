import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:get_it/get_it.dart';
import '../core/common/cubit/theme_cubit.dart';
import '../features/main/ui/cubit/main_cubit.dart';
import '../features/splash/cubit/splash_cubit.dart';
import '../core/utils/connection_checker.dart';
import '../features/onboarding/cubit/onboarding_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => MainCubit());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));
  serviceLocator.registerFactory<SplashCubit>(() => SplashCubit());

  serviceLocator.registerFactory<ThemeCubit>(() => ThemeCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
}
