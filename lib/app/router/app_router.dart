import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/rout_paths.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/trips/domain/entities/trip_entity.dart';
import '../../features/trips/presentation/bloc/trips_bloc.dart';
import '../../features/trips/presentation/pages/create_trip.dart';
import '../../features/trips/presentation/pages/edit_trip_page.dart';
import '../../features/trips/presentation/pages/trip_details_page.dart';
import '../../features/trips/presentation/pages/trips_page.dart';
import '../../injection_container.dart';
import 'route_names.dart';

abstract final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,

    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) {
          return const SplashPage();
        },
      ),

      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) {
          return const HomePage();
        },
      ),

      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: RoutePaths.trips,
        name: RouteNames.trips,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<TripsBloc>(),
            child: const TripsPage(),
          );
        },
      ),

      GoRoute(
        path: RoutePaths.createTrip,
        name: RouteNames.createTrip,
        builder: (context, state) {
          return BlocProvider.value(
            value: state.extra! as TripsBloc,
            child: const CreateTripPage(),
          );
        },
      ),

      GoRoute(
        path: RoutePaths.tripDetails,
        name: RouteNames.tripDetails,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId']!;

          return BlocProvider(
            create: (_) => sl<TripsBloc>(),
            child: TripDetailsPage(
              tripId: tripId,
            ),
          );
        },
      ),

      GoRoute(
        path: RoutePaths.editTrip,
        name: RouteNames.editTrip,
        builder: (context, state) {
          final trip = state.extra! as TripEntity;

          return BlocProvider(
            create: (_) => sl<TripsBloc>(),
            child: EditTripPage(
              trip: trip,
            ),
          );
        },
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Page not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    },
  );
}