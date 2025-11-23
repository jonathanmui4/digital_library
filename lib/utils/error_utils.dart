import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../screens/settings_screen.dart';

class ErrorUtils {
  /// Shows a user-friendly connection error dialog with options to
  /// navigate to settings or try again.
  ///
  /// [context] - The build context
  /// [onRetry] - Optional callback when user taps "Try Again"
  static void showConnectionError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(localizations.connectionError),
            ),
          ],
        ),
        content: Text(
          localizations.connectionErrorMessage,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              if (onRetry != null) {
                onRetry();
              }
            },
            child: Text(localizations.tryAgain),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.goToSettings),
          ),
        ],
      ),
    );
  }

  /// Checks if an exception is a connection-related error
  static bool isConnectionError(dynamic error) {
    if (error == null) return false;

    final errorString = error.toString().toLowerCase();

    // Common connection error patterns
    final connectionPatterns = [
      'socket',
      'connection',
      'network',
      'timeout',
      'failed host lookup',
      'unreachable',
      'refused',
      'clientexception',
      'handshake',
      'host unreachable',
      'no address associated',
      'software caused connection abort',
    ];

    for (final pattern in connectionPatterns) {
      if (errorString.contains(pattern)) {
        return true;
      }
    }

    return false;
  }
}
