import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class PdfService {

  Future<Uint8List> generateMonthlyReport({
    required String monthLabel,
    required List<Expense> expenses,
    required double totalSpent,
    required double? budget,
  }) async {
    final pdf = pw.Document();


    final categoryTotals = <String, double>{};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(monthLabel),
          pw.SizedBox(height: 20),

          _buildSummarySection(totalSpent, budget, expenses.length),
          pw.SizedBox(height: 30),

          _buildCategoryBreakdown(categoryTotals, totalSpent),
          pw.SizedBox(height: 30),
          _buildExpenseTable(expenses),
          pw.SizedBox(height: 30),

          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(String monthLabel) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'GlassVault',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.indigo,
                ),
              ),
              pw.Text(
                'Monthly Expense Report',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.Text(
            monthLabel,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummarySection(double total, double? budget, int count) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Total Spent', '${total.toStringAsFixed(3)} DT'),
          _buildStatCard('Transactions', '$count'),
          if (budget != null && budget > 0)
            _buildStatCard('Budget', '${budget.toStringAsFixed(3)} DT'),
          if (budget != null && budget > 0)
            _buildStatCard(
              'Remaining',
              '${(budget - total).toStringAsFixed(3)} DT',
            ),
        ],
      ),
    );
  }

  pw.Widget _buildStatCard(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
  pw.Widget _buildCategoryBreakdown(Map<String, double> totals, double grandTotal) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Spending by Category',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        ...totals.entries.map((entry) {
          final percentage = grandTotal > 0 ? (entry.value / grandTotal * 100) : 0.0;
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 120,
                  child: pw.Text(
                    entry.key,
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ),
                // Conteneur de la barre de progression globale (Gris)
                pw.Expanded(
                  child: pw.Container(
                    height: 8,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    // Remplacement du FractionallySizedBox par une Row + Expanded Flex
                    child: pw.Row(
                      children: [
                        // Partie Indigo (Remplissage)
                        if (percentage > 0)
                          pw.Expanded(
                            flex: percentage.round(),
                            child: pw.Container(
                              height: 8,
                              decoration: pw.BoxDecoration(
                                color: PdfColors.indigo,
                                borderRadius: pw.BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        // Partie Vide (Reste de la barre)
                        if (percentage < 100)
                          pw.Expanded(
                            flex: (100 - percentage).round(),
                            child: pw.SizedBox(),
                          ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.SizedBox(
                  width: 80,
                  child: pw.Text(
                    '${entry.value.toStringAsFixed(3)} DT',
                    style: pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.SizedBox(width: 40),
                pw.Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _buildExpenseTable(List<Expense> expenses) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'All Transactions',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Date', bold: true),
                _buildTableCell('Category', bold: true),
                _buildTableCell('Note', bold: true),
                _buildTableCell('Amount', bold: true, align: pw.TextAlign.right),
              ],
            ),
            ...expenses.map((expense) {
              return pw.TableRow(
                children: [
                  _buildTableCell(
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  ),
                  _buildTableCell(expense.category),
                  _buildTableCell(
                    expense.note.isNotEmpty ? expense.note : '-',
                  ),
                  _buildTableCell(
                    '${expense.amount.toStringAsFixed(3)} DT',
                    align: pw.TextAlign.right,
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool bold = false, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by GlassVault',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            DateTime.now().toString().split(' ')[0],
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }
}



final pdfServiceProvider = Provider<PdfService>((ref) => PdfService());