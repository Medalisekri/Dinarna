// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GlassVault';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get cancel => 'Cancel';

  @override
  String get sendLink => 'Send Link';

  @override
  String get resetLinkSent => 'Reset link sent! Check your inbox (and spam).';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle => 'Start tracking your expenses today';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get noExpensesYet => 'No expenses yet';

  @override
  String get tapToAddFirst => 'Tap + to add your first expense';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noExpensesThisMonth => 'No expenses this month';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get expenses => 'Expenses';

  @override
  String get deleteExpense => 'Delete Expense?';

  @override
  String removeExpenseConfirm(String amount, String category) {
    return 'Remove $amount DT - $category?';
  }

  @override
  String get delete => 'Delete';

  @override
  String expenseDeleted(String category) {
    return '$category expense deleted';
  }

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get amountLabel => 'Amount (DT)';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get noteOptional => 'Note (Optional)';

  @override
  String get updateExpense => 'Update Expense';

  @override
  String get noNote => 'No note';

  @override
  String get settingsAndBudget => 'Settings & Budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get budgetSubtitle =>
      'This limit applies to every month. Set 0 to disable.';

  @override
  String get currentBudget => 'Current Budget';

  @override
  String get notSet => 'Not set';

  @override
  String get quickSet => 'Quick Set';

  @override
  String get customAmount => 'Custom Amount (DT)';

  @override
  String get saveBudget => 'Save Budget';

  @override
  String get preferences => 'Preferences';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccountAndData => 'Delete Account & Data';

  @override
  String get permanentlyEraseData => 'Permanently erase all data';

  @override
  String get deleteAccountConfirmTitle => 'Delete Account?';

  @override
  String get deleteAccountConfirmMessage =>
      'This will permanently delete your account and ALL your expense data. This cannot be undone.';

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String get onTrack => 'On track';

  @override
  String get gettingClose => 'Getting close';

  @override
  String get almostAtLimit => 'Almost at limit';

  @override
  String get budgetExceeded => 'Budget exceeded!';

  @override
  String get setMonthlyBudget => 'Set a Monthly Budget';

  @override
  String get trackSpendingLimits => 'Track your spending limits and get alerts';

  @override
  String get spent => 'spent';

  @override
  String ofBudget(String percentage, String budget) {
    return '$percentage% of $budget DT';
  }

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get amountMustBePositive => 'Must be greater than 0';

  @override
  String get errorUserNotFound => 'No account found with this email.';

  @override
  String get errorWrongPassword => 'Incorrect password. Try again.';

  @override
  String get errorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get errorLoginFailed => 'Login failed. Please check your connection.';

  @override
  String get errorWeakPassword =>
      'Password is too weak. Use at least 6 characters.';

  @override
  String get errorEmailInUse => 'An account already exists with this email.';

  @override
  String get errorSignupFailed => 'Sign up failed. Please try again.';

  @override
  String get errorGoogleSignIn => 'Google sign-in failed.';

  @override
  String get errorGoogleCancelled => 'Google sign-in was cancelled.';

  @override
  String get pdfMonthlyReport => 'Monthly Expense Report';

  @override
  String get transactions => 'Transactions';

  @override
  String get budget => 'Budget';

  @override
  String get remaining => 'Remaining';

  @override
  String get allTransactions => 'All Transactions';

  @override
  String get pdfDate => 'Date';

  @override
  String get pdfCategory => 'Category';

  @override
  String get pdfNote => 'Note';

  @override
  String get pdfAmount => 'Amount';

  @override
  String get generatedBy => 'Generated by GlassVault';

  @override
  String get noExpensesToExport => 'No expenses to export for this month';

  @override
  String failedToGeneratePdf(String error) {
    return 'Failed to generate PDF: $error';
  }

  @override
  String budgetSetSuccess(String amount) {
    return 'Monthly budget set to $amount DT';
  }

  @override
  String get budgetDisabled => 'Budget tracking disabled';

  @override
  String get enterAmountOrZero => 'Please enter an amount or 0 to disable';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String get budgetCannotBeNegative => 'Budget cannot be negative';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryOther => 'Other';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';
}
