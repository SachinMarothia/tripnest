
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.tripId,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
    super.note,
  });

  factory ExpenseModel.fromMap(
      Map<String, dynamic> map,
      String id,
      String tripId,
      ) {
    return ExpenseModel(
      id: id,
      tripId: tripId,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'] as String?,
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity expense) {
    return ExpenseModel(
      id: expense.id,
      tripId: expense.tripId,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
      note: expense.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }
}
