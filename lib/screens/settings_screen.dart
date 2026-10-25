import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/providers/preferences_provider.dart';

import '../l10n/app_localizations.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _budgetController = TextEditingController();
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    final currentBudget = ref.read(monthlyBudgetProvider);
    if (currentBudget > 0) {
      _budgetController.text = currentBudget.toString();
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    final amount = double.tryParse(_budgetController.text.trim()) ?? 0.0;
    if(_budgetController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a budget'  ,style: TextStyle(color: Colors.red,) ), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    ref.read(monthlyBudgetProvider.notifier).setBudget(amount);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Monthly budget updated' , style: TextStyle(color: Colors.green),), behavior: SnackBarBehavior.floating),
    );
  context.pop();
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This will permanently delete your account and ALL your expense data. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isDeleting = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final expenses = await FirebaseFirestore.instance
              .collection('expenses')
              .where('userId', isEqualTo: user.uid)
              .get();

          for (var doc in expenses.docs) {
            await doc.reference.delete();
          }

          await user.delete();

        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Budget')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Text('Monthly Budget', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set a global monthly spending limit.', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _budgetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount (DT)',
                      prefixIcon: const Icon(Icons.monetization_on_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saveBudget,
                      child: const Text('Save Budget'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),


          Text('Preferences', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Theme'),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeMode,
                    underline: const SizedBox(),
                    onChanged: (mode) {
                      if (mode != null) ref.read(themeModeProvider.notifier).setTheme(mode);
                    },
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    ],
                  ),
                ),
                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.language),
                  trailing: DropdownButton<Locale>(
                    value: ref.watch(localeProvider),
                    underline: const SizedBox(),
                    onChanged: (locale) {
                      if (locale != null) {
                        ref.read(localeProvider.notifier).setLanguage(locale.languageCode);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: Locale('en'), child: Text('English')),
                      DropdownMenuItem(value: Locale('ar'), child: Text('عربي / تونسي')),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),


          Text('Account', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text('Logout'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();

                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Delete Account & Data', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Permanently erase all data'),
                  onTap: _isDeleting ? null : _deleteAccount,
                  trailing: _isDeleting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}