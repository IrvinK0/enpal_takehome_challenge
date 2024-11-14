import 'package:enpal/presentation/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../pump_app.dart';

void main() {
  group('UnitSwitch', () {
    testWidgets(
        'UnitSwitch displays the correct initial state and responds to user interaction',
        (WidgetTester tester) async {
      bool isSwitchOn = false;
      bool onChangedCalledWithValue = false;

      await tester.pumpApp(UnitSwitch(
        isOn: isSwitchOn,
        onChanged: (bool value) {
          isSwitchOn = value;
          onChangedCalledWithValue = true;
        },
      ));

      // Tap the switch to toggle it
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(onChangedCalledWithValue, true);
      expect(isSwitchOn, true);
    });

    testWidgets('UnitSwitch displays "kW" text correctly',
        (WidgetTester tester) async {
      // Build the widget tree with UnitSwitch
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitSwitch(
              isOn: true,
              onChanged: (bool value) {},
            ),
          ),
        ),
      );

      // Verify that the text 'kW' is displayed correctly
      expect(find.text('kW'), findsOneWidget);
    });

    testWidgets('UnitSwitch initial state is off', (WidgetTester tester) async {
      bool isSwitchOn = false;

      // Build the widget tree with UnitSwitch
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitSwitch(
              isOn: isSwitchOn,
              onChanged: (bool value) {},
            ),
          ),
        ),
      );

      // Verify the initial state of the switch is off
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Switch && widget.value == false),
          findsOneWidget);
    });

    testWidgets('UnitSwitch initial state is on', (WidgetTester tester) async {
      bool isSwitchOn = true;

      // Build the widget tree with UnitSwitch
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitSwitch(
              isOn: isSwitchOn,
              onChanged: (bool value) {},
            ),
          ),
        ),
      );

      // Verify the initial state of the switch is on
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Switch && widget.value == true),
          findsOneWidget);
    });
  });
}
