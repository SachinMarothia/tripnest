
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/expense_model.dart';

class ExpensesRemoteDataSource {
  final FirebaseFirestore firestore;

  const ExpensesRemoteDataSource({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> _expensesCollection(
      String tripId,
      ) {
    return firestore
        .collection('trips')
        .doc(tripId)
        .collection('expenses');
  }

  // GET ALL EXPENSES FOR A TRIP
  Future<List<ExpenseModel>> getExpenses(String tripId) async {
    final snapshot = await _expensesCollection(tripId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((document) {
      return ExpenseModel.fromMap(
        document.data(),
        document.id,
        tripId,
      );
    }).toList();
  }

  // ADD EXPENSE
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    final document = _expensesCollection(expense.tripId).doc();

    await document.set(expense.toMap());

    return ExpenseModel(
      id: document.id,
      tripId: expense.tripId,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
      note: expense.note,
    );
  }

  // UPDATE EXPENSE
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    await _expensesCollection(expense.tripId)
        .doc(expense.id)
        .update(expense.toMap());

    return expense;
  }

  // DELETE EXPENSE
  Future<void> deleteExpense({
    required String tripId,
    required String expenseId,
  }) async {
    await _expensesCollection(tripId)
        .doc(expenseId)
        .delete();
  }
}
