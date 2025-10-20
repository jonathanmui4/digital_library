import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _defaultServerUrl = 'http://10.0.2.2:80';

  Future<String> _getServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('server_url') ?? _defaultServerUrl;
  }

  Future<void> setServerUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_url', url);
  }

  // Commented out: WiFi communication code
  Future<void> sendTransaction(Map<String, dynamic> data) async {
    try {
      final serverUrl = await _getServerUrl();
      final response = await http.post(
        Uri.parse('$serverUrl/api/transaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending transaction to server: $e');
      rethrow;
    }
  }

  Future<void> sendBook(Map<String, dynamic> data) async {
    try {
      final serverUrl = await _getServerUrl();
      final response = await http.post(
        Uri.parse('$serverUrl/api/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending book to server: $e');
      rethrow;
    }
  }
}
