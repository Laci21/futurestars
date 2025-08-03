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
  testWidgets('Breathing exercise app loads with intro screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: BreathingExerciseApp(),
    ));

    // Verify that our breathing exercise app loads with intro screen
    expect(find.text('Intro'), findsOneWidget);
    expect(find.text('Take a moment to breathe, transform each inhale into power.'), findsOneWidget);
    expect(find.text('Next Phase'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });

  testWidgets('Navigation works between breathing phases', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(
      child: BreathingExerciseApp(),
    ));

    // Should start at intro
    expect(find.text('Intro'), findsOneWidget);

    // Tap next phase button
    await tester.tap(find.text('Next Phase'));
    await tester.pumpAndSettle();

    // Should navigate to inhale
    expect(find.text('Inhale'), findsOneWidget);
    expect(find.text('Inhale slowly for 5 seconds and fill your lungs.'), findsOneWidget);

    // Tap next phase again
    await tester.tap(find.text('Next Phase'));
    await tester.pumpAndSettle();

    // Should navigate to hold
    expect(find.text('Hold'), findsOneWidget);
  });
}
