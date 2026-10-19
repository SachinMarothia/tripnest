
import '../repositories/expenses_repository.dart';

class DeleteExpense {
  final ExpensesRepository repository;

  const DeleteExpense(this.repository);

  Future<void> call({
    required String tripId,
    required String expenseId,
  }) {
    if (tripId.trim().isEmpty || expenseId.trim().isEmpty) {
      throw ArgumentError('Trip ID and Expense ID are required');
    }

    return repository.deleteExpense(
      tripId: tripId,
      expenseId: expenseId,
    );
  }
}
