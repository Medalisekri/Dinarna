import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/repositories/auth_repository.dart';

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
  }


  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signInWithEmail(email, password));
  }

  Future<void> signup(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signUpWithEmail(email, password));
  }

  Future<void> googleSignIn() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repo.signInWithGoogle();
      if (result == null) throw Exception('Google sign-in cancelled');
    });
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.sendPasswordResetEmail(email));
  }

  Future<void> logout() async {
    await _repo.signOut();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);