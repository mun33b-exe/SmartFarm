import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartFarm',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: AuthGate(changeTheme: _changeTheme, currentTheme: _themeMode),
    );
  }
}
