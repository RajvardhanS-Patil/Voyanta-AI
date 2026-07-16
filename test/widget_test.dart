import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: VoyantaApp()));

    // Verify that the companion screen title is present
    expect(find.text('Voyanta AI Companion'), findsOneWidget);

    // Wait for async mock repository timers to complete to avoid pending timer leaks
    await tester.pump(const Duration(milliseconds: 500));
  });
}
