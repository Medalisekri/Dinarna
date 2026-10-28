import '../../l10n/app_localizations.dart';

String getLocalizedLoginError(AppLocalizations l10n, String error) {
  if (error.contains('user-not-found')) return l10n.errorUserNotFound;
  if (error.contains('wrong-password')) return l10n.errorWrongPassword;
  if (error.contains('invalid-email')) return l10n.errorInvalidEmail;
  if (error.contains('too-many-requests')) return l10n.errorTooManyRequests;
  if (error.contains('Google sign-in cancelled')) return l10n.errorGoogleCancelled;
  if (error.contains('Google')) return l10n.errorGoogleSignIn;
  return l10n.errorLoginFailed;
}
String getLocalizedSingUpError(AppLocalizations l10n, String error) {
  if (error.contains('weak-password')) return l10n.errorWeakPassword;
  if (error.contains('email-already-in-use')) return l10n.errorEmailInUse;
  if (error.contains('invalid-email')) return l10n.errorInvalidEmail;
  return l10n.errorSignupFailed;
}