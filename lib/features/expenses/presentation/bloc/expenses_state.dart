
import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ExpensesInitial extends ExpensesState {
  const ExpensesInitial();
}

// Loading expenses
class ExpensesLoading extends ExpensesState {
  const ExpensesLoading();
}

// Expenses loaded successfully

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseEntity> expenses;
  final bool isSaving;
  final String? operationError;

  const ExpensesLoaded({
    required this.expenses,
    this.isSaving = false,
    this.operationError,
  });


  ExpensesLoaded copyWith({
    List<ExpenseEntity>? expenses,
    bool? isSaving,
    String? operationError,
    bool clearOperationError = false,
  }) {
    return ExpensesLoaded(
      expenses: expenses ?? this.expenses,
      isSaving: isSaving ?? this.isSaving,
      operationError: clearOperationError
          ? null
          : operationError ?? this.operationError,
    );
  }


  @override
  List<Object?> get props => [
    expenses,
    isSaving,
    operationError,
  ];
}


// Adding, updating, or deleting an expense
class ExpenseOperationInProgress extends ExpensesState {
  const ExpenseOperationInProgress();
}

// Expense operation completed successfully
class ExpenseOperationSuccess extends ExpensesState {
  final String message;

  const ExpenseOperationSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

// Error state
class ExpensesFailure extends ExpensesState {
  final String message;

  const ExpensesFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
