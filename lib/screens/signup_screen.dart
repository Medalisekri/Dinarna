import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/core/helpers/auth_error.dart';
import 'package:expense_tracker/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).signup(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue<void>>(authProvider, (previous, next) {
      next.whenOrNull(
          error: (error, stack) {
            setState(() => _generalError = getSignUpErrorMessage(error.toString()));
          },
          data: (_) {
            if (_generalError != null) setState(() => _generalError = null);
          }
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withAlpha(50),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create Account', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Start tracking your expenses today', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
                    const SizedBox(height: 40),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Email is required';
                        if (!_isValidEmail(val)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Password is required';
                        if (val.length < 6) return 'Must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      validator: (val) {
                        if (val != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    if (_generalError != null) ...[
                      Text(_generalError!, style: TextStyle(color: theme.colorScheme.error, fontSize: 14)),
                      const SizedBox(height: 16),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : _signUp,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: theme.textTheme.bodyMedium),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text('Login', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}