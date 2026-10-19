
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.65),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: colors.primary,
                size: 22,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Search destinations...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: colors.primary,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
