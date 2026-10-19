
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../datasources/expenses_remote_data_source.dart';
import '../model/expense_model.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesRemoteDataSource remoteDataSource;

  const ExpensesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<ExpenseEntity>> getExpenses(String tripId) async {
    return await remoteDataSource.getExpenses(tripId);
  }

  @override
  Future<ExpenseEntity> addExpense(ExpenseEntity expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);

    return await remoteDataSource.addExpense(expenseModel);
  }

  @override
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);

    return await remoteDataSource.updateExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense({
    required String tripId,
    required String expenseId,
  }) async {
    await remoteDataSource.deleteExpense(
      tripId: tripId,
      expenseId: expenseId,
    );
  }
}
