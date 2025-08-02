// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('Breathing exercise app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: BreathingExerciseApp(),
    ));

    // Verify that our breathing exercise app loads
    expect(find.text('FutureStars'), findsOneWidget);
    expect(find.text('Breathing Exercise'), findsOneWidget);
    expect(find.text('App structure ready! 🎯'), findsOneWidget);
  });
}
