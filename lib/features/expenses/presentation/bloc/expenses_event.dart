
import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => [];
}

// Load expenses belonging to a trip
class ExpensesLoadRequested extends ExpensesEvent {
  final String tripId;

  const ExpensesLoadRequested({
    required this.tripId,
  });

  @override
  List<Object?> get props => [tripId];
}

// Add a new expense
class ExpenseAddRequested extends ExpensesEvent {
  final ExpenseEntity expense;

  const ExpenseAddRequested({
    required this.expense,
  });

  @override
  List<Object?> get props => [expense];
}

// Update an existing expense
class ExpenseUpdateRequested extends ExpensesEvent {
  final ExpenseEntity expense;

  const ExpenseUpdateRequested({
    required this.expense,
  });

  @override
  List<Object?> get props => [expense];
}

// Delete an expense
class ExpenseDeleteRequested extends ExpensesEvent {
  final String tripId;
  final String expenseId;

  const ExpenseDeleteRequested({
    required this.tripId,
    required this.expenseId,
  });

  @override
  List<Object?> get props => [tripId, expenseId];
}
