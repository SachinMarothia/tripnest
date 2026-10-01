import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripmate/features/explore/presentation/pages/place_details_page.dart';

import '../../data/datasources/local_destination_data.dart';
import '../../data/models/destination_model.dart';
import '../bloc/explore_bloc.dart';
import '../bloc/explore_event.dart';
import '../bloc/explore_state.dart';
import '../widgets/explore_destination_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController =
  TextEditingController();

  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Mountains',
    'Beaches',
    'Cities',
    'Nature',
  ];

  List<DestinationModel> get _curatedDestinations {
    if (_selectedCategory == 'All') {
      return LocalDestinationData.destinations;
    }

    return LocalDestinationData.destinations
        .where(
          (destination) =>
      destination.category == _selectedCategory,
    )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchPlaces() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      context.read<ExploreBloc>().add(
        const ExploreCleared(),
      );
      return;
    }

    context.read<ExploreBloc>().add(
      ExploreSearchRequested(query),
    );
  }

  void _clearSearch() {
    _searchController.clear();

    context.read<ExploreBloc>().add(
      const ExploreCleared(),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ExploreBloc, ExploreState>(
      listener: (context, state) {
        if (state is ExplorePlaceDetailsLoaded) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlaceDetailsPage(
                place: state.place,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Discover your next destination',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
      
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) {
                    setState(() {});
                  },
                  onSubmitted: (_) {
                    _searchPlaces();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                    ),
                    suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 24),
      
                Text(
                  'Categories',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
      
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 9),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected =
                          category == _selectedCategory;
      
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        labelStyle:
                        theme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.surface,
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                      );
                    },
                  ),
                ),
      
                const SizedBox(height: 30),
      
                BlocBuilder<ExploreBloc, ExploreState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildResultsHeader(
                          context,
                          state,
                        ),
                        const SizedBox(height: 16),
                        _buildResults(
                          context,
                          state,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader(
      BuildContext context,
      ExploreState state,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String title;
    String countText = '';

    if (state is ExplorePlacesLoaded) {
      title = 'Search Results';
      countText = '${state.places.length} places';
    } else if (state is ExploreLoading) {
      title = 'Searching Places';
    } else {
      title = _selectedCategory == 'All'
          ? 'Popular Destinations'
          : _selectedCategory;

      countText =
      '${_curatedDestinations.length} places';
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (countText.isNotEmpty)
          Text(
            countText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildResults(
      BuildContext context,
      ExploreState state,
      ) {
    if (state is ExploreLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 50,
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is ExploreFailure) {
      return _ExploreMessage(
        icon: Icons.error_outline_rounded,
        title: 'Unable to load places',
        message: state.message,
      );
    }

    if (state is ExplorePlacesLoaded) {
      if (state.places.isEmpty) {
        return const _ExploreMessage(
          icon: Icons.travel_explore_rounded,
          title: 'No places found',
          message:
          'Try searching for another destination.',
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        itemCount: state.places.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final place = state.places[index];

          return _PlaceSearchCard(
            name: place.name,
            address: place.address,
            onTap: () {
              context.read<ExploreBloc>().add(
                ExplorePlaceDetailsRequested(
                  place.placeId,
                ),
              );
            },
          );
        },
      );
    }

    return _buildCuratedDestinations();
  }

  Widget _buildCuratedDestinations() {
    if (_curatedDestinations.isEmpty) {
      return const _ExploreMessage(
        icon: Icons.travel_explore_rounded,
        title: 'No destinations found',
        message:
        'Try selecting another category.',
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: _curatedDestinations.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        final destination =
        _curatedDestinations[index];

        return ExploreDestinationCard(
          destination: destination,
          onTap: () {},
        );
      },
    );
  }
}

class _PlaceSearchCard extends StatelessWidget {
  final String name;
  final String? address;
  final VoidCallback onTap;

  const _PlaceSearchCard({
    required this.name,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (address != null &&
                        address!.trim().isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        address!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        theme.textTheme.bodySmall?.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _ExploreMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.08,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 34,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}