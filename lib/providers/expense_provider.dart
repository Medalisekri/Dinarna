import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';


class ExpenseListNotifier extends StreamNotifier<List<Expense>> {
  @override
  Stream<List<Expense>> build() {

    return ref.watch(expenseRepositoryProvider).watchExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await ref.read(expenseRepositoryProvider).deleteExpense(id);
  }
}

final expenseListProvider = StreamNotifierProvider<ExpenseListNotifier, List<Expense>>(
  ExpenseListNotifier.new,
);


class AddExpenseNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {

  }

  Future<void> submitExpense(Expense expense) async {

    await ref.read(expenseRepositoryProvider).addExpense(expense);
  }
}

final addExpenseProvider = AsyncNotifierProvider<AddExpenseNotifier, void>(
  AddExpenseNotifier.new,
);