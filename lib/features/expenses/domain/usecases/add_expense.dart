
import '../entities/expense_entity.dart';
import '../repositories/expenses_repository.dart';

class AddExpense {
  final ExpensesRepository repository;

  const AddExpense(this.repository);

  Future<ExpenseEntity> call(ExpenseEntity expense) {
    if (expense.title.trim().isEmpty) {
      throw ArgumentError('Expense title cannot be empty');
    }

    if (!expense.amount.isFinite || expense.amount <= 0) {
      throw ArgumentError('Expense amount must be greater than zero');
    }

    return repository.addExpense(expense);
  }
}
