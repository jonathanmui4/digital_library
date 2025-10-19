import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../widgets/book_id_display.dart';
import '../widgets/submit_button.dart';
import '../widgets/scan_button.dart';
import 'qr_scanner_screen.dart';

class ReturnScreen extends StatelessWidget {
  const ReturnScreen({Key? key}) : super(key: key);

  Future<void> _scanQRCode(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (result != null && context.mounted) {
      context.read<TransactionProvider>().setScannedBookId(result);
    }
  }

  Future<void> _submitReturn(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final provider = context.read<TransactionProvider>();

    if (provider.scannedBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.scanBook),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.processReturn(
      bookId: provider.scannedBookId!,
    );

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${localizations.success}! ${localizations.loggedConsole}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.error}: ${provider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              ScanButton(
                onPressed: () => _scanQRCode(context),
                label: localizations.scanQr,
              ),
              if (provider.scannedBookId != null) ...[
                const SizedBox(height: 24),
                BookIdDisplay(
                  bookId: provider.scannedBookId!,
                  label: localizations.bookId,
                ),
                const SizedBox(height: 24),
                SubmitButton(
                  onPressed: () => _submitReturn(context),
                  label: localizations.submit,
                  isLoading: provider.isLoading,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
