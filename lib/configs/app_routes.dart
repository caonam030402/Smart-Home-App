import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/constants/path_routes.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/screens/light_management_screen.dart';
import 'package:smart_home/screens/main_screen.dart';
import 'package:smart_home/screens/onboarding_screen.dart';
import 'package:smart_home/screens/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: PathRoute.onboarding,
  routes: <RouteBase>[
    GoRoute(
      path: PathRoute.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: PathRoute.onboarding,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: PathRoute.main,
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: PathRoute.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: PathRoute.lightManagement,
      builder: (BuildContext context, GoRouterState state) {
        return const LightManagementScreen();
      },
    ),
  ],
);
