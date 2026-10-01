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
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.landscape_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
            ),

            const Spacer(),

            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(
                Icons.notifications_none_rounded,
              ),
            ),

            const SizedBox(width: 4),

            InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(50),
              child: CircleAvatar(
                radius: 19,
                backgroundColor:
                colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.person_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          '${_getGreeting()} 👋',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Where do you want to go next?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    }

    if (hour < 17) {
      return 'Good Afternoon';
    }

    return 'Good Evening';
  }
}