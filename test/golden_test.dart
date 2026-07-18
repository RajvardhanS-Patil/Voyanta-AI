import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:voyanta_ai/core/ux/empty_state_view.dart';
import 'package:voyanta_ai/core/ux/error_recovery_view.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Core UX Components Golden Tests', (tester) async {
    await tester.pumpWidget(
      materialAppWrapper(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
      )(
        const Scaffold(
          body: EmptyStateView(
            icon: Icons.flight_takeoff,
            title: 'No Trips Found',
            description: 'Your upcoming journeys will appear here.',
          ),
        ),
      ),
    );
    await screenMatchesGolden(tester, 'empty_state_view');

    await tester.pumpWidget(
      materialAppWrapper(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
      )(
        Scaffold(
          body: ErrorRecoveryView(
            title: 'Connection Error',
            description: 'Connection Timeout',
            onRetry: () {},
          ),
        ),
      ),
    );
    await screenMatchesGolden(tester, 'error_recovery_view');
  });
}
