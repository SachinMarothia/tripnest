import 'package:flutter/material.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onCreateTrip;

  const MainShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onCreateTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,

      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTrip,
        backgroundColor: Color.lerp(
          Theme.of(context).colorScheme.primary,
          Colors.black,
          0.10,
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: _NavigationItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onDestinationSelected(0),
              ),
            ),

            Expanded(
              child: _NavigationItem(
                icon: Icons.search_outlined,
                selectedIcon: Icons.search_rounded,
                label: 'Explore',
                isSelected: currentIndex == 1,
                onTap: () => onDestinationSelected(1),
              ),
            ),

            // Space for center FAB.
            const SizedBox(width: 64),

            Expanded(
              child: _NavigationItem(
                icon: Icons.luggage_outlined,
                selectedIcon: Icons.luggage_rounded,
                label: 'Trips',
                isSelected: currentIndex == 2,
                onTap: () => onDestinationSelected(2),
              ),
            ),

            Expanded(
              child: _NavigationItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => onDestinationSelected(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                color: color,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}