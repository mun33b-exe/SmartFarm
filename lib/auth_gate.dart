import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'services/auth_service.dart';
import 'main_navigation.dart';
import 'screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  final Function(ThemeMode) changeTheme;
  final ThemeMode currentTheme;

  const AuthGate({
    super.key,
    required this.changeTheme,
    required this.currentTheme,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.hasData) {
          return MainNavigation(
            changeTheme: changeTheme,
            currentTheme: currentTheme,
          );
        }

        return const LoginScreen();
      },
    );
  }
}
