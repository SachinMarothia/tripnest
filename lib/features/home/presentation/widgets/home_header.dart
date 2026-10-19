
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App branding and profile
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary,
                    Color.lerp(
                      colors.primary,
                      Colors.black,
                      0.20,
                    )!,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.landscape_rounded,
                color: colors.onPrimary,
                size: 25,
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TripMate',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                Text(
                  'EXPLORE MORE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 9,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Show notifications only when a real action exists.
            if (onNotificationTap != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Notifications',
                  onPressed: onNotificationTap,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                  ),
                ),
              ),

            Material(
              color: colors.primary.withValues(alpha: 0.10),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onProfileTap,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: colors.primary,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Greeting
        Text(
          _getGreeting(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Where will your next journey take you?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
