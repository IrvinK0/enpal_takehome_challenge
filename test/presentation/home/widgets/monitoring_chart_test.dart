import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:enpal/presentation/home/widgets/monitoring_chart.dart';
import 'package:enpal/domain/models/models.dart';

import '../../pump_app.dart';

void main() {
  group('MonitoringChart Widget Tests', () {
    final testData = [
      MonitoringData(timestamp: DateTime(2023, 11, 1, 10, 0), value: 10.0),
      MonitoringData(timestamp: DateTime(2023, 11, 1, 11, 0), value: 15.0),
      MonitoringData(timestamp: DateTime(2023, 11, 1, 12, 0), value: 20.0),
    ];

    testWidgets('renders chart with provided data and properties',
        (tester) async {
      const yLabel = 'kW';
      const lineColor = Colors.blue;

      await tester.pumpApp(MonitoringChart(
        yLabel: yLabel,
        data: testData,
        lineColor: lineColor,
      ));

      expect(find.byType(SfCartesianChart), findsOneWidget);

      final numericAxisFinder = find.byType(NumericAxis);
      expect(numericAxisFinder, findsOneWidget);

      final lineSeriesFinder =
          find.byType(LineSeries<MonitoringData, DateTime>);
      expect(lineSeriesFinder, findsOneWidget);

      final chartWidget =
          tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      final series =
          chartWidget.series[0] as LineSeries<MonitoringData, DateTime>;
      expect(series.dataSource, equals(testData));

      expect(series.color, equals(lineColor));

      await tester.pumpAndSettle();
    });

    testWidgets('renders chart with correct yLabel', (tester) async {
      const yLabel = 'kW';

      await tester.pumpApp(MonitoringChart(
        yLabel: yLabel,
        data: testData,
        lineColor: Colors.blue,
      ));

      // Check that the Y-axis label format includes 'kW'
      final numericAxisFinder = find.byType(NumericAxis);
      final numericAxis = tester.widget(numericAxisFinder) as NumericAxis;
      expect(numericAxis.labelFormat, '{value} $yLabel');

      await tester.pumpAndSettle();
    });
  });
}
