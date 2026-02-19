import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/common/cubit/theme_cubit.dart';
import 'core/main/cubit/main_cubit.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'core/utils/connection_checker.dart';
import 'core/utils/pref_helper.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';


final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => MainCubit());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));
  serviceLocator.registerFactory<SplashCubit>(() => SplashCubit(pref: PrefHelper(sharedPrefs)));

  serviceLocator.registerFactory<ThemeCubit>(() => ThemeCubit(pref: PrefHelper(sharedPrefs)));
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
}
