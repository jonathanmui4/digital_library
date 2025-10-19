enum TransactionType { borrow, return_ }

class TransactionModel {
  final TransactionType type;
  final String bookId;
  final String? studentName;
  final String? studentGrade;
  final DateTime transactionDate;
  final DateTime? dueDate;

  TransactionModel({
    required this.type,
    required this.bookId,
    this.studentName,
    this.studentGrade,
    required this.transactionDate,
    this.dueDate,
  });

  Map<String, dynamic> toJson() {
    if (type == TransactionType.borrow) {
      return {
        'action': 'borrow',
        'student_name': studentName,
        'student_grade': studentGrade,
        'book_id': bookId,
        'borrow_date': transactionDate.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
      };
    } else {
      return {
        'action': 'return',
        'book_id': bookId,
        'return_date': transactionDate.toIso8601String(),
      };
    }
  }

  factory TransactionModel.borrowTransaction({
    required String bookId,
    required String studentName,
    required String studentGrade,
    DateTime? borrowDate,
    int dueDays = 14,
  }) {
    final borrow = borrowDate ?? DateTime.now();
    return TransactionModel(
      type: TransactionType.borrow,
      bookId: bookId,
      studentName: studentName,
      studentGrade: studentGrade,
      transactionDate: borrow,
      dueDate: borrow.add(Duration(days: dueDays)),
    );
  }

  factory TransactionModel.returnTransaction({
    required String bookId,
    DateTime? returnDate,
  }) {
    return TransactionModel(
      type: TransactionType.return_,
      bookId: bookId,
      transactionDate: returnDate ?? DateTime.now(),
    );
  }
}
