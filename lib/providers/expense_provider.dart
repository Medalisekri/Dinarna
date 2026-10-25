import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';


class ExpenseListNotifier extends StreamNotifier<List<Expense>> {
  @override
  Stream<List<Expense>> build() {

    return ref.watch(expenseRepositoryProvider).watchExpenses();
  }



}

final expenseListProvider = StreamNotifierProvider<ExpenseListNotifier, List<Expense>>(
  ExpenseListNotifier.new,
);


class ExpenseNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {

  }

  Future<void> addExpense(Expense expense) async {

    await ref.read(expenseRepositoryProvider).addExpense(expense);
  }
  Future<void> updateExpense(Expense expense) async {
    await ref.read(expenseRepositoryProvider).updateExpense(expense);
  }
  Future<void> deleteExpense(String id) async {
    await ref.read(expenseRepositoryProvider).deleteExpense(id);
  }
}

final expenseProvider = AsyncNotifierProvider<ExpenseNotifier, void>(
  ExpenseNotifier.new,
);