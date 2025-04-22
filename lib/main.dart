
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tweeter/firebase_options.dart';
import 'package:tweeter/pages/home_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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