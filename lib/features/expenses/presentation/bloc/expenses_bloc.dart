
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/update_expense.dart';
import '../../domain/usecases/delete_expense.dart';

import 'expenses_event.dart';
import 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpenses getExpenses;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;

  ExpensesBloc({
    required this.getExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
  }) : super(const ExpensesInitial()) {

    on<ExpensesEvent>(
          (event, emit) async {
        if (event is ExpensesLoadRequested) {
          await _onLoadRequested(event, emit);
        } else if (event is ExpenseAddRequested) {
          await _onAddRequested(event, emit);
        } else if (event is ExpenseUpdateRequested) {
          await _onUpdateRequested(event, emit);
        } else if (event is ExpenseDeleteRequested) {
          await _onDeleteRequested(event, emit);
        }
      },
      transformer: sequential(),
    );

  }

  Future<void> _onLoadRequested(
      ExpensesLoadRequested event,
      Emitter<ExpensesState> emit,
      ) async {
    emit(const ExpensesLoading());

    try {
      final expenses = await getExpenses(event.tripId);

      emit(ExpensesLoaded(expenses: expenses));
    } catch (e) {
      emit(ExpensesFailure(
        message: 'Failed to load expenses: $e',
      ));
    }
  }

  Future<void> _onAddRequested(
      ExpenseAddRequested event,
      Emitter<ExpensesState> emit,
      ) async {
    final currentState = state;

    if (currentState is! ExpensesLoaded ||
        currentState.isSaving) {
      return;
    }

    emit(currentState.copyWith(
      isSaving: true,
      clearOperationError: true,
    ));

    try {
      await addExpense(event.expense);

      final expenses = await getExpenses(
        event.expense.tripId,
      );

      emit(ExpensesLoaded(expenses: expenses));

      // Refresh completes before showing success.
      // UI success feedback will be handled next.
    } catch (e) {
      emit(currentState.copyWith(
        isSaving: false,
        operationError: 'Failed to add expense: $e',
      ));
    }
  }

  Future<void> _onUpdateRequested(
      ExpenseUpdateRequested event,
      Emitter<ExpensesState> emit,
      ) async {
    final currentState = state;

    if (currentState is! ExpensesLoaded ||
        currentState.isSaving) {
      return;
    }

    emit(currentState.copyWith(
      isSaving: true,
      clearOperationError: true,
    ));

    try {
      await updateExpense(event.expense);

      final expenses = await getExpenses(
        event.expense.tripId,
      );

      emit(ExpensesLoaded(expenses: expenses));
    } catch (e) {
      emit(currentState.copyWith(
        isSaving: false,
        operationError: 'Failed to update expense: $e',
      ));
    }
  }

  Future<void> _onDeleteRequested(
      ExpenseDeleteRequested event,
      Emitter<ExpensesState> emit,
      ) async {
    final currentState = state;

    if (currentState is! ExpensesLoaded ||
        currentState.isSaving) {
      return;
    }

    emit(currentState.copyWith(
      isSaving: true,
      clearOperationError: true,
    ));

    try {
      await deleteExpense(
        tripId: event.tripId,
        expenseId: event.expenseId,
      );

      final expenses = await getExpenses(event.tripId);

      emit(ExpensesLoaded(expenses: expenses));
    } catch (e) {
      emit(currentState.copyWith(
        isSaving: false,
        operationError: 'Failed to delete expense: $e',
      ));
    }
  }
}
