import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/explore/presentation/bloc/explore_bloc.dart';
import '../shell/main_shell.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/trips/domain/entities/trip_entity.dart';
import '../../features/trips/presentation/bloc/trips_bloc.dart';
import '../../features/trips/presentation/pages/create_trip.dart';
import '../../features/trips/presentation/pages/edit_trip_page.dart';
import '../../features/trips/presentation/pages/trip_details_page.dart';
import '../../features/trips/presentation/pages/trips_page.dart';
import '../../injection_container.dart';
import 'route_names.dart';
import 'route_paths.dart';

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
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) {
          return const RegisterPage();
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.path;

          int currentIndex = 0;

          if (location.startsWith(RoutePaths.explore)) {
            currentIndex = 1;
          } else if (location.startsWith(RoutePaths.trips)) {
            currentIndex = 2;
          } else if (location.startsWith(RoutePaths.profile)) {
            currentIndex = 3;
          }

          return MainShell(
            currentIndex: currentIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.goNamed(RouteNames.home);
                  break;

                case 1:
                  context.goNamed(RouteNames.explore);
                  break;

                case 2:
                  context.goNamed(RouteNames.trips);
                  break;

                case 3:
                  context.goNamed(RouteNames.profile);
                  break;
              }
            },
            onCreateTrip: () {
              context.pushNamed(
                RouteNames.createTrip,
              );
            },
            child: child,
          );
        },

        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) {
              return BlocProvider(
                create: (_) => sl<TripsBloc>(),
                child: const HomePage(),
              );
            },
          ),

          GoRoute(
            path: RoutePaths.explore,
            name: RouteNames.explore,
            builder: (context, state) {
              return BlocProvider(
                create: (_) => sl<ExploreBloc>(),
                child: const ExplorePage(),
              );
            },
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
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (context, state) {
              return const ProfilePage();
            },
          ),
        ],
      ),

      GoRoute(
        path: RoutePaths.createTrip,
        name: RouteNames.createTrip,
        builder: (context, state) {
          final initialDestination =
          state.extra as String?;

          return BlocProvider(
            create: (_) => sl<TripsBloc>(),
            child: CreateTripPage(
              initialDestination: initialDestination,
            ),
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