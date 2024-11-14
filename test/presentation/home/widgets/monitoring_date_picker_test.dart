import 'package:enpal/presentation/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../pump_app.dart';

void main() {
  testWidgets('MonitoringDatePicker displays correct text',
      (WidgetTester tester) async {
    const testDate = '2024-11-14';

    await tester.pumpApp(MonitoringDatePicker(
      text: testDate,
      didTapLeft: () {},
      didTapRight: () {},
      isRightButtonEnabled: true,
    ));

    expect(find.text(testDate), findsOneWidget);
  });

  testWidgets('Left button triggers didTapLeft callback',
      (WidgetTester tester) async {
    bool leftButtonTapped = false;

    await tester.pumpApp(MonitoringDatePicker(
      text: '2024-11-14',
      didTapLeft: () {
        leftButtonTapped = true;
      },
      didTapRight: () {},
      isRightButtonEnabled: true,
    ));

    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.pump();

    expect(leftButtonTapped, true);
  });

  testWidgets('Right button triggers didTapRight callback when enabled',
      (WidgetTester tester) async {
    bool rightButtonTapped = false;

    // Build the widget tree with the right button enabled
    await tester.pumpApp(MonitoringDatePicker(
      text: '2024-11-14',
      didTapLeft: () {},
      didTapRight: () {
        rightButtonTapped = true;
      },
      isRightButtonEnabled: true,
    ));

    await tester.tap(find.byIcon(Icons.arrow_right));
    await tester.pump();

    expect(rightButtonTapped, true);
  });

  testWidgets(
      'Right button does not trigger didTapRight callback when disabled',
      (WidgetTester tester) async {
    bool rightButtonTapped = false;

    // Build the widget tree with the right button disabled
    await tester.pumpApp(MonitoringDatePicker(
      text: '2024-11-14',
      didTapLeft: () {},
      didTapRight: () {},
      isRightButtonEnabled: false,
    ));

    // Try tapping the right arrow button
    await tester.tap(find.byIcon(Icons.arrow_right));
    await tester.pump();

    // Verify that didTapRight callback was NOT called
    expect(rightButtonTapped, false);
  });
}
