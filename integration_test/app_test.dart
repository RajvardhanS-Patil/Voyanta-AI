import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:voyanta_ai/main_dev.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the navigation bar and verify screens', (tester) async {
      app.main();

      // Wait for app to render and mock database to hydrate
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // By default it should boot up into the Live Journey Engine
      expect(find.text('Live Journey Engine'), findsWidgets);

      // Find the Planner tab
      final plannerTab = find.byIcon(Icons.map_outlined);
      await tester.tap(plannerTab);
      await tester.pumpAndSettle();

      expect(find.text('No Trips Found'), findsOneWidget);

      // Find the Companion tab
      final companionTab = find.byIcon(Icons.auto_awesome);
      await tester.tap(companionTab);
      await tester.pumpAndSettle();

      expect(find.text('AI Travel Companion'), findsWidgets);

      // Find the Expense tab
      final expenseTab = find.byIcon(Icons.account_balance_wallet_outlined);
      await tester.tap(expenseTab);
      await tester.pumpAndSettle();

      expect(find.text('Trip Budget & Expenses'), findsWidgets);
    });
  });
}
