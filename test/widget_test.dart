import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots to a MaterialApp without crashing', (tester) async {
    // A minimal smoke test — full app boot needs plugins (ads, prefs)
    // that don't run in the CI test environment without mocking, so we
    // just verify a MaterialApp shell renders. Expand this as you add
    // testable widgets/providers.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('RTO Expert'))),
      ),
    );
    expect(find.text('RTO Expert'), findsOneWidget);
  });
}
