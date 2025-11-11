// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_farm/main_navigation.dart';
import 'package:smart_farm/screens/home_screen.dart';

void main() {
  testWidgets('Main navigation shows correct screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainNavigation(
          changeTheme: (_) {},
          screens: const [
            HomeScreen(),
            _FakeMarketScreen(),
            _FakeCommunityScreen(),
            _FakeProfileScreen(),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    AppBar appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect((appBar.title as Text).data, 'Welcome, Farmer');

    await tester.tap(find.byIcon(Icons.storefront));
    await tester.pumpAndSettle();
    appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect((appBar.title as Text).data, 'Market');

    await tester.tap(find.byIcon(Icons.people));
    await tester.pumpAndSettle();
    appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect((appBar.title as Text).data, 'Community');
  });
}

class _FakeMarketScreen extends StatelessWidget {
  const _FakeMarketScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market')),
      body: const SizedBox.shrink(),
    );
  }
}

class _FakeCommunityScreen extends StatelessWidget {
  const _FakeCommunityScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const SizedBox.shrink(),
    );
  }
}

class _FakeProfileScreen extends StatelessWidget {
  const _FakeProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const SizedBox.shrink(),
    );
  }
}
