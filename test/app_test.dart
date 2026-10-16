import 'package:cbt_exam/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('start an exam, answer, submit and see the result', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CbtApp());
    expect(find.text('CBT Exam Practice'), findsOneWidget);

    await tester.tap(find.text('Mathematics'));
    await tester.pumpAndSettle();
    expect(find.text('Question 1 of 10'), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);

    await tester.tap(find.text('A').first);
    await tester.pump();
    expect(find.text('1 of 10 answered'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('14:59'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Submit exam?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Submit').last);
    await tester.pumpAndSettle();

    expect(find.text('Mathematics result'), findsOneWidget);
    expect(find.textContaining('9 unanswered'), findsOneWidget);
  });
}
