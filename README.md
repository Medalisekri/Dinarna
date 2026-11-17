# 💸 GlassVault — Expense Tracker

> A production-ready personal finance app built with Flutter and Firebase. Track daily expenses, set monthly budgets, visualize spending patterns, and export professional PDF reports — with full English and Tunisian Arabic support.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/Riverpod-00BCD4?style=for-the-badge&logo=flutter&logoColor=white)
![GoRouter](https://img.shields.io/badge/GoRouter-4285F4?style=for-the-badge&logo=google&logoColor=white)

---

## Screenshots

| Login | Home | Add Expense |
|---|---|---|
| <img width="200" height="400" alt="Login" src="https://github.com/user-attachments/assets/dfa3c624-ecca-46c6-ba4e-5a24b19905dc" /> | <img width="200" height="400" alt="Home" src="https://github.com/user-attachments/assets/91b36029-9d7d-4e28-9a7c-966720c63c84" /> | <img width="200" height="400" alt="Add Expense" src="https://github.com/user-attachments/assets/e251da67-ece6-44ab-80f5-def0e08ac31b" /> |

| Budget & Chart | Settings | Arabic (RTL) |
|---|---|---|
| *Coming soon* | *Coming soon* | *Coming soon* |

---

## ✨ Features

### Core
| Feature | Description |
|---|---|
| 🔐 Authentication | Email/password login, Google Sign-In, password reset, account deletion |
| ➕ Add Expenses | Form with category, amount, date picker, and optional note |
| ✏️ Edit & Delete | Tap to edit, swipe-to-delete with confirmation dialog |
| 🔄 Real-time Sync | Firestore streams — changes appear instantly across devices |
| 🏷️ Category Filter | Filter by Food, Transport, Shopping, Health, Other |
| 📅 Monthly Navigation | Browse expenses month by month with arrow navigation |
| 📊 Total Summary | Animated counting total for the selected month/category |

### Analytics & Insights
| Feature | Description |
|---|---|
| 🥧 Spending Chart | Interactive pie chart showing category breakdown (`fl_chart`) |
| 💰 Budget Tracking | Set a monthly budget, get color-coded progress (green → orange → red) |
| 📄 PDF Export | Generate professional monthly reports with category breakdown and transaction table |
| 🌍 Arabic PDF Support | Full RTL rendering with Cairo font for Arabic reports |

### UI / UX
| Feature | Description |
|---|---|
| 🎨 Dark & Light Themes | System-aware themes with centralized color palette |
| 🌐 Localization | English + Tunisian Arabic dialect with full RTL layout support |
| 💀 Skeleton Loaders | Shimmer placeholders while data loads |
| 🎯 Empty States | Friendly illustrations and guidance when no data exists |
| 🔢 Animated Totals | Numbers count up smoothly on screen load |
| 🧊 Selective Glassmorphism | Frosted glass effects applied only where they add value |
| 📱 Responsive Layout | Horizontal scrolling filters, adaptive padding, tablet-friendly |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| State Management | Riverpod (`StreamNotifier` + `AsyncNotifier`) |
| Navigation | GoRouter (with auth-aware redirects) |
| Local Storage | SharedPreferences (settings, budget, onboarding flags) |
| Charts | fl_chart |
| PDF Generation | pdf + printing |
| Localization | Flutter `gen-l10n` (ARB files) |
| Loading States | shimmer |

---

## 🏗️ Architecture

The app follows a clean three-layer architecture — **screens never touch Firebase directly**.

```
lib/
├── core/
│   ├── assets/
│       ├── fonts/                    # Google Arabic fonts
│           ├── Cairo-Bold.ttf
│           ├── Cairo-Regular.ttf 
│       ├── images/                   # App Logo
│           ├── logo.png
│   ├── helpers/                      # Helpers Methods
│         ├── auth_error.dart 
│         ├── category_helper.dart 
│   ├── router/
│   │   ├── app.routes.dart           # Route constants
│   │   └── app_router.dart           # GoRouter + auth redirect logic
│   ├── services/
│   │   └── pdf_service.dart          # PDF generation with Arabic font support 
│   ├── theme/
│   │   └── app_theme.dart            # Centralized light/dark themes + category colors 
│   └── widgets/                        
│       ├── skeleton_loader.dart      # Shimmer loading placeholders
│       ├── spending_chart.dart       # Pie chart widget
│       └── budgets_progress.dart     # Budget progress bar
├── l10n/
│   ├── app_en.arb                    # English strings
│   └── app_ar.arb                    # Tunisian Arabic strings
├── models/
│   └── expense.dart                  # Data class with fromFirestore / toMap / copyWith
├── repositories/
│   ├── expense_repository.dart       # All Firestore calls
│   └── auth_repository.dart          # All Firebase Auth calls
├── providers/
│   ├── expense_provider.dart         # StreamNotifier — real-time expense list
│   ├── auth_provider.dart            # AsyncNotifier — login/signup actions
│   ├── preferences_provider.dart     # Budget, theme, language persistence
│   └── month_provider.dart           # Selected month navigation
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── add_expenses_screen.dart
│   ├── settings_screen.dart
│   ├── onboarding_screen.dart
│   └── language_selection.dart
└── firebase_options.dart
└── main.dart
```

### State Management Pattern

```
UI Screen
    ↓ ref.watch / ref.read
Provider (StreamNotifier / AsyncNotifier)
    ↓
Repository
    ↓
Firebase (Auth / Firestore)
```

- **`StreamNotifier`** — for real-time data (expense list via Firestore snapshots)
- **`AsyncNotifier`** — for one-time actions (login, signup, password reset)
- **`StateNotifier`** — for simple local state (budget, theme, month selection)

The UI layer only calls `ref.read(expenseListProvider.notifier).addExpense(...)` — it never imports Firestore directly. This separation makes the code easier to read, debug, test, and scale.

---

## 🚀 Getting Started

**Prerequisites:** Flutter SDK, a Firebase project

### 1. Clone the repo
```bash
git clone https://github.com/yourusername/expense-tracker.git
cd expense-tracker
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Firebase setup
- Create a project at [console.firebase.google.com](https://console.firebase.google.com)
- Enable **Email/Password** and **Google** authentication
- Create a **Firestore** database
- Run `flutterfire configure` to generate `firebase_options.dart`
- Add your **SHA-1 fingerprint** for Google Sign-In (Project Settings → Your app)
- Download the updated `google-services.json` into `android/app/`

### 4. Firestore security rules
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /expenses/{expenseId} {
      // Read, update, delete: only the owner
      allow read, update, delete: if request.auth != null
        && request.auth.uid == resource.data.userId;
      
      // Create: userId must match the authenticated user
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### 5. Add Arabic fonts (for PDF export)
- Download **Cairo** from [Google Fonts](https://fonts.google.com/specimen/Cairo)
- Copy `Cairo-Regular.ttf` and `Cairo-Bold.ttf` from the `static/` folder
- Place them in `assets/fonts/`
- Ensure they're registered in `pubspec.yaml`

### 6. Generate localization files
```bash
flutter gen-l10n
```

### 7. Generate splash screen & app icon
```bash
dart run flutter_native_splash:create
dart run flutter_launcher_icons
```

### 8. Run the app
```bash
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.x.x
  go_router: ^14.x.x
  firebase_core: ^x.x.x
  firebase_auth: ^x.x.x
  cloud_firestore: ^x.x.x
  google_sign_in: ^6.x.x
  fl_chart: ^0.66.x
  pdf: ^3.x.x
  printing: ^5.x.x
  shared_preferences: ^2.x.x
  shimmer: ^3.x.x
  flutter_localizations:
    sdk: flutter
  intl: any

dev_dependencies:
  flutter_native_splash: ^2.x.x
  flutter_launcher_icons: ^0.13.x
```

> Replace `x.x.x` with the actual versions in your `pubspec.yaml`

---

## 🌍 Localization

The app supports **English** and **Tunisian Arabic** (written in Arabic script with Tunisian dialect expressions).

- All UI strings are stored in ARB files (`lib/l10n/`)
- Language can be switched in Settings or during first-launch onboarding
- Arabic automatically flips the entire layout to **RTL**
- PDF reports support Arabic via embedded Cairo font

**Adding a new language:**
1. Create `lib/l10n/app_fr.arb` (for example)
2. Translate the keys
3. Add `Locale('fr')` to `supportedLocales` in `main.dart`
4. Run `flutter gen-l10n`

---

## 🎨 Theming

All colors and component styles are centralized in `core/theme/app_theme.dart`:

- **Light theme** and **Dark theme** defined in one file
- Category colors and icons mapped via `AppTheme.getCategoryColor()` / `getCategoryIcon()`
- User preference persisted via SharedPreferences
- Follows system theme by default

---

## 📄 PDF Export

The app generates professional monthly reports including:

- Monthly summary (total spent, transaction count, budget, remaining)
- Category breakdown with visual progress bars
- Full transaction table (date, category, note, amount)
- **Arabic support** via embedded Cairo font (regular + bold)
- RTL text direction for Arabic reports

> **Note:** Use the **static** `.ttf` files from Google Fonts, not variable fonts — the `pdf` package requires static fonts for proper Arabic shaping.

---

## 🧠 What I Learned

- **Clean Architecture** — Repository → Provider → UI separation for maintainability
- **Riverpod 2.x** — `StreamNotifier` for real-time data vs `AsyncNotifier` for one-time actions
- **GoRouter** — Auth-aware redirects with `refreshListenable`, route constants, `state.extra`
- **Firestore Security Rules** — Per-user access control, separating `create` from `read/update/delete`
- **Offline-first thinking** — Leveraging Firestore's native persistence instead of building custom sync
- **Localization** — ARB files, `gen-l10n`, RTL layouts, Tunisian dialect translation
- **PDF Generation** — Custom fonts, Arabic shaping, RTL rendering, multi-page documents
- **State persistence** — SharedPreferences for settings vs Firestore for user data
- **Play Store compliance** — In-app account deletion, privacy policy requirements, release builds
- **Responsive UI** — Handling small screens, large text settings, tablets without overflow

---
