import 'package:flutter/material.dart';
import 'package:tweeter/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDWJSKdc9Hlhfmg5if8COvcKp7exTqCkOY',
      appId: '1:897967595665:android:80cc7b5bc997f6a00f5f30',
      messagingSenderId: '897967595665',
      projectId: 'mobile-app-development-d1e64',
      storageBucket: 'mobile-app-development-d1e64.firebasestorage.app',
    ),
  );

  runApp(const TweeterApp());
}

class TweeterApp extends StatelessWidget {
  const TweeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweeter',
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black54,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.grey.shade200,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}