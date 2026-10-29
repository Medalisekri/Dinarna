import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../helpers/category_helper.dart';

class PdfService {

  pw.Font? _regularFont;
  pw.Font? _boldFont;

  Future<pw.Font> _getRegularFont() async {
    if (_regularFont != null) return _regularFont!;
    final fontData = await rootBundle.load("lib/core/assets/fonts/Cairo-Regular.ttf");
    _regularFont = pw.Font.ttf(fontData);
    return _regularFont!;
  }

  Future<pw.Font> _getBoldFont() async {
    if (_boldFont != null) return _boldFont!;
    final fontData = await rootBundle.load("lib/core/assets/fonts/Cairo-Bold.ttf");
    _boldFont = pw.Font.ttf(fontData);
    return _boldFont!;
  }

  Future<Uint8List> generateMonthlyReport({
    required AppLocalizations l10n,
    required String monthLabel,
    required List<Expense> expenses,
    required double totalSpent,
    required double? budget,
  }) async {

    final regularFont = await _getRegularFont();
    final boldFont = await _getBoldFont();


    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: regularFont,
        bold: boldFont,
        italic: regularFont,
        boldItalic: boldFont,
      ),
    );



    final categoryTotals = <String, double>{};
    for (var expense in expenses) {
      final localizedCat = getCategoryLabel(l10n, expense.category);
      categoryTotals[localizedCat] = (categoryTotals[localizedCat] ?? 0) + expense.amount;
    }

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(l10n, monthLabel),
          pw.SizedBox(height: 20),
          _buildSummarySection(l10n, totalSpent, budget, expenses.length),
          pw.SizedBox(height: 30),
          _buildCategoryBreakdown(l10n, categoryTotals, totalSpent),
          pw.SizedBox(height: 30),
          _buildExpenseTable(l10n, expenses),
          pw.SizedBox(height: 30),
          _buildFooter(l10n),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(AppLocalizations l10n, String monthLabel) {
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
                l10n.appTitle,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              pw.Text(
                textAlign: pw.TextAlign.right,
                l10n.pdfMonthlyReport,
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700 , wordSpacing: 2),
              ),
              ],
          ),
          pw.Text(monthLabel, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  pw.Widget _buildSummarySection(AppLocalizations l10n, double total, double? budget, int count) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8)),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(l10n.totalSpent, '${total.toStringAsFixed(3)} DT'),
          _buildStatCard(l10n.transactions, '$count'),
          if (budget != null && budget > 0)
            _buildStatCard(l10n.budget, '${budget.toStringAsFixed(3)} DT'),
          if (budget != null && budget > 0)
            _buildStatCard(l10n.remaining, '${(budget - total).toStringAsFixed(3)} DT'),
        ],
      ),
    );
  }

  pw.Widget _buildStatCard(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pw.Widget _buildCategoryBreakdown(AppLocalizations l10n, Map<String, double> totals, double grandTotal) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(l10n.spendingByCategory, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        ...totals.entries.map((entry) {
          final percentage = grandTotal > 0 ? (entry.value / grandTotal * 100) : 0.0;
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              children: [
                pw.SizedBox(width: 100, child: pw.Text(entry.key,  style: pw.TextStyle(fontSize: 12 , ))),
                pw.Expanded(
                  child: pw.Container(
                    height: 8,
                    decoration: pw.BoxDecoration(color: PdfColors.grey300, borderRadius: pw.BorderRadius.circular(4)),
                    child: pw.Row(
                      children: [
                        if (percentage > 0)
                          pw.Expanded(
                            flex: percentage.round(),
                            child: pw.Container(height: 8, decoration: pw.BoxDecoration(color: PdfColors.indigo, borderRadius: pw.BorderRadius.circular(4))),
                          ),
                        if (percentage < 100)
                          pw.Expanded(flex: (100 - percentage).round(), child: pw.SizedBox()),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.SizedBox(
                  width: 80,
                  child: pw.Text('${entry.value.toStringAsFixed(3)} DT', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                ),
                pw.SizedBox(width: 40),
                pw.Text('${percentage.toStringAsFixed(0)}%', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _buildExpenseTable(AppLocalizations l10n, List<Expense> expenses) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(l10n.allTransactions, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold ) ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell(l10n.pdfDate, bold: true),
                _buildTableCell(l10n.pdfCategory, bold: true),
                _buildTableCell(l10n.pdfNote, bold: true),
                _buildTableCell(l10n.pdfAmount, bold: true, align: pw.TextAlign.right),
              ],
            ),
            ...expenses.map((expense) {
              return pw.TableRow(
                children: [
                  _buildTableCell('${expense.date.day}/${expense.date.month}/${expense.date.year}'),
                  _buildTableCell(getCategoryLabel(l10n, expense.category)),
                  _buildTableCell(expense.note.isNotEmpty ? expense.note : l10n.noNote),
                  _buildTableCell('${expense.amount.toStringAsFixed(3)} DT', align: pw.TextAlign.right),
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
      child: pw.Text(text, style: pw.TextStyle(fontSize: 10, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal), textAlign: align ),
    );
  }

  pw.Widget _buildFooter(AppLocalizations l10n) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 16),
      decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(l10n.generatedBy, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.Text(DateTime.now().toString().split(' ')[0], style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        ],
      ),
    );
  }



}

final pdfServiceProvider = Provider<PdfService>((ref) => PdfService());