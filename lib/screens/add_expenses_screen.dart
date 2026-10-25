import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expense_provider.dart';

class AddExpensesScreen extends ConsumerStatefulWidget {
  final Expense? expense;
  const AddExpensesScreen({super.key, this.expense});

  @override
  ConsumerState<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends ConsumerState<AddExpensesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = 'Food';
  late DateTime _selectedDate;

  final List<String> _categories = ['Food', 'Health', 'Shopping', 'Transport', 'Other'];

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {

    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final note = _noteController.text.trim();

    final expense = Expense(
      id: widget.expense?.id ?? '',
      amount: amount,
      category: _selectedCategory,
      note: note,
      date: _selectedDate,
      userId: '',
    );


    try {
      if (widget.expense != null) {
        await ref.read(expenseProvider.notifier).updateExpense(expense);
      } else {
        await ref.read(expenseProvider.notifier).addExpense(expense);
      }


      if (mounted) context.pop();

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
                  ],
                  style: theme.textTheme.headlineSmall,
                  decoration: InputDecoration(
                    labelText: 'Amount (DT)',
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Amount is required';
                    final amount = double.tryParse(value.trim());
                    if (amount == null || amount <= 0) return 'Must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 20),


                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 20),


                TextFormField(
                  controller: _noteController,
                  maxLength: 100,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Note (Optional)',
                    prefixIcon: const Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 32),


                _SaveButton(
                  isEditing: isEditing,
                  onSave: _saveExpense,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _SaveButton extends StatefulWidget {
  final bool isEditing;
  final Future<void> Function() onSave;

  const _SaveButton({required this.isEditing, required this.onSave});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await widget.onSave();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _isLoading ? null : _handlePress,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Text(
        widget.isEditing ? 'Update Expense' : 'Add Expense',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}