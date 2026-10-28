import '../../l10n/app_localizations.dart';

String getCategoryLabel(AppLocalizations l10n, String category) {
  switch (category) {
    case 'Food': return l10n.categoryFood;
    case 'Health': return l10n.categoryHealth;
    case 'Shopping': return l10n.categoryShopping;
    case 'Transport': return l10n.categoryTransport;
    default: return l10n.categoryOther;
  }
}