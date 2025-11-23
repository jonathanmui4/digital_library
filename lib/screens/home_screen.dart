import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import 'borrow_screen.dart';
import 'return_screen.dart';
import 'add_book_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BorrowScreen(),
      const ReturnScreen(),
      const AddBookScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: localizations.settings,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (languageCode) {
              languageProvider.changeLanguage(languageCode);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'id',
                child: Row(
                  children: [
                    if (languageProvider.locale.languageCode == 'id')
                      const Icon(Icons.check, color: AppColors.primary),
                    if (languageProvider.locale.languageCode == 'id')
                      const SizedBox(width: 8),
                    const Text('Bahasa Indonesia'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    if (languageProvider.locale.languageCode == 'en')
                      const Icon(Icons.check, color: AppColors.primary),
                    if (languageProvider.locale.languageCode == 'en')
                      const SizedBox(width: 8),
                    const Text('English'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.dark.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: localizations.borrow,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_return),
            label: localizations.returnBook,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_box),
            label: localizations.addBook,
          ),
        ],
      ),
    );
  }
}
