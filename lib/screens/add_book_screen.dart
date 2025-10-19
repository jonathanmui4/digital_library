import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/book_id_display.dart';
import '../widgets/submit_button.dart';
import '../widgets/scan_button.dart';
import 'qr_scanner_screen.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _categoryController.dispose();
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

  Future<void> _submitAddBook() async {
    final localizations = AppLocalizations.of(context);
    final provider = context.read<TransactionProvider>();

    if (_titleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        provider.scannedBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.enterDetails),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.addBook(
      bookId: provider.scannedBookId!,
      title: _titleController.text,
      author: _authorController.text,
      isbn: _isbnController.text.isEmpty ? null : _isbnController.text,
      category:
          _categoryController.text.isEmpty ? null : _categoryController.text,
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
        _titleController.clear();
        _authorController.clear();
        _isbnController.clear();
        _categoryController.clear();
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
                controller: _titleController,
                label: localizations.bookTitle,
                icon: Icons.menu_book,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _authorController,
                label: localizations.author,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _isbnController,
                label: localizations.isbn,
                icon: Icons.numbers,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _categoryController,
                label: localizations.category,
                icon: Icons.category,
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
                onPressed: _submitAddBook,
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
