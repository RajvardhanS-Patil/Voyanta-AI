import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: VoyantaApp()));

    // Verify that the login screen title is present
    expect(find.text('Welcome to Voyanta AI'), findsOneWidget);
  });
}
