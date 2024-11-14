import 'package:enpal/presentation/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enpal/domain/models/models.dart';

import '../../pump_app.dart';

void main() {
  group('MonitoringTabs Widget Tests', () {
    testWidgets(
        'MonitoringTabs displays the selected type and triggers onChanged',
        (WidgetTester tester) async {
      MonitoringType selectedType = MonitoringType.solar;
      bool onChangedTriggered = false;

      await tester.pumpApp(MonitoringTabs(
        type: selectedType,
        onChanged: (MonitoringType newType) {
          onChangedTriggered = true;
          selectedType = newType;
        },
      ));

      expect(find.byIcon(Icons.sunny), findsOneWidget);

      await tester.tap(find.byIcon(Icons.house));
      await tester.pump();

      expect(onChangedTriggered, true);
      expect(selectedType, MonitoringType.house);
    });

    testWidgets('MonitoringTabs displays all segments with correct icons',
        (WidgetTester tester) async {
      await tester.pumpApp(MonitoringTabs(
        type: MonitoringType.solar,
        onChanged: (MonitoringType newType) {},
      ));

      expect(find.byIcon(Icons.sunny), findsOneWidget);
      expect(find.byIcon(Icons.house), findsOneWidget);
      expect(find.byIcon(Icons.charging_station), findsOneWidget);
    });

    testWidgets(
        'MonitoringTabs triggers the correct onChanged callback when a new segment is selected',
        (WidgetTester tester) async {
      MonitoringType selectedType = MonitoringType.solar;

      // Build the widget tree
      await tester.pumpApp(MonitoringTabs(
        type: selectedType,
        onChanged: (MonitoringType newType) {
          selectedType = newType;
        },
      ));

      await tester.tap(find.byIcon(Icons.charging_station));
      await tester.pump();

      expect(selectedType, MonitoringType.battery);
    });

    testWidgets('MonitoringTabs updates the UI when a new segment is selected',
        (WidgetTester tester) async {
      MonitoringType selectedType = MonitoringType.solar;

      // Build the widget tree
      await tester.pumpApp(MonitoringTabs(
        type: selectedType,
        onChanged: (MonitoringType newType) {
          selectedType = newType;
        },
      ));

      expect(find.byIcon(Icons.sunny), findsOneWidget);

      await tester.tap(find.byIcon(Icons.house));
      await tester.pump();

      expect(find.byIcon(Icons.house), findsOneWidget);
    });
  });
}
