// core/router/app_router.dart
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/expense.dart';
import '../../screens/add_expenses_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import 'app.routes.dart';

class AuthStateNotifier extends ChangeNotifier {
  User? _user = FirebaseAuth.instance.currentUser;
  User? get user => _user;

  AuthStateNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
}

final authStateProvider = Provider<AuthStateNotifier>((ref) {
  return AuthStateNotifier();
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authState,
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final loc = state.matchedLocation;

      final authRoutes = [AppRoutes.login, AppRoutes.signup];
      final isAuthRoute = authRoutes.contains(loc);

      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.addExpense,
        builder: (context, state) => const AddExpensesScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editExpense,
        builder: (context, state) {
          final expense = state.extra as Expense;
          return AddExpensesScreen(expense: expense);
        },
      ),

    ],
  );
});