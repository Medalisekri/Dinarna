import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:flutter_riverpod/legacy.dart';

class ExpenseProvider extends StateNotifier<List<Expense>> {
  ExpenseProvider():super([]){
    loadExpenses();
  }

  final _repository = ExpenseRepository();

  void loadExpenses(){
    _repository.getExpenses().listen((expenses){
      state = expenses;
      });
  }

  void addExpense(Expense expense){
    _repository.addExpense(expense);
  }

  void updateExpense(Expense expense){
    _repository.updateExpense(expense);
  }
  void deleteExpense(String id ){
    _repository.deleteExpense(id);
  }

}final expenseProvider = StateNotifierProvider<ExpenseProvider , List<Expense>>(
    (ref)=>ExpenseProvider(),
);
