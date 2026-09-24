import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Logout completed successfully.
        if (state is AuthUnauthenticated) {
          context.goNamed(RouteNames.login);
        }

        // Something went wrong while logging out.
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        String? userName;
        String? userEmail;

        if (state is AuthAuthenticated) {
          userName = state.user.name;
          userEmail = state.user.email;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('TripMate'),
            actions: [
              IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                  context.read<AuthBloc>().add(
                    const AuthLogoutRequested(),
                  );
                },
                icon: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.travel_explore,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        userName != null && userName.isNotEmpty
                            ? 'Welcome, $userName'
                            : 'Welcome to TripMate',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Your authentication flow is working successfully.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 40,
                              color: theme.colorScheme.primary,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'You are logged in',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Trip planning features will be added here.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16,),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.pushNamed(RouteNames.trips);
                        },
                        icon: const Icon(Icons.luggage_outlined),
                        label: const Text('My Trips'),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                            context.read<AuthBloc>().add(
                              const AuthLogoutRequested(),
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}