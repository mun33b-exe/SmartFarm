// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_farm/main_navigation.dart';

void main() {
  testWidgets('Main navigation shows correct screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainNavigation()));
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
