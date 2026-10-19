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



      floatingActionButton: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Color.lerp(
                Theme.of(context).colorScheme.primary,
                Colors.black,
                0.18,
              )!,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.22),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          child: InkWell(
            onTap: onCreateTrip,
            borderRadius: BorderRadius.circular(17),
            child: Center(
              child: Icon(
                Icons.add_rounded,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),



      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Theme.of(context)
            .colorScheme
            .shadow
            .withValues(alpha: 0.12),

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 46,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                isSelected ? selectedIcon : icon,
                size: 23,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

}