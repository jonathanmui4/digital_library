import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/book_id_display.dart';
import '../widgets/submit_button.dart';
import '../widgets/scan_button.dart';
import 'qr_scanner_screen.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({Key? key}) : super(key: key);

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  Future<void> _scanQRCode() async {
    // Clear previous scan before opening scanner
    context.read<TransactionProvider>().clearScannedBookId();

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (result != null && mounted) {
      context.read<TransactionProvider>().setScannedBookId(result);
    }
  }

  Future<void> _submitBorrow() async {
    final localizations = AppLocalizations.of(context);
    final provider = context.read<TransactionProvider>();

    if (_nameController.text.isEmpty ||
        _gradeController.text.isEmpty ||
        provider.scannedBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.enterDetails),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.processBorrow(
      studentName: _nameController.text,
      studentGrade: _gradeController.text,
      bookId: provider.scannedBookId!,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${localizations.success}! ${localizations.loggedConsole}'),
            backgroundColor: Colors.green,
          ),
        );
        _nameController.clear();
        _gradeController.clear();
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
              CustomTextField(
                controller: _nameController,
                label: localizations.studentName,
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _gradeController,
                label: localizations.studentGrade,
                icon: Icons.school,
              ),
              const SizedBox(height: 24),
              ScanButton(
                onPressed: _scanQRCode,
                label: localizations.scanQr,
              ),
              if (provider.scannedBookId != null) ...[
                const SizedBox(height: 16),
                BookIdDisplay(
                  bookId: provider.scannedBookId!,
                  label: localizations.bookId,
                ),
              ],
              const SizedBox(height: 24),
              SubmitButton(
                onPressed: _submitBorrow,
                label: localizations.submit,
                isLoading: provider.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
