import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/router/app_router.dart';
import 'package:expense_tracker/providers/preferences_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(ProviderScope(


      child: const glassVaultApp()


  ));
}
class glassVaultApp extends ConsumerStatefulWidget {
  const glassVaultApp({super.key});


  @override
  ConsumerState<glassVaultApp> createState() => _glassVaultState();


}
class _glassVaultState extends ConsumerState<glassVaultApp>{
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'GlassVault',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

    );
  }
}


