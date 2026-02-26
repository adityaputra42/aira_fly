import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/features/flight/ui/addonBooking/screen/meal/addon_meal_screen.dart';
import 'package:pss_app/features/flight/ui/bookingPayment/screen/booking_detail_screen.dart';
import 'package:pss_app/features/flight/ui/flightSelecting/screen/flight_selecting_screen.dart';
import 'package:pss_app/features/flight/ui/searchAirport/screen/search_airport_screen.dart';

import '../../features/flight/ui/addonBooking/screen/addon_booking_screen.dart';
import '../../features/flight/ui/addonBooking/screen/baggage/addon_bagage_screen.dart';
import '../../features/flight/ui/addonBooking/screen/baggage/selecting_baggage_screen.dart';
import '../../features/flight/ui/addonBooking/screen/meal/selecting_meal_screen.dart';
import '../../features/flight/ui/addonBooking/screen/seat/addon_seat_screen.dart';
import '../../features/flight/ui/addonBooking/screen/seat/selecting_seat_screen.dart';
import '../../features/flight/ui/flightResult/screen/flight_result_screen.dart';
import '../../features/flight/ui/paxBooking/screen/pax_booking_screen.dart';
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
            path: RouteNames.searchAirport,
            name: RouteNames.searchAirport,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: const SearchAirportScreen(),
              transition: PageTransitionType.fadeScale,
            ),
          ),
          GoRoute(
            path: RouteNames.flightSelecting,
            name: RouteNames.flightSelecting,
            pageBuilder: (context, state) => buildPageWithTransition(
              key: state.pageKey,
              child: const FlightSelectingScreen(),
              transition: PageTransitionType.fadeScale,
            ),
            routes: [
              GoRoute(
                path: RouteNames.flightResult,
                name: RouteNames.flightResult,
                pageBuilder: (context, state) => buildPageWithTransition(
                  key: state.pageKey,
                  child: const FlightResultScreen(),
                  transition: PageTransitionType.fadeScale,
                ),
                routes: [
                  GoRoute(
                    path: RouteNames.paxBooking,
                    name: RouteNames.paxBooking,
                    pageBuilder: (context, state) => buildPageWithTransition(
                      key: state.pageKey,
                      child: const PaxBookingScreen(),
                      transition: PageTransitionType.fadeScale,
                    ),
                    routes: [
                      GoRoute(
                        path: RouteNames.addonBooking,
                        name: RouteNames.addonBooking,
                        pageBuilder: (context, state) => buildPageWithTransition(
                          key: state.pageKey,
                          child: const AddonBookingScreen(),
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
                              child: const AddonBagageScreen(),
                              transition: PageTransitionType.fadeScale,
                            ),
                            routes: [
                              GoRoute(
                                path: RouteNames.selectingBaggage,
                                name: RouteNames.selectingBaggage,
                                pageBuilder: (context, state) => buildPageWithTransition(
                                  key: state.pageKey,
                                  child: const SelectingBaggageScreen(),
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
                              child: const AddonMealScreen(),
                              transition: PageTransitionType.fadeScale,
                            ),
                            routes: [
                              GoRoute(
                                path: RouteNames.selectingMeal,
                                name: RouteNames.selectingMeal,
                                pageBuilder: (context, state) => buildPageWithTransition(
                                  key: state.pageKey,
                                  child: const SelectingMealScreen(),
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
                              child: const AddonSeatScreen(),
                              transition: PageTransitionType.fadeScale,
                            ),
                            routes: [
                              GoRoute(
                                path: RouteNames.selectingSeat,
                                name: RouteNames.selectingSeat,
                                pageBuilder: (context, state) => buildPageWithTransition(
                                  key: state.pageKey,
                                  child: const SelectingSeatScreen(),
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

enum PageTransitionType {
  fade,
  fadeScale,
  fadeThrough,
  sharedAxisHorizontal,
  sharedAxisVertical,
  sharedAxisScaled,
}

CustomTransitionPage buildPageWithTransition({
  required Widget child,
  required LocalKey key,
  PageTransitionType transition = PageTransitionType.fade,
}) {
  final isAndroid = Platform.isAndroid;
  final duration = isAndroid
      ? const Duration(milliseconds: 800)
      : const Duration(milliseconds: 600);

  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: Duration(milliseconds: (duration.inMilliseconds * 0.75).round()),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);

      final curvedSecondaryAnimation = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInOutCubic,
      );

      switch (transition) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: curvedAnimation, child: child);

        case PageTransitionType.fadeScale:
          return FadeScaleTransition(animation: curvedAnimation, child: child);

        case PageTransitionType.fadeThrough:
          return FadeThroughTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          );

        case PageTransitionType.sharedAxisHorizontal:
          return SharedAxisTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          );

        case PageTransitionType.sharedAxisVertical:
          return SharedAxisTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: Colors.transparent,
            child: child,
          );

        case PageTransitionType.sharedAxisScaled:
          return SharedAxisTransition(
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            fillColor: Colors.transparent,
            child: child,
          );
      }
    },
  );
}
