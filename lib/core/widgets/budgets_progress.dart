import 'package:expense_tracker/core/router/app.routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/preferences_provider.dart';
import 'package:expense_tracker/providers/month_provider.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class BudgetProgress extends ConsumerWidget {
  final List<Expense> allExpenses;

  const BudgetProgress({super.key, required this.allExpenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final budget = ref.watch(monthlyBudgetProvider);
    final currentMonth = ref.watch(monthProvider);

    if (budget <= 0) {
      return _SetBudgetPrompt();
    }

    final monthlyExpenses = allExpenses.where((e) {
      return e.date.year == currentMonth.year && e.date.month == currentMonth.month;
    }).toList();

    final totalSpent = monthlyExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final progress = (totalSpent / budget).clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(0);

    Color progressColor;
    String statusText;
    if (progress < 0.7) {
      progressColor = Colors.green;
      statusText = l10n.onTrack;
    } else if (progress < 0.9) {
      progressColor = Colors.orange;
      statusText = l10n.gettingClose;
    } else {
      progressColor = Colors.red;
      statusText = progress >= 1.0 ? l10n.budgetExceeded : l10n.almostAtLimit;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.monthlyBudget, style: theme.textTheme.titleLarge),
              Text(
                statusText,
                style: theme.textTheme.bodySmall?.copyWith(color: progressColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${totalSpent.toStringAsFixed(3)} DT ${l10n.spent}',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                l10n.ofBudget(percentage, budget.toStringAsFixed(3)),
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SetBudgetPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
      ),
      child: Row(
        children: [
          Icon(Icons.savings_outlined, color: theme.colorScheme.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.setMonthlyBudget, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l10n.trackSpendingLimits, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}