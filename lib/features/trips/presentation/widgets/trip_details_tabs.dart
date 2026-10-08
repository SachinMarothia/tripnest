import 'package:flutter/material.dart';

enum TripDetailsTab {
  overview,
  itinerary,
}

class TripDetailsTabs extends StatelessWidget {
  final TripDetailsTab selectedTab;
  final ValueChanged<TripDetailsTab> onChanged;

  const TripDetailsTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              label: 'Overview',
              icon: Icons.dashboard_outlined,
              isSelected:
              selectedTab == TripDetailsTab.overview,
              onTap: () {
                onChanged(TripDetailsTab.overview);
              },
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _TabItem(
              label: 'Itinerary',
              icon: Icons.route_outlined,
              isSelected:
              selectedTab == TripDetailsTab.itinerary,
              onTap: () {
                onChanged(TripDetailsTab.itinerary);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.surface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: 0.08,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}