import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/models/models.dart';

/// A widget that renders a monitoring data line chart using `SfCartesianChart`.
///
/// Parameters:
/// - [yLabel]: A `String` representing the unit label for the y-axis, displayed alongside values.
/// - [data]: A `List<MonitoringData>` that holds the data points for the chart, where each
///   entry represents a data value and its timestamp.
/// - [lineColor]: A `Color` defining the color of the chart line, allowing customization of appearance.
class MonitoringChart extends StatelessWidget {
  const MonitoringChart({
    super.key,
    required this.yLabel,
    required this.data,
    required this.lineColor,
  });

  final String yLabel;
  final List<MonitoringData> data;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // Sets up the x-axis to display time in hours and minutes.
      primaryXAxis: DateTimeAxis(dateFormat: DateFormat.Hm()),

      // Configures the y-axis with labels displaying the specified unit of measurement.
      primaryYAxis: NumericAxis(labelFormat: '{value} $yLabel'),

      // Defines the data series and style for the line chart.
      series: [
        LineSeries<MonitoringData, DateTime>(
          dataSource: data, // List of data points for the chart
          color: lineColor, // Line color customization

          // Maps data timestamps to the x-axis.
          xValueMapper: (MonitoringData data, _) => data.timestamp,

          // Maps data values to the y-axis.
          yValueMapper: (MonitoringData data, _) => data.value,
        ),
      ],
    );
  }
}
