// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دينارنا';

  @override
  String get loginTitle => 'مرحبا بيك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة السر';

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get login => 'دخول';

  @override
  String get or => 'أو';

  @override
  String get continueWithGoogle => 'واصل بحساب Google';

  @override
  String get dontHaveAccount => 'ما عندكش حساب؟';

  @override
  String get signUp => 'سجّل';

  @override
  String get resetPassword => 'إعادة تعيين كلمة السر';

  @override
  String get enterYourEmail => 'دخّل الإيميل متاعك';

  @override
  String get cancel => 'إلغاء';

  @override
  String get sendLink => 'أرسل الرابط';

  @override
  String get resetLinkSent => 'تم إرسال الرابط! شوف الإيميل متاعك (و السبام).';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAccountSubtitle => 'ابدا تتبع مصاريفك اليوم';

  @override
  String get confirmPassword => 'تأكيد كلمة السر';

  @override
  String get alreadyHaveAccount => 'عندك حساب؟';

  @override
  String get noExpensesYet => 'ما عندكش مصاريف';

  @override
  String get tapToAddFirst => 'اضغط + باش تزيد أول مصروف';

  @override
  String get somethingWentWrong => 'صار مشكل';

  @override
  String get tryAgain => 'عاود حاول';

  @override
  String get noExpensesThisMonth => 'ما عندكش مصاريف هذا الشهر';

  @override
  String get totalSpent => 'المجموع الكلي';

  @override
  String get expenses => 'المصاريف';

  @override
  String get deleteExpense => 'تحذف المصروف؟';

  @override
  String removeExpenseConfirm(String amount, String category) {
    return 'تحذف $amount دينار - $category؟';
  }

  @override
  String get delete => 'احذف';

  @override
  String expenseDeleted(String category) {
    return 'تم حذف مصروف $category';
  }

  @override
  String get editExpense => 'تعديل المصروف';

  @override
  String get addExpense => 'زيادة مصروف';

  @override
  String get amountLabel => 'المبلغ (دينار)';

  @override
  String get category => 'الفئة';

  @override
  String get date => 'التاريخ';

  @override
  String get next => 'التالي';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get updateExpense => 'تعديل المصروف';

  @override
  String get noNote => 'بدون ملاحظة';

  @override
  String get settingsAndBudget => 'الإعدادات و الميزانية';

  @override
  String get monthlyBudget => 'الميزانية الشهرية';

  @override
  String get budgetSubtitle => 'هذا الحد ينطبق على كل شهر. دخّل 0 باش تلغيه.';

  @override
  String get currentBudget => 'الميزانية الحالية';

  @override
  String get notSet => 'ما تحددتش';

  @override
  String get quickSet => 'تحديد سريع';

  @override
  String get customAmount => 'مبلغ مخصص (دينار)';

  @override
  String get saveBudget => 'احفظ الميزانية';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get theme => 'المظهر';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get account => 'الحساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get deleteAccountAndData => 'حذف الحساب و البيانات';

  @override
  String get permanentlyEraseData => 'حذف نهائي لكل البيانات';

  @override
  String get deleteAccountConfirmTitle => 'تحذف الحساب؟';

  @override
  String get deleteAccountConfirmMessage =>
      'هذا يحذف حسابك و كل بيانات المصاريف نهائيا. ما تنجمش ترجع فيه.';

  @override
  String get deleteForever => 'احذف نهائيا';

  @override
  String get onTrack => 'مزلت بعيد للحد';

  @override
  String get gettingClose => 'قرّبت للحد';

  @override
  String get almostAtLimit => 'قرّبت برشا للحد';

  @override
  String get budgetExceeded => 'تجاوزت الميزانية!';

  @override
  String get setMonthlyBudget => 'حدّد ميزانية شهرية';

  @override
  String get trackSpendingLimits => 'تبع حدود الصرف متاعك و خوذ تنبيهات';

  @override
  String get spent => 'دينار تم صرفه';

  @override
  String get curr => 'دينار';

  @override
  String ofBudget(String percentage, String budget) {
    return '$percentage% من $budget دينار';
  }

  @override
  String get spendingByCategory => 'الصرف حسب الفئة';

  @override
  String get emailRequired => 'الإيميل مطلوب';

  @override
  String get enterValidEmail => 'دخّل إيميل صحيح';

  @override
  String get passwordRequired => 'كلمة السر مطلوبة';

  @override
  String get passwordMinLength => 'لازم تكون 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات السر ما تتطابقش';

  @override
  String get amountRequired => 'المبلغ مطلوب';

  @override
  String get amountMustBePositive => 'لازم يكون أكثر من 0';

  @override
  String get errorUserNotFound => 'ما لقيّناش حساب بهذا الإيميل.';

  @override
  String get errorWrongPassword => 'كلمة السر غلط. عاود حاول.';

  @override
  String get errorInvalidEmail => 'دخّل إيميل صحيح.';

  @override
  String get errorTooManyRequests => 'محاولات برشا. عاود حاول من بعد.';

  @override
  String get errorLoginFailed => 'الدخول فشل. شوف الاتصال متاعك.';

  @override
  String get errorWeakPassword => 'كلمة السر ضعيفة. استعمل 6 أحرف على الأقل.';

  @override
  String get errorEmailInUse => 'ثما حساب بهذا الإيميل.';

  @override
  String get errorSignupFailed => 'التسجيل فشل. عاود حاول.';

  @override
  String get errorGoogleSignIn => 'الدخول بحساب Google فشل.';

  @override
  String get errorGoogleCancelled => 'تم إلغاء الدخول بحساب Google.';

  @override
  String get pdfMonthlyReport => 'تقرير مصروفك';

  @override
  String get transactions => 'المعاملات';

  @override
  String get budget => 'الميزانية';

  @override
  String get remaining => 'المتبقي';

  @override
  String get allTransactions => 'كل المعاملات';

  @override
  String get pdfDate => 'التاريخ';

  @override
  String get pdfCategory => 'الفئة';

  @override
  String get pdfNote => 'ملاحظة';

  @override
  String get pdfAmount => 'المبلغ';

  @override
  String get generatedBy => 'تم إنشاؤه بواسطة دينارنا';

  @override
  String get noExpensesToExport => 'ما عندكش مصاريف باش تصدّرها هذا الشهر';

  @override
  String failedToGeneratePdf(String error) {
    return 'فشل إنشاء ملف PDF: $error';
  }

  @override
  String budgetSetSuccess(String amount) {
    return 'تم تحديد الميزانية الشهرية بـ $amount دينار';
  }

  @override
  String get budgetDisabled => 'تم إلغاء تتبع الميزانية';

  @override
  String get enterAmountOrZero => 'دخّل مبلغ أو 0 باش تلغي';

  @override
  String get enterValidNumber => 'دخّل رقم صحيح';

  @override
  String get budgetCannotBeNegative => 'الميزانية ما تنجمش تكون سالبة';

  @override
  String failedToSave(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get categoryAll => 'الكل';

  @override
  String get categoryFood => 'ماكلة';

  @override
  String get categoryHealth => 'صحة';

  @override
  String get categoryShopping => 'تسوّق';

  @override
  String get categoryTransport => 'نقل';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get monthJanuary => 'جانفي';

  @override
  String get monthFebruary => 'فيفري';

  @override
  String get monthMarch => 'مارس';

  @override
  String get monthApril => 'أفريل';

  @override
  String get monthMay => 'ماي';

  @override
  String get monthJune => 'جوان';

  @override
  String get monthJuly => 'جويلية';

  @override
  String get monthAugust => 'أوت';

  @override
  String get monthSeptember => 'سبتمبر';

  @override
  String get monthOctober => 'أكتوبر';

  @override
  String get monthNovember => 'نوفمبر';

  @override
  String get monthDecember => 'ديسمبر';
}
