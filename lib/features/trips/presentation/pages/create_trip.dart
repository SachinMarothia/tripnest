import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/trip_entity.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _descriptionController.dispose();
    _originController.dispose();

    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final today = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );

    if (selectedDate == null) return;

    setState(() {
      _startDate = selectedDate;

      if (_endDate != null && _endDate!.isBefore(selectedDate)) {
        _endDate = null;
      }
    });
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the start date first.'),
        ),
      );
      return;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(_startDate!.year + 5),
    );

    if (selectedDate == null) return;

    setState(() {
      _endDate = selectedDate;
    });
  }

  void _createTrip() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates.'),
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create a trip.'),
        ),
      );
      return;
    }

    final trip = TripEntity(
      id: '',
      userId: authState.user.id,
      title: _titleController.text.trim(),
      origin: _originController.text.trim(),
      destination: _destinationController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    context.read<TripsBloc>().add(
      TripCreateRequested(
        trip: trip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
      ),
        body: BlocConsumer<TripsBloc, TripsState>(
          listener: (context, state) {
            if (state is TripOperationSuccess) {
              final authState = context.read<AuthBloc>().state;

              if (authState is AuthAuthenticated) {
                context.read<TripsBloc>().add(
                  TripsLoadRequested(
                    userId: authState.user.id,
                  ),
                );
              }

              context.pop();
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
                        'Plan your next adventure',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Add the basic details for your trip.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _titleController,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Trip name',
                          hintText: 'e.g. Goa Vacation',
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
                      TextFormField(
                        controller: _originController,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'From',
                          hintText: 'e.g. Jaipur, Rajasthan',
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

                      TextFormField(
                        controller: _destinationController,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'To',
                          hintText: 'e.g. Goa, India',
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

                      TextFormField(
                        controller: _descriptionController,
                        enabled: !isLoading,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'What is this trip about?',
                          alignLabelWithHint: true,
                        ),
                      ),

                      const SizedBox(height: 24),

                      OutlinedButton.icon(
                        onPressed: isLoading ? null : _selectStartDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(
                          _startDate == null
                              ? 'Select start date'
                              : 'Start: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        onPressed: isLoading ? null : _selectEndDate,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(
                          _endDate == null
                              ? 'Select end date'
                              : 'End: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        ),
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton.icon(
                        onPressed: isLoading ? null : _createTrip,
                        icon: isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(Icons.add),
                        label: Text(
                          isLoading ? 'Creating...' : 'Create Trip',
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
}