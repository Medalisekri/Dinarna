import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Expense>> watchExpenses() {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('date', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList());
  }

  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('expenses').add({...expense.toMap(), 'userId': _auth.currentUser!.uid});
  }

  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
  }
}


final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) => ExpenseRepository());