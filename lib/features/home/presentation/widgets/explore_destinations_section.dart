import 'package:flutter/material.dart';

import 'destination_card.dart';

class ExploreDestinationsSection extends StatelessWidget {
  final VoidCallback? onSeeAllTap;
  final ValueChanged<String>? onDestinationTap;

  const ExploreDestinationsSection({
    super.key,
    this.onSeeAllTap,
    this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final destinations = [
      const _DestinationData(
        name: 'Goa',
        subtitle: 'Beaches • Nightlife',
        imagePath: 'assets/images/destinations/goa.png',
      ),
      const _DestinationData(
        name: 'Jaipur',
        subtitle: 'Heritage • Culture',
        imagePath: 'assets/images/destinations/jaipur.png',
      ),
      const _DestinationData(
        name: 'Kerala',
        subtitle: 'Nature • Backwaters',
        imagePath: 'assets/images/destinations/kerala.png',
      ),
      const _DestinationData(
        name: 'Manali',
        subtitle: 'Mountains • Adventure',
        imagePath: 'assets/images/destinations/manali.png',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Explore Destinations',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: onSeeAllTap,
              child: const Text('See All'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 205,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: destinations.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 14);
            },
            itemBuilder: (context, index) {
              final destination = destinations[index];

              return DestinationCard(
                name: destination.name,
                subtitle: destination.subtitle,
                imagePath: destination.imagePath,
                onTap: () {
                  onDestinationTap?.call(
                    destination.name,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DestinationData {
  final String name;
  final String subtitle;
  final String imagePath;

  const _DestinationData({
    required this.name,
    required this.subtitle,
    required this.imagePath,
  });
}