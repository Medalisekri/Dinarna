import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/providers/preferences_provider.dart';
import 'package:expense_tracker/core/router/app.routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      TextSpan(text: 'Dinar', style: TextStyle(color: theme.colorScheme.onSurface)),
                      TextSpan(text: 'na', style: TextStyle(color: theme.colorScheme.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your language',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 48),

                _LanguageCard(
                  title: 'English',
                  subtitle: 'English',
                  flag: '🇺🇸',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () async {
                    ref.read(localeProvider.notifier).setLanguage('en');
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('selected_language', true);

                    if (context.mounted) context.go(AppRoutes.onboarding);
                  },
                ),
                const SizedBox(height: 16),
                _LanguageCard(
                  title: 'العربية',
                  subtitle: 'تونسي',
                  flag: '🇹🇳',
                  isSelected: currentLocale.languageCode == 'ar',
                  onTap: () async {
                    ref.read(localeProvider.notifier).setLanguage('ar');
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('selected_language', true);

                    if (context.mounted) context.go(AppRoutes.onboarding);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withAlpha(50)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}