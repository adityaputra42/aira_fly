import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:get_it/get_it.dart';

import '../core/common/cubit/theme_cubit.dart';
import '../core/utils/connection_checker.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repository/auth_repository.dart';
import '../features/auth/domain/usecases/current_user.dart';
import '../features/auth/domain/usecases/user_login.dart';
import '../features/auth/domain/usecases/user_sign_up.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/flight/data/datasources/ancillary_remote_data_source.dart';
import '../features/flight/data/datasources/booking_remote_data_source.dart';
import '../features/flight/data/datasources/flight_remote_data_source.dart';
import '../features/flight/data/datasources/payment_remote_data_source.dart';
import '../features/flight/data/repositories/ancillary_repository_impl.dart';
import '../features/flight/data/repositories/booking_repository_impl.dart';
import '../features/flight/data/repositories/flight_repository_impl.dart';
import '../features/flight/data/repositories/payment_repository_impl.dart';
import '../features/flight/domain/repository/ancillary_repository.dart';
import '../features/flight/domain/repository/booking_repository.dart';
import '../features/flight/domain/repository/flight_repository.dart';
import '../features/flight/domain/repository/payment_repository.dart';
import '../features/flight/domain/usecases/ancillary/cancel_ancillary_purchase.dart';
import '../features/flight/domain/usecases/ancillary/get_ancillary.dart';
import '../features/flight/domain/usecases/ancillary/list_ancillaries_by_flight.dart';
import '../features/flight/domain/usecases/ancillary/list_ancillary_catalog.dart';
import '../features/flight/domain/usecases/ancillary/list_ancillary_categories.dart';
import '../features/flight/domain/usecases/ancillary/list_ancillary_purchases_by_pnr.dart';
import '../features/flight/domain/usecases/ancillary/purchase_ancillary.dart';
import '../features/flight/domain/usecases/booking/cancel_pnr.dart';
import '../features/flight/domain/usecases/booking/create_pnr.dart';
import '../features/flight/domain/usecases/booking/get_pnr.dart';
import '../features/flight/domain/usecases/booking/list_pnrs.dart';
import '../features/flight/domain/usecases/flight/get_airports.dart';
import '../features/flight/domain/usecases/flight/get_flight_seats.dart';
import '../features/flight/domain/usecases/flight/search_flights.dart';
import '../features/flight/domain/usecases/payment/create_payment.dart';
import '../features/flight/domain/usecases/payment/get_payment.dart';
import '../features/flight/domain/usecases/payment/get_payment_by_pnr.dart';
import '../features/flight/presentation/bloc/ancillary/ancillary_bloc.dart';
import '../features/flight/presentation/bloc/booking/booking_bloc.dart';
import '../features/flight/presentation/bloc/flight/flight_bloc.dart';
import '../features/flight/presentation/bloc/payment/payment_bloc.dart';
import '../features/main/ui/cubit/main_cubit.dart';
import '../features/onboarding/cubit/onboarding_cubit.dart';
import '../features/profile/data/datasources/profile_remote_data_source.dart'
    show ProfileRemoteDataSource, ProfileRemoteDataSourceImpl;
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repository/profile_repository.dart';
import '../features/profile/domain/usecases/get_profile.dart';
import '../features/profile/domain/usecases/update_profile.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/splash/cubit/splash_cubit.dart';
import '../features/ticket/data/datasources/ticket_remote_data_source.dart';
import '../features/ticket/data/repositories/ticket_repository_impl.dart';
import '../features/ticket/domain/repository/ticket_repository.dart';
import '../features/ticket/domain/usecases/check_in.dart';
import '../features/ticket/domain/usecases/get_boarding_pass.dart';
import '../features/ticket/presentation/bloc/ticket_bloc.dart';
import '../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../features/wallet/domain/repository/wallet_repository.dart';
import '../features/wallet/domain/usecases/get_balance.dart';
import '../features/wallet/domain/usecases/get_topup_status.dart';
import '../features/wallet/domain/usecases/list_wallet_transactions.dart'
    show ListWalletTransactions;
import '../features/wallet/domain/usecases/topup_wallet.dart';
import '../features/wallet/presentation/bloc/wallet_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => MainCubit());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));
  serviceLocator.registerFactory<SplashCubit>(() => SplashCubit());

  serviceLocator.registerFactory<ThemeCubit>(() => ThemeCubit());
  serviceLocator.registerFactory<OnboardingCubit>(() => OnboardingCubit());

  _initAuth();
  _initFlight();
  _initBooking();
  _initAncillary();
  _initPayment();
  _initWallet();
  _initTicket();
  _initProfile();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl())
    ..registerFactory<AuthLocalDataSource>(() => AuthLocalDataSourceImpl())
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        signInUseCase: serviceLocator(),
        signOutUseCase: serviceLocator(),
        getCurrentUserUseCase: serviceLocator(),
      ),
    );
}

