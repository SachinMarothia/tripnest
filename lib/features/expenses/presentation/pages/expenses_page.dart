import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expenses_bloc.dart';
import '../bloc/expenses_event.dart';
import '../bloc/expenses_state.dart';
import '../widgets/expense_form.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/expense_summary_card.dart';

class ExpensesPage extends StatelessWidget {
  final String tripId;
  final double? budget;

  const ExpensesPage({super.key, required this.tripId, this.budget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ExpensesBloc>()..add(ExpensesLoadRequested(tripId: tripId)),
      child: _ExpensesView(tripId: tripId, budget: budget),
    );
  }
}

class _ExpensesView extends StatelessWidget {
  final String tripId;
  final double? budget;

  const _ExpensesView({required this.tripId, required this.budget});

  void _openExpenseForm(BuildContext context, {ExpenseEntity? expense}) {
    final bloc = context.read<ExpensesBloc>();

    final currentState = bloc.state;

    if (currentState is! ExpensesLoaded || currentState.isSaving) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: ExpenseForm(tripId: tripId, expense: expense),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ExpenseEntity expense,
  ) async {
    final bloc = context.read<ExpensesBloc>();

    final currentState = bloc.state;

    if (currentState is! ExpensesLoaded || currentState.isSaving) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Expense?'),
          content: Text(
            'Are you sure you want to delete '
            '"${expense.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || shouldDelete != true) {
      return;
    }

    final latestState = bloc.state;

    if (latestState is! ExpensesLoaded || latestState.isSaving) {
      return;
    }

    bloc.add(ExpenseDeleteRequested(tripId: tripId, expenseId: expense.id));
  }

  Future<void> _refreshExpenses(BuildContext context) async {
    final bloc = context.read<ExpensesBloc>();

    final currentState = bloc.state;

    if (currentState is ExpensesLoaded && currentState.isSaving) {
      return;
    }

    bloc.add(ExpensesLoadRequested(tripId: tripId));

    await bloc.stream.firstWhere(
      (state) => state is ExpensesLoaded || state is ExpensesFailure,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Expenses')),

      // ADD EXPENSE BUTTON
      floatingActionButton: BlocBuilder<ExpensesBloc, ExpensesState>(
        builder: (context, state) {
          final canAdd = state is ExpensesLoaded && !state.isSaving;

          return FloatingActionButton.extended(
            onPressed: canAdd ? () => _openExpenseForm(context) : null,
            icon: const Icon(Icons.add),
            label: const Text('Add Expense'),
          );
        },
      ),

      // MAIN CONTENT
      body: BlocConsumer<ExpensesBloc, ExpensesState>(
        listenWhen: (previous, current) {
          if (current is! ExpensesLoaded || current.operationError == null) {
            return false;
          }

          if (previous is ExpensesLoaded) {
            return previous.operationError != current.operationError;
          }

          return true;
        },

        listener: (context, state) {
          if (state is ExpensesLoaded && state.operationError != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.operationError!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },

        builder: (context, state) {
          // INITIAL LOADING
          if (state is ExpensesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // INITIAL LOAD ERROR
          if (state is ExpensesFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<ExpensesBloc>().add(
                          ExpensesLoadRequested(tripId: tripId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // EXPENSE LIST
          if (state is ExpensesLoaded) {
            final expenses = state.expenses;
            final isSaving = state.isSaving;

            return RefreshIndicator(
              onRefresh: () => _refreshExpenses(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  // BUDGET SUMMARY
                  ExpenseSummaryCard(budget: budget, expenses: expenses),

                  const SizedBox(height: 24),

                  // EXPENSE HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expenses',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${expenses.length} items',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // EMPTY STATE
                  if (expenses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 56),
                          SizedBox(height: 12),
                          Text('No expenses added yet'),
                          SizedBox(height: 6),
                          Text(
                            'Tap Add Expense to track '
                            'your trip spending.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...expenses.map(
                      (expense) => IgnorePointer(
                        ignoring: isSaving,
                        child: Opacity(
                          opacity: isSaving ? 0.6 : 1.0,
                          child: ExpenseListItem(
                            expense: expense,
                            onEdit: () =>
                                _openExpenseForm(context, expense: expense),
                            onDelete: () => _confirmDelete(context, expense),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
