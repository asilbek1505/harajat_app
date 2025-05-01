import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harajat_app/pages/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAqXaYo39Npp_yAXj_piGZy6we7p32ldVw",
        authDomain: "harajatlar-ilovasi.firebaseapp.com",
        projectId: "harajatlar-ilovasi",
        storageBucket: "harajatlar-ilovasi.firebasestorage.app",
        messagingSenderId: "1079547855420",
        appId: "1:1079547855420:web:95994f44390fd0b573b939",
        measurementId: "G-ZQTX9D78JN",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDVDBNo7ubEKRe7RZP5DH4ysGjAe3H7gvE",
        appId: "1:1079547855420:android:6b678d1c7153f35673b939",
        messagingSenderId: "",
        projectId: "harajatlar-ilovasi",
        storageBucket: "harajatlar-ilovasi.firebasestorage.app",
      ),
    );
  }

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: Locale('uz'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 🔻 easy_localization uchun zarur
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: Splash(),
    );
  }
}
