part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => MainCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<SplashCubit>(
    () => SplashCubit(pref: PrefHelper(sharedPrefs)),
  );
  
  serviceLocator.registerFactory<ThemeCubit>(
    () => ThemeCubit(pref: PrefHelper(sharedPrefs)),
  );
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());
}
