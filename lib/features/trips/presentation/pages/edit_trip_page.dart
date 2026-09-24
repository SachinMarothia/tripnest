import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/trip_entity.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';

class EditTripPage extends StatefulWidget {
  final TripEntity trip;

  const EditTripPage({
    super.key,
    required this.trip,
  });

  @override
  State<EditTripPage> createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _originController;
  late final TextEditingController _destinationController;
  late final TextEditingController _descriptionController;

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.trip.title,
    );

    _originController = TextEditingController(
      text: widget.trip.origin,
    );

    _destinationController = TextEditingController(
      text: widget.trip.destination,
    );

    _descriptionController = TextEditingController(
      text: widget.trip.description ?? '',
    );

    _startDate = widget.trip.startDate;
    _endDate = widget.trip.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (selectedDate == null) return;

    setState(() {
      _startDate = selectedDate;

      if (_endDate.isBefore(_startDate)) {
        _endDate = _startDate;
      }
    });
  }

  Future<void> _selectEndDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate)
          ? _startDate
          : _endDate,
      firstDate: _startDate,
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (selectedDate == null) return;

    setState(() {
      _endDate = selectedDate;
    });
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedTrip = TripEntity(
      id: widget.trip.id,
      userId: widget.trip.userId,
      title: _titleController.text.trim(),
      origin: _originController.text.trim(),
      destination: _destinationController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      coverImageUrl: widget.trip.coverImageUrl,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    context.read<TripsBloc>().add(
      TripUpdateRequested(
        trip: updatedTrip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Trip'),
      ),
      body: BlocConsumer<TripsBloc, TripsState>(
        listener: (context, state) {
          if (state is TripOperationSuccess) {
            Navigator.of(context).pop(true);
          }

          if (state is TripsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is TripsLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit your trip',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Update your trip information.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 24),

                    // Trip name
                    TextFormField(
                      controller: _titleController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Trip name',
                        prefixIcon: Icon(Icons.luggage_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a trip name.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Origin
                    TextFormField(
                      controller: _originController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'From',
                        prefixIcon: Icon(Icons.trip_origin_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the starting location.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Destination
                    TextFormField(
                      controller: _destinationController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'To',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the destination.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      enabled: !isLoading,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Start date
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _selectStartDate,
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      label: Text(
                        'Start: ${_formatDate(_startDate)}',
                      ),
                    ),

                    const SizedBox(height: 12),

                    // End date
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _selectEndDate,
                      icon: const Icon(
                        Icons.event_outlined,
                      ),
                      label: Text(
                        'End: ${_formatDate(_endDate)}',
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _saveChanges,
                      icon: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        isLoading
                            ? 'Saving...'
                            : 'Save Changes',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}