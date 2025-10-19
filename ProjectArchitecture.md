# Digital Library Mobile App - Architecture Documentation

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point with Provider setup
├── constants/
│   ├── app_colors.dart           # Color theme constants
│   └── app_strings.dart          # Localization strings (EN/ID)
├── models/
│   ├── book_model.dart           # Book data model
│   └── transaction_model.dart    # Transaction data model
├── providers/
│   ├── language_provider.dart    # Language state management
│   └── transaction_provider.dart # Business logic & state
├── services/
│   └── api_service.dart          # API communication (WiFi)
├── screens/
│   ├── home_screen.dart          # Main navigation screen
│   ├── borrow_screen.dart        # Borrow book screen
│   ├── return_screen.dart        # Return book screen
│   ├── add_book_screen.dart      # Add new book screen
│   └── qr_scanner_screen.dart    # QR code scanner
├── widgets/
│   ├── custom_text_field.dart    # Reusable text input
│   ├── book_id_display.dart      # Book ID display widget
│   ├── submit_button.dart        # Submit button with loading
│   └── scan_button.dart          # QR scan button
└── l10n/
    └── app_localizations.dart    # Localization delegate
```

## 🏗️ Architecture Patterns

### **1. State Management: Provider Pattern**

We use **Provider** (officially recommended by Flutter team) for state management:

- **LanguageProvider**: Manages app language (EN/ID) with persistence
- **TransactionProvider**: Handles all business logic for borrow/return/add operations

**Benefits:**
- ✅ Simple and intuitive
- ✅ Minimal boilerplate
- ✅ Good separation of concerns
- ✅ Easy to test
- ✅ Reactive UI updates

### **2. Clean Architecture Principles**

**Layers:**
1. **Presentation Layer** (Screens & Widgets): UI components
2. **Business Logic Layer** (Providers): State management & logic
3. **Data Layer** (Models & Services): Data structures & API calls

**Key Principles Applied:**
- **Single Responsibility**: Each file has one clear purpose
- **Dependency Injection**: Providers injected via MultiProvider
- **Separation of Concerns**: UI separated from business logic
- **Reusability**: Custom widgets for common UI patterns

### **3. Component Structure**

#### **Screens (Smart Components)**
- Connected to Providers via Consumer/Provider.of
- Handle navigation and user interactions
- Contain business logic calls
- Manage local UI state (TextEditingControllers)

#### **Widgets (Dumb Components)**
- Receive data via parameters
- No direct Provider access
- Pure presentation components
- Highly reusable across screens

## 🎨 Design Patterns Used

### **1. Repository Pattern** (API Service)
```dart
// Centralized API communication
class ApiService {
  Future<void> sendTransaction(Map<String, dynamic> data) {...}
  Future<void> sendBook(Map<String, dynamic> data) {...}
}
```

### **2. Factory Pattern** (Models)
```dart
// Easy object creation from different sources
factory TransactionModel.borrowTransaction({...}) {...}
factory TransactionModel.returnTransaction({...}) {...}
```

### **3. Observer Pattern** (Provider)
```dart
// Automatic UI updates when state changes
class TransactionProvider with ChangeNotifier {
  void setScannedBookId(String? bookId) {
    _scannedBookId = bookId;
    notifyListeners(); // Updates all listeners
  }
}
```

## 📊 Data Flow

### **Borrow Flow:**
```
User Input → BorrowScreen → TransactionProvider.processBorrow()
→ Create TransactionModel → Log to Console → (Optional: ApiService)
→ Update UI State → Clear Form
```

### **Return Flow:**
```
QR Scan → ReturnScreen → TransactionProvider.processReturn()
→ Create TransactionModel → Log to Console → (Optional: ApiService)
→ Update UI State
```

### **Add Book Flow:**
```
User Input + QR Scan → AddBookScreen → TransactionProvider.addBook()
→ Create BookModel → Log to Console → (Optional: ApiService)
→ Update UI State → Clear Form
```

## 🌍 Internationalization (i18n)

### **Implementation:**
1. **String Constants** in `app_strings.dart`
2. **AppLocalizations** delegate for runtime translation
3. **LanguageProvider** for state persistence
4. **Consumer** pattern for reactive language switching

### **Adding New Translations:**
```dart
// 1. Add to app_strings.dart
static const Map<String, String> en = {
  'new_key': 'English text',
};

static const Map<String, String> id = {
  'new_key': 'Teks Indonesia',
};

// 2. Add getter in app_localizations.dart
String get newKey => translate('new_key');

// 3. Use in widgets
Text(localizations.newKey)
```

## 🔧 Key Features

### **1. Offline-First Architecture**
- All operations work without WiFi
- Data logged to console immediately
- Optional server sync (commented out)
- SharedPreferences for persistence

### **2. Type Safety**
- Strong typing with Dart models
- Enum for transaction types
- Null safety throughout

### **3. Error Handling**
- Try-catch in all async operations
- Error state in providers
- User-friendly error messages

### **4. Loading States**
- `isLoading` flag in TransactionProvider
- Loading indicator on submit buttons
- Prevents double submissions

## 🚀 Setup & Installation

### **1. Install Dependencies**
```bash
flutter pub get
```

### **2. Android Setup**
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### **3. iOS Setup**
Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera permission for QR scanning</string>
```

### **4. Run the App**
```bash
flutter run
```

## 📡 Enabling WiFi Communication

### **Step 1: Uncomment HTTP Import**
```dart
// In api_service.dart
import 'package:http/http.dart' as http;
```

### **Step 2: Uncomment API Methods**
```dart
// In ApiService class - uncomment these methods:
Future<void> sendTransaction(Map<String, dynamic> data) {...}
Future<void> sendBook(Map<String, dynamic> data) {...}
```

### **Step 3: Uncomment Provider Calls**
```dart
// In TransactionProvider - uncomment:
await _apiService.sendTransaction(transaction.toJson());
await _apiService.sendBook(book.toJson());
```

### **Step 4: Configure Server URL**
```dart
// Default: http://192.168.1.100:5000
// Update in ApiService or add settings screen
```

### **Expected Server Endpoints:**
- `POST /api/transaction` - For borrow/return
- `POST /api/book` - For adding books

## 🧪 Testing Strategy

### **Unit Tests:**
```dart
// Test providers
test('processBorrow creates correct transaction', () {
  final provider = TransactionProvider();
  // Test logic
});
```

### **Widget Tests:**
```dart
// Test UI components
testWidgets('BorrowScreen displays form', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.byType(TextField), findsNWidgets(2));
});
```

### **Integration Tests:**
```dart
// Test full flows
testWidgets('Complete borrow flow', (tester) async {
  // Simulate user journey
});
```

## 📈 Scalability Considerations

### **Current Architecture Supports:**
- ✅ Multiple screens/features easily added
- ✅ Additional providers for new domains
- ✅ New widgets without touching screens
- ✅ Database migration (add repository layer)
- ✅ Backend changes (only update ApiService)

### **Future Enhancements:**
1. **Local Database**: SQLite via sqflite package
2. **Offline Queue**: Queue failed API calls
3. **User Authentication**: Add auth provider
4. **Search Feature**: Add search provider & screen
5. **Analytics**: Add analytics service

## 🎯 Best Practices Implemented

✅ **Code Organization**: Clear folder structure
✅ **Naming Conventions**: Consistent, descriptive names  
✅ **Documentation**: Inline comments where needed
✅ **Error Handling**: Comprehensive error management
✅ **State Management**: Proper use of Provider
✅ **Reusability**: DRY principle with custom widgets
✅ **Type Safety**: Strong typing, null safety
✅ **Responsiveness**: SingleChildScrollView for all screens
✅ **UX**: Loading states, user feedback
✅ **Accessibility**: Semantic labels, proper contrast

## 📝 Console Output Examples

### Borrow Transaction:
```json
=== BORROW DATA PACKET ===
{
  "action": "borrow",
  "student_name": "Ahmad Rizki",
  "student_grade": "5A",
  "book_id": "BOOK-001",
  "borrow_date": "2025-10-11T10:30:00.000Z",
  "due_date": "2025-10-25T10:30:00.000Z"
}
==========================
```

### Return Transaction:
```json
=== RETURN DATA PACKET ===
{
  "action": "return",
  "book_id": "BOOK-001",
  "return_date": "2025-10-11T10:30:00.000Z"
}
==========================
```

### Add Book:
```json
=== ADD BOOK DATA PACKET ===
{
  "action": "add_book",
  "book_id": "BOOK-123",
  "title": "Laskar Pelangi",
  "author": "Andrea Hirata",
  "isbn": "9789793062792",
  "category": "Fiction",
  "added_date": "2025-10-11T10:30:00.000Z"
}
============================
```

## 🔐 Security Considerations

- ✅ Input validation before processing
- ✅ No sensitive data in logs (production)
- ✅ HTTPS recommended for production API
- ✅ Consider authentication for WiFi endpoint
- ✅ Sanitize user inputs before sending to server

## 📞 Support & Maintenance

### **Common Issues:**
1. **QR Scanner not working**: Check camera permissions
2. **Language not persisting**: Check SharedPreferences permissions
3. **WiFi not connecting**: Verify server URL and network

### **Debugging:**
```bash
# View console logs
flutter logs

# Check for errors
flutter analyze

# Profile performance
flutter run --profile
```

---

**Built with ❤️ following Flutter & Dart best practices**