import 'package:flutter/material.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _CategoryItem(
            icon: Icons.landscape_outlined,
            label: 'Mountains',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _CategoryItem(
            icon: Icons.beach_access_outlined,
            label: 'Beaches',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _CategoryItem(
            icon: Icons.location_city_outlined,
            label: 'Cities',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _CategoryItem(
            icon: Icons.more_horiz_rounded,
            label: 'More',
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        // Explore filtering will be connected later.
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(
            alpha: 0.07,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 27,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}