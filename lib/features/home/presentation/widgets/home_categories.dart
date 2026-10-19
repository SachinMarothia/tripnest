
import 'package:flutter/material.dart';

class HomeCategories extends StatelessWidget {
  final ValueChanged<String> onCategorySelected;

  const HomeCategories({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryItem(
            icon: Icons.landscape_outlined,
            label: 'Mountains',
            onTap: () => onCategorySelected('Mountains'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CategoryItem(
            icon: Icons.beach_access_outlined,
            label: 'Beaches',
            onTap: () => onCategorySelected('Beaches'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CategoryItem(
            icon: Icons.location_city_outlined,
            label: 'Cities',
            onTap: () => onCategorySelected('Cities'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CategoryItem(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            onTap: () => onCategorySelected('All'),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.primary.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 27,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
