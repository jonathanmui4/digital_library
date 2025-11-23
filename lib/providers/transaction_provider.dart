import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/book_model.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  String? _scannedBookId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get scannedBookId => _scannedBookId;

  void setScannedBookId(String? bookId) {
    _scannedBookId = bookId;
    notifyListeners();
  }

  void clearScannedBookId() {
    _scannedBookId = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> processBorrow({
    required String studentName,
    required String studentGrade,
    required String bookId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final transaction = TransactionModel.borrowTransaction(
        bookId: bookId,
        studentName: studentName,
        studentGrade: studentGrade,
      );

      // Log to console
      print('=== BORROW DATA PACKET ===');
      print(jsonEncode(transaction.toJson()));
      print('==========================');

      // Commented out: Send to server
      await _apiService.sendTransaction(transaction.toJson());

      _isLoading = false;
      _scannedBookId = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> processReturn({
    required String bookId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final transaction = TransactionModel.returnTransaction(
        bookId: bookId,
      );

      // Log to console
      print('=== RETURN DATA PACKET ===');
      print(jsonEncode(transaction.toJson()));
      print('==========================');

      // Commented out: Send to server
      await _apiService.sendTransaction(transaction.toJson());

      _isLoading = false;
      _scannedBookId = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addBook({
    required String bookId,
    required String title,
    required String author,
    String? isbn,
    String? category,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final book = BookModel(
        bookId: bookId,
        title: title,
        author: author,
        isbn: isbn,
        category: category,
        addedDate: DateTime.now(),
      );

      // Log to console
      print('=== ADD BOOK DATA PACKET ===');
      print(jsonEncode(book.toJson()));
      print('============================');

      // Commented out: Send to server
      await _apiService.sendBook(book.toJson());

      _isLoading = false;
      _scannedBookId = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
