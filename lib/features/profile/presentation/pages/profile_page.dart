import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Are you sure you want to log out of TripMate?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    }
  }

  void _showAppearanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ThemeCubit>(),
          child: AlertDialog(
            title: const Text('Appearance'),
            content: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, selectedTheme) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      secondary: const Icon(Icons.light_mode_outlined),
                      value: ThemeMode.light,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeCubit>().changeTheme(value);
                          Navigator.pop(dialogContext);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
                      secondary: const Icon(Icons.dark_mode_outlined),
                      value: ThemeMode.dark,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeCubit>().changeTheme(value);
                          Navigator.pop(dialogContext);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('System default'),
                      secondary: const Icon(Icons.settings_brightness_outlined),
                      value: ThemeMode.system,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeCubit>().changeTheme(value);
                          Navigator.pop(dialogContext);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TripMate',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.travel_explore_rounded,
        size: 40,
      ),
      applicationLegalese: '© 2026 TripMate',
      children: [
        const SizedBox(height: 12),
        const Text(
          'TripMate is a travel planning application that helps '
              'you discover destinations, organize trips, and manage '
              'daily itineraries in one place.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final user = state is AuthAuthenticated ? state.user : null;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 36,
                  child: Icon(Icons.person_outline, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'TripMate Traveler',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  user?.email ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Your Travel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.luggage_outlined),
                    title: const Text('My Trips'),
                    subtitle: const Text('View and manage your travel plans'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      context.goNamed(RouteNames.trips);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Preferences',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Appearance'),
                    subtitle: const Text('Customize your app theme'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showAppearanceDialog(context),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('About TripMate'),
                    subtitle: const Text('App information and version'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showAboutDialog(context),
                  ),
                ),


                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red,),
                  title: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                  trailing: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.chevron_right),
                  enabled: !isLoading,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
