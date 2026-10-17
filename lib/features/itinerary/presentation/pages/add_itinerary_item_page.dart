import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import '../../../../injection_container.dart';
import '../../../explore/domain/entities/place_entity.dart';
import '../../../explore/domain/usecases/search_places.dart';

import '../../domain/entities/itinerary_entity.dart';
import '../bloc/itinerary_bloc.dart';
import '../bloc/itinerary_event.dart';
import '../bloc/itinerary_state.dart';

class AddItineraryItemPage extends StatefulWidget {
  final String tripId;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final ItineraryEntity? activity;
  final PlaceEntity? initialPlace;

  const AddItineraryItemPage({
    super.key,
    required this.tripId,
    required this.tripStartDate,
    required this.tripEndDate,
    this.activity,
    this.initialPlace,
  });

  @override
  State<AddItineraryItemPage> createState() => _AddItineraryItemPageState();
}

class _AddItineraryItemPageState extends State<AddItineraryItemPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool get _isEditing => widget.activity != null;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isSaving = false;

  double? _selectedLatitude;
  double? _selectedLongitude;

  Timer? _searchDebounce;

  List<PlaceEntity> _locationSuggestions = [];

  bool _isSearchingLocation = false;
  String? _locationSearchError;

  int _locationSearchVersion = 0;

  @override
  void initState() {
    super.initState();

    final activity = widget.activity;

    if (activity != null) {
      _titleController.text = activity.title;
      _locationController.text = activity.location ?? '';
      _descriptionController.text = activity.description ?? '';

      _selectedDate = activity.date;
      _selectedLatitude = activity.latitude;
      _selectedLongitude = activity.longitude;

      if (activity.hour != null && activity.minute != null) {
        _selectedTime = TimeOfDay(
          hour: activity.hour!,
          minute: activity.minute!,
        );
      }
    }
    else if (widget.initialPlace != null) {
      final place = widget.initialPlace!;

      _titleController.text = place.name;

      _locationController.text =
      place.address?.trim().isNotEmpty == true
          ? place.address!
          : place.name;

      _selectedLatitude = place.latitude;
      _selectedLongitude = place.longitude;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _locationSearchVersion++;

    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    final startDate = DateUtils.dateOnly(widget.tripStartDate);
    final endDate = DateUtils.dateOnly(widget.tripEndDate);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? startDate,
      firstDate: startDate,
      lastDate: endDate,
      helpText: 'Select Activity Date',
    );

    if (selectedDate == null || !mounted) return;

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    setState(() {
      _selectedTime = selectedTime;
    });
  }

  void _onLocationChanged(String query) {
    _searchDebounce?.cancel();

    final version = ++_locationSearchVersion;

    setState(() {
      _locationSuggestions = [];
      _locationSearchError = null;
      _isSearchingLocation = false;
    });

    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 3) return;

    _searchDebounce = Timer(
      const Duration(milliseconds: 1100),
          () async {
        if (!mounted || version != _locationSearchVersion) return;

        setState(() {
          _isSearchingLocation = true;
        });

        try {
          final results = await sl<SearchPlaces>()(trimmedQuery);

          if (!mounted || version != _locationSearchVersion) return;

          setState(() {
            _locationSuggestions = results;
            _isSearchingLocation = false;
          });
        } catch (_) {
          if (!mounted || version != _locationSearchVersion) return;

          setState(() {
            _locationSuggestions = [];
            _isSearchingLocation = false;
            _locationSearchError = 'Unable to search locations';
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ItineraryBloc, ItineraryState>(
      listener: (context, state) {
        if (state is ItineraryOperationSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is ItineraryFailure) {
          setState(() {
            _isSaving = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? 'Edit Activity' : 'Add Activity',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Activity Details',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 8),

                Text(
                  'Add something you want to do during this trip.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 28),

                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Activity title',
                    hintText: 'e.g. Visit Amber Fort',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an activity title';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select date'
                          : _formatDate(_selectedDate!),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                InkWell(
                  onTap: _selectTime,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      prefixIcon: Icon(Icons.schedule_outlined),
                    ),
                    child: Text(
                      _selectedTime == null
                          ? 'Select time'
                          : _selectedTime!.format(context),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _locationController,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _searchLocation(),
                  onChanged: (_) {
                    ++_locationSearchVersion;

                    setState(() {
                      _selectedLatitude = null;
                      _selectedLongitude = null;

                      _locationSuggestions = [];
                      _locationSearchError = null;
                      _isSearchingLocation = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'e.g. Amber Fort, Jaipur',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    suffixIcon: IconButton(
                      tooltip: 'Search location',
                      onPressed: _isSearchingLocation ? null : _searchLocation,
                      icon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),

                if (_isSearchingLocation) ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],

                if (_locationSearchError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _locationSearchError!,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],

                if (_locationSuggestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: _locationSuggestions.map((place) {
                        return ListTile(
                          leading: const Icon(Icons.place_outlined),
                          title: Text(place.name),
                          subtitle: place.address != null
                              ? Text(
                            place.address!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                              : null,
                          onTap: () => _selectLocation(place),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Add notes about this activity...',
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 32),

                FilledButton.icon(
                  onPressed: _isSaving ? null : _saveActivity,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : Icon(
                    _isEditing
                        ? Icons.save_outlined
                        : Icons.add_rounded,
                  ),
                  label: Text(
                    _isSaving
                        ? 'Saving...'
                        : _isEditing
                        ? 'Save Changes'
                        : 'Add Activity',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  void _saveActivity() {

    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity date')),
      );
      return;
    }

    // Validate that the activity date is within the trip dates.
    final activityDate = DateUtils.dateOnly(_selectedDate!);
    final startDate = DateUtils.dateOnly(widget.tripStartDate);
    final endDate = DateUtils.dateOnly(widget.tripEndDate);

    if (activityDate.isBefore(startDate) || activityDate.isAfter(endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity date must be within the trip dates'),
        ),
      );
      return;
    }

    final activity = ItineraryEntity(
      id: widget.activity?.id ?? '',
      tripId: widget.tripId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _selectedDate!,
      hour: _selectedTime?.hour,
      minute: _selectedTime?.minute,
      location: _locationController.text.trim(),
      latitude: _selectedLatitude,
      longitude: _selectedLongitude,
      isCompleted: widget.activity?.isCompleted ?? false
    );

    setState(() {
      _isSaving = true;
    });

    if (_isEditing) {
      context.read<ItineraryBloc>().add(
        ItineraryUpdateRequested(item: activity),
      );
    } else {
      context.read<ItineraryBloc>().add(
        ItineraryAddRequested(item: activity),
      );
    }
  }
  Future<void> _searchLocation() async {
    final query = _locationController.text.trim();

    if (query.length < 3) {
      setState(() {
        _locationSuggestions = [];
        _locationSearchError = 'Enter at least 3 characters';
      });
      return;
    }

    final version = ++_locationSearchVersion;

    setState(() {
      _isSearchingLocation = true;
      _locationSearchError = null;
      _locationSuggestions = [];
    });

    try {
      final results = await sl<SearchPlaces>()(query);

      if (!mounted || version != _locationSearchVersion) return;

      setState(() {
        _locationSuggestions = results;
        _isSearchingLocation = false;
      });
    } catch (_) {
      if (!mounted || version != _locationSearchVersion) return;

      setState(() {
        _isSearchingLocation = false;
        _locationSearchError = 'Unable to search locations';
      });
    }
  }
  void _selectLocation(PlaceEntity place) {
    ++_locationSearchVersion;

    setState(() {
      _locationController.text =
      place.address?.trim().isNotEmpty == true
          ? place.address!
          : place.name;

      _selectedLatitude = place.latitude;
      _selectedLongitude = place.longitude;

      _locationSuggestions = [];
      _locationSearchError = null;
      _isSearchingLocation = false;
    });

    FocusScope.of(context).unfocus();
  }
}
