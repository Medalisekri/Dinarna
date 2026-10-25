import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/router/app_router.dart';
import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

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

    return MaterialApp.router(
      title: 'GlassVault',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}


