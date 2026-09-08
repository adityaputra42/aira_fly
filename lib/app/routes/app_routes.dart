import 'package:go_router/go_router.dart';
import 'package:pss_app/core/animation/page_transition.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/screen/meal/addon_meal_screen.dart';
import 'package:pss_app/features/flight/presentation/bookingPayment/screen/booking_detail_screen.dart';
import 'package:pss_app/features/flight/presentation/flightSelecting/screen/flight_selecting_screen.dart';
import 'package:pss_app/features/flight/presentation/searchAirport/screen/search_airport_screen.dart';
import 'package:pss_app/features/home/presentation/widget/date_picker_screen.dart';
import 'package:pss_app/features/ticket/presentation/screen/ticket_detail.dart';

import '../../features/flight/presentation/addonBooking/screen/addon_booking_screen.dart';
import '../../features/flight/presentation/addonBooking/screen/baggage/addon_bagage_screen.dart';
import '../../features/flight/presentation/addonBooking/screen/baggage/selecting_baggage_screen.dart';
import '../../features/flight/presentation/addonBooking/screen/meal/selecting_meal_screen.dart';
import '../../features/flight/presentation/addonBooking/screen/seat/addon_seat_screen.dart';
import '../../features/flight/presentation/addonBooking/screen/seat/selecting_seat_screen.dart';
import '../../features/flight/presentation/addonBooking/utils/addon_models.dart';
import '../../features/flight/presentation/flightResult/screen/flight_result_screen.dart';
import '../../features/flight/presentation/paxBooking/screen/pax_booking_screen.dart';
import '../../features/main/ui/screen/main_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import '../../features/auth/presentation/screen/sign_in_screen.dart';
import '../../features/auth/presentation/screen/sign_up_screen.dart';
import '../../features/onboarding/ui/screen/onboarding_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const SplashScreen(),
          transition: PageTransitionType.fade,
        ),
      ),
      GoRoute(
        path: '/${RouteNames.onboarding}',
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transition: PageTransitionType.sharedAxisHorizontal,
        ),
      ),
      GoRoute(
        path: '/${RouteNames.main}',
        name: RouteNames.main,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const MainScreen(),
          transition: PageTransitionType.fadeThrough,
        ),
        routes: [
          GoRoute(
            path: RouteNames.ticketDetail,
            name: RouteNames.ticketDetail,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: const TicketDetailScreen(),
              transition: PageTransitionType.fadeScale,
            ),
          ),
          GoRoute(
            path: RouteNames.selectDate,
            name: RouteNames.selectDate,
            pageBuilder: (context, state) {
              final arguments = state.extra as DatePickerArguments;
              return buildPageWithTransition(
                key: state.pageKey,
                child: DatePickerScreen(arguments: arguments),
                transition: PageTransitionType.fadeScale,
              );
            },
          ),
          GoRoute(
            path: RouteNames.searchAirport,
            name: RouteNames.searchAirport,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: SearchAirportScreen(arguments: state.extra as SearchAirportArguments?),
              transition: PageTransitionType.fadeScale,
            ),
          ),
          GoRoute(
            path: RouteNames.flightSelecting,
            name: RouteNames.flightSelecting,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: FlightSelectingScreen(arguments: state.extra as FlightSelectingArguments),
              transition: PageTransitionType.fadeScale,
            ),
            routes: [
              GoRoute(
                path: RouteNames.flightResult,
                name: RouteNames.flightResult,
                pageBuilder: (context, state) => buildPageWithTransition(
                  key: state.pageKey,
                  child: FlightResultScreen(arguments: state.extra as FlightResultArguments),
                  transition: PageTransitionType.fadeScale,
                ),
                routes: [
                  GoRoute(
                    path: RouteNames.paxBooking,
                    name: RouteNames.paxBooking,
                    pageBuilder: (context, state) => buildPageWithTransition(
                      key: state.pageKey,
                      child: PaxBookingScreen(arguments: state.extra as FlightResultArguments),
                      transition: PageTransitionType.fadeScale,
                    ),
                    routes: [
                      GoRoute(
                        path: RouteNames.addonBooking,
                        name: RouteNames.addonBooking,
                        pageBuilder: (context, state) => buildPageWithTransition(
                          key: state.pageKey,
                          child: AddonBookingScreen(
                            paxBookingResult: state.extra as PaxBookingResult,
                          ),
                          transition: PageTransitionType.fadeScale,
                        ),
                        routes: [
                          GoRoute(
                            path: RouteNames.bookingDetail,
                            name: RouteNames.bookingDetail,
                            pageBuilder: (context, state) => buildPageWithTransition(
                              key: state.pageKey,
                              child: const BookingDetailScreen(),
                              transition: PageTransitionType.fadeScale,
                            ),
                          ),
                          GoRoute(
                            path: RouteNames.addonBaggage,
                            name: RouteNames.addonBaggage,
                            pageBuilder: (context, state) => buildPageWithTransition(
                              key: state.pageKey,
                              child: AddonBagageScreen(
                                arguments: state.extra as AncillaryHubArguments,
                              ),
                              transition: PageTransitionType.fadeScale,
                            ),
                            routes: [
                              GoRoute(
                                path: RouteNames.selectingBaggage,
                                name: RouteNames.selectingBaggage,
                                pageBuilder: (context, state) => buildPageWithTransition(
                                  key: state.pageKey,
                                  child: SelectingBaggageScreen(
                                    arguments: state.extra as AncillaryPickerArguments,
                                  ),
                                  transition: PageTransitionType.fadeScale,
                                ),
                              ),
                            ],
                          ),
                          GoRoute(
                            path: RouteNames.addonMeal,
                            name: RouteNames.addonMeal,
                            pageBuilder: (context, state) => buildPageWithTransition(
                              key: state.pageKey,
                              child: AddonMealScreen(
                                arguments: state.extra as AncillaryHubArguments,
                              ),
                              transition: PageTransitionType.fadeScale,
                            ),
                            routes: [
                              GoRoute(
                                path: RouteNames.selectingMeal,
                                name: RouteNames.selectingMeal,
                                pageBuilder: (context, state) => buildPageWithTransition(
                                  key: state.pageKey,
                                  child: SelectingMealScreen(
                                    arguments: state.extra as AncillaryPickerArguments,
                                  ),
                                  transition: PageTransitionType.fadeScale,
                                ),
                              ),
                            ],
                          ),
                          GoRoute(
                            path: RouteNames.addonSeat,
                            name: RouteNames.addonSeat,
                            pageBuilder: (context, state) => buildPageWithTransition(
                              key: state.pageKey,
                              child: AddonSeatScreen(arguments: state.extra as SeatHubArguments),
                              transition: PageTransitionType.fadeScale,
                            ),
                            routes: [
                              GoRoute(
                                path: RouteNames.selectingSeat,
                                name: RouteNames.selectingSeat,
                                pageBuilder: (context, state) => buildPageWithTransition(
                                  key: state.pageKey,
                                  child: SelectingSeatScreen(
                                    arguments: state.extra as SeatPickerArguments,
                                  ),
                                  transition: PageTransitionType.fadeScale,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/${RouteNames.signin}',
        name: RouteNames.signin,
        pageBuilder: (context, state) => buildPageWithTransition(
          key: state.pageKey,
          child: const SignInScreen(),
          transition: PageTransitionType.sharedAxisVertical,
        ),
        routes: [
          GoRoute(
            path: RouteNames.signup,
            name: RouteNames.signup,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: const SignUpScreen(),
              transition: PageTransitionType.fadeScale,
            ),
          ),
        ],
      ),
    ],
  );
}
