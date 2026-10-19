
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense_entity.dart';
import '../bloc/expenses_bloc.dart';
import '../bloc/expenses_event.dart';
import '../bloc/expenses_state.dart';

class ExpenseForm extends StatefulWidget {
  final String tripId;
  final ExpenseEntity? expense;

  const ExpenseForm({
    super.key,
    required this.tripId,
    this.expense,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  static const List<String> _categories = [
    'Food',
    'Transport',
    'Accommodation',
    'Activities',
    'Shopping',
    'Other',
  ];

  late String _selectedCategory;
  late DateTime _selectedDate;

  bool _wasSaving = false;
  bool _saveStarted = false;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();

    final expense = widget.expense;

    _titleController = TextEditingController(
      text: expense?.title ?? '',
    );

    _amountController = TextEditingController(
      text: expense?.amount.toString() ?? '',
    );

    _noteController = TextEditingController(
      text: expense?.note ?? '',
    );

    _selectedCategory = expense != null &&
        _categories.contains(expense.category)
        ? expense.category
        : 'Other';

    _selectedDate = expense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveExpense() {
    if (_saveStarted) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(
      _amountController.text.trim(),
    );

    if (amount == null ||
        !amount.isFinite ||
        amount <= 0) {
      return;
    }

    final currentState = context.read<ExpensesBloc>().state;

    if (currentState is! ExpensesLoaded ||
        currentState.isSaving) {
      return;
    }

    final note = _noteController.text.trim();

    final expense = ExpenseEntity(
      id: widget.expense?.id ?? '',
      tripId: widget.tripId,
      title: _titleController.text.trim(),
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
      note: note.isEmpty ? null : note,
    );

    setState(() {
      _saveStarted = true;
      _wasSaving = false;
    });

    final bloc = context.read<ExpensesBloc>();

    if (_isEditing) {
      bloc.add(
        ExpenseUpdateRequested(expense: expense),
      );
    } else {
      bloc.add(
        ExpenseAddRequested(expense: expense),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ExpensesBloc, ExpensesState>(
      listener: (context, state) {
        if (!_saveStarted) return;

        if (state is ExpensesLoaded) {
          if (state.isSaving) {
            _wasSaving = true;
            return;
          }

          if (_wasSaving) {
            if (state.operationError == null) {
              _saveStarted = false;
              _wasSaving = false;

              Navigator.of(context).pop();
            } else {
              setState(() {
                _saveStarted = false;
                _wasSaving = false;
              });
            }
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing
                      ? 'Edit Expense'
                      : 'Add Expense',
                  style: theme.textTheme.titleLarge,
                ),

                const SizedBox(height: 20),

                // EXPENSE TITLE
                TextFormField(
                  controller: _titleController,
                  textCapitalization:
                  TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Expense Title',
                    hintText: 'e.g. Hotel booking',
                    prefixIcon:
                    Icon(Icons.receipt_long_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter an expense title';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // AMOUNT
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    hintText: '0.00',
                    prefixIcon:
                    Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final amount = double.tryParse(
                      value?.trim() ?? '',
                    );

                    if (amount == null ||
                        !amount.isFinite ||
                        amount <= 0) {
                      return 'Enter a valid amount greater than zero';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // CATEGORY
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon:
                    Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                // EXPENSE DATE
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Expense Date',
                      prefixIcon:
                      Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(
                        _selectedDate,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // OPTIONAL NOTES
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  textCapitalization:
                  TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText:
                    'Add details about this expense...',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                // INLINE OPERATION ERROR
                BlocBuilder<ExpensesBloc, ExpensesState>(
                  builder: (context, state) {
                    if (state is! ExpensesLoaded ||
                        state.operationError == null) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        state.operationError!,
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                ),

                // SAVE BUTTON
                BlocBuilder<ExpensesBloc, ExpensesState>(
                  builder: (context, state) {
                    final isSaving =
                        state is ExpensesLoaded &&
                            state.isSaving;

                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                        (_saveStarted || isSaving)
                            ? null
                            : _saveExpense,
                        child: isSaving
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          _isEditing
                              ? 'Update Expense'
                              : 'Save Expense',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
