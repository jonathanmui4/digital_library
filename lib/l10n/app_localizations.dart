import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(String key) {
    final translations = locale == 'id' ? AppStrings.id : AppStrings.en;
    return translations[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get borrow => translate('borrow');
  String get returnBook => translate('return');
  String get addBook => translate('add_book');
  String get studentName => translate('student_name');
  String get studentGrade => translate('student_grade');
  String get bookTitle => translate('book_title');
  String get author => translate('author');
  String get isbn => translate('isbn');
  String get category => translate('category');
  String get scanQr => translate('scan_qr');
  String get submit => translate('submit');
  String get success => translate('success');
  String get error => translate('error');
  String get enterDetails => translate('enter_details');
  String get scanBook => translate('scan_book');
  String get bookId => translate('book_id');
  String get loggedConsole => translate('logged_console');
  String get scanSuccessful => translate('scan_successful');
  String get scannedCode => translate('scanned_code');
  String get scanAgain => translate('scan_again');
  String get confirm => translate('confirm');
  String get settings => translate('settings');
  String get serverSettings => translate('server_settings');
  String get serverIpAddress => translate('server_ip_address');
  String get save => translate('save');
  String get settingsSaved => translate('settings_saved');
  String get invalidIp => translate('invalid_ip');
  String get connectionError => translate('connection_error');
  String get connectionErrorMessage => translate('connection_error_message');
  String get goToSettings => translate('go_to_settings');
  String get tryAgain => translate('try_again');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale.languageCode);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
