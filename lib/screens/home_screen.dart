import 'dart:math';

import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/core/widgets/skeleton_loader.dart';

import '../core/router/app.routes.dart';
import '../providers/month_provider.dart';


class CategoryHelper {
  static final List<String> all = [
    'All', 'Food', 'Health', 'Shopping', 'Transport', 'Other',
  ];

  static IconData icon(String category) {
    switch (category.toLowerCase()) {
      case 'food':     return Icons.restaurant_rounded;
      case 'health':   return Icons.favorite_rounded;
      case 'shopping': return Icons.shopping_bag_rounded;
      case 'transport': return Icons.directions_car_rounded;
      default:         return Icons.category_rounded;
    }
  }

  static Color color(String category) {
    switch (category.toLowerCase()) {
      case 'food':     return Colors.orange;
      case 'health':   return Colors.pink;
      case 'shopping': return Colors.purple;
      case 'transport': return Colors.blue;
      default:         return Colors.grey;
    }
  }
}



class HomeScreen extends ConsumerWidget {
  final Expense? expense;
  const HomeScreen({super.key, this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);

    return Scaffold(
      appBar: _buildAppBar(context, ref),
      body: expensesAsync.when(
        loading: () => const SkeletonLoader(),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(expenseListProvider),
        ),
        data: (expenses) {
          if (expenses.isEmpty) return const _EmptyState();
          return _HomeContent(expenses: expenses);
        },
      ),

      floatingActionButton: FloatingActionButton(onPressed: ()=> context.push(AppRoutes.addExpense) , child: Icon(Icons.add),),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'GlassVault',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: Icon(
            Icons.logout_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}



class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}



class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first expense',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}



class _HomeContent extends ConsumerStatefulWidget {
  final List<Expense> expenses;

  const _HomeContent({required this.expenses});

  @override
  ConsumerState<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<_HomeContent> {
  String _selectedCategory = 'All';

  List<Expense> get _filteredByMonth {
    final month = ref.watch(monthProvider);
    return widget.expenses.where((e) {
      return e.date.year == month.year && e.date.month == month.month;
    }).toList();
  }

  List<Expense> get _filteredByCategory {
    if (_selectedCategory == 'All') return _filteredByMonth;
    return _filteredByMonth
        .where((e) => e.category == _selectedCategory)
        .toList();
  }

  double get _total {
    return _filteredByCategory.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        _MonthNavigator(),
        _CategoryFilter(
          selected: _selectedCategory,
          onSelected: (cat) => setState(() => _selectedCategory = cat),
        ),

        const SizedBox(height: 8),

        _SummaryCard(total: _total),

        const SizedBox(height: 8),

        Expanded(
          child: _filteredByCategory.isEmpty
              ? _NoResultsInMonth()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredByCategory.length,
            itemBuilder: (context, index) {
              final expense = _filteredByCategory[index];
              return _SwipeableExpenseTile(expense: expense);
            },
          ),
        ),
      ],
    );
  }
}


class _MonthNavigator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthNotifier = ref.watch(monthProvider.notifier);
    final monthLabel = ref.watch(monthProvider.notifier).label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => monthNotifier.previous(),
            icon: const Icon(Icons.chevron_left_rounded),
            style: IconButton.styleFrom(
              backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          Text(
            monthLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => monthNotifier.next(),
            icon: const Icon(Icons.chevron_right_rounded),
            style: IconButton.styleFrom(
              backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}


class _CategoryFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryFilter({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: CategoryHelper.all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = CategoryHelper.all[index];
          final isSelected = selected == category;
          final isAll = category == 'All';

          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAll) ...[
                    Icon(
                      CategoryHelper.icon(category),
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : CategoryHelper.color(category),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class _SummaryCard extends StatelessWidget {
  final double total;

  const _SummaryCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Spent',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: total),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return Text(
                    '${value.toStringAsFixed(3)} DT',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}



class _NoResultsInMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No expenses this month',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}


class _SwipeableExpenseTile extends ConsumerWidget {
  final Expense expense;

  const _SwipeableExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoryColor = CategoryHelper.color(expense.category);

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Expense?'),
            content: Text(
              'Remove ${expense.amount.toStringAsFixed(3)} DT - ${expense.category}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(expenseProvider.notifier).deleteExpense(expense.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${expense.category} expense deleted'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.dividerColor.withAlpha(50),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                CategoryHelper.icon(expense.category),
                color: categoryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expense.note.isNotEmpty ? expense.note : 'No note',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-${expense.amount.toStringAsFixed(3)} DT',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.editExpense,
                      extra: expense,
                    );
                  },
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}