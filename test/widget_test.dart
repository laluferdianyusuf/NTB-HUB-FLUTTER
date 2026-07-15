import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ntbhub_flutter/app/app.dart';

void main() {
  testWidgets('App renders splash route', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();

    expect(find.text('NTB Hub'), findsOneWidget);
  });
}