void _initFlight() {
  serviceLocator
    ..registerFactory<FlightRemoteDataSource>(() => FlightRemoteDataSourceImpl())
    ..registerFactory<FlightRepository>(
      () => FlightRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => GetAirports(serviceLocator()))
    ..registerFactory(() => SearchFlights(serviceLocator()))
    ..registerFactory(() => GetFlightSeats(serviceLocator()))
    ..registerLazySingleton(
      () => FlightBloc(
        getAirportsUseCase: serviceLocator(),
        searchFlightsUseCase: serviceLocator(),
        getFlightSeatsUseCase: serviceLocator(),
      ),
    );
}

void _initBooking() {
  serviceLocator
    ..registerFactory<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl())
    ..registerFactory<BookingRepository>(
      () => BookingRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => CreatePnr(serviceLocator()))
    ..registerFactory(() => GetPnr(serviceLocator()))
    ..registerFactory(() => ListPnrs(serviceLocator()))
    ..registerFactory(() => CancelPnr(serviceLocator()))
    ..registerLazySingleton(
      () => BookingBloc(
        createPnrUseCase: serviceLocator(),
        getPnrUseCase: serviceLocator(),
        listPnrsUseCase: serviceLocator(),
        cancelPnrUseCase: serviceLocator(),
      ),
    );
}

void _initAncillary() {
  serviceLocator
    ..registerFactory<AncillaryRemoteDataSource>(() => AncillaryRemoteDataSourceImpl())
    ..registerFactory<AncillaryRepository>(
      () => AncillaryRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => ListAncillaryCategories(serviceLocator()))
    ..registerFactory(() => ListAncillaryCatalog(serviceLocator()))
    ..registerFactory(() => GetAncillary(serviceLocator()))
    ..registerFactory(() => ListAncillariesByFlight(serviceLocator()))
    ..registerFactory(() => PurchaseAncillary(serviceLocator()))
    ..registerFactory(() => CancelAncillaryPurchase(serviceLocator()))
    ..registerFactory(() => ListAncillaryPurchasesByPnr(serviceLocator()))
    ..registerLazySingleton(
      () => AncillaryBloc(
        listCategoriesUseCase: serviceLocator(),
        listCatalogUseCase: serviceLocator(),
        getAncillaryUseCase: serviceLocator(),
        listByFlightUseCase: serviceLocator(),
        purchaseAncillaryUseCase: serviceLocator(),
        cancelPurchaseUseCase: serviceLocator(),
        listPurchasesByPnrUseCase: serviceLocator(),
      ),
    );
}

void _initPayment() {
  serviceLocator
    ..registerFactory<PaymentRemoteDataSource>(() => PaymentRemoteDataSourceImpl())
    ..registerFactory<PaymentRepository>(
      () => PaymentRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => CreatePayment(serviceLocator()))
    ..registerFactory(() => GetPayment(serviceLocator()))
    ..registerFactory(() => GetPaymentByPnr(serviceLocator()))
    ..registerLazySingleton(
      () => PaymentBloc(
        createPaymentUseCase: serviceLocator(),
        getPaymentUseCase: serviceLocator(),
        getPaymentByPnrUseCase: serviceLocator(),
      ),
    );
}

void _initWallet() {
  serviceLocator
    ..registerFactory<WalletRemoteDataSource>(() => WalletRemoteDataSourceImpl())
    ..registerFactory<WalletRepository>(
      () => WalletRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => GetBalance(serviceLocator()))
    ..registerFactory(() => ListWalletTransactions(serviceLocator()))
    ..registerFactory(() => TopupWallet(serviceLocator()))
    ..registerFactory(() => GetTopupStatus(serviceLocator()))
    ..registerLazySingleton(
      () => WalletBloc(
        getBalanceUseCase: serviceLocator(),
        listTransactionsUseCase: serviceLocator(),
        topupWalletUseCase: serviceLocator(),
        getTopupStatusUseCase: serviceLocator(),
      ),
    );
}

void _initTicket() {
  serviceLocator
    ..registerFactory<TicketRemoteDataSource>(() => TicketRemoteDataSourceImpl())
    ..registerFactory<TicketRepository>(
      () => TicketRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => CheckIn(serviceLocator()))
    ..registerFactory(() => GetBoardingPass(serviceLocator()))
    ..registerLazySingleton(
      () => TicketBloc(checkInUseCase: serviceLocator(), getBoardingPassUseCase: serviceLocator()),
    );
}

void _initProfile() {
  serviceLocator
    ..registerFactory<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl())
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => GetProfile(serviceLocator()))
    ..registerFactory(() => UpdateProfile(serviceLocator()))
    ..registerLazySingleton(
      () =>
          ProfileBloc(getProfileUseCase: serviceLocator(), updateProfileUseCase: serviceLocator()),
    );
}
