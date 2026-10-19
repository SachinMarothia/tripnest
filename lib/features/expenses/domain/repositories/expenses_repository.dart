
import '../entities/expense_entity.dart';

abstract class ExpensesRepository {
  Future<List<ExpenseEntity>> getExpenses(String tripId);

  Future<ExpenseEntity> addExpense(ExpenseEntity expense);

  Future<ExpenseEntity> updateExpense(ExpenseEntity expense);

  Future<void> deleteExpense({
    required String tripId,
    required String expenseId,
  });
}
