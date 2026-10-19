
class ExpenseEntity {
  final String id;
  final String tripId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  const ExpenseEntity({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });
}
