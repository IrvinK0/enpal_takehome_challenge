import 'dart:core';
import 'package:equatable/equatable.dart';

/// The [MonitoringData] class is designed to hold time-stamped data values in [watts].
/// It is serializable from JSON format.
///
/// This class extends [Equatable] to allow value comparison, making instances
/// comparable based on their [timestamp] and [value] properties.
///
class MonitoringData extends Equatable {
  const MonitoringData({required this.timestamp, required this.value});

  factory MonitoringData.fromJson(Map<String, dynamic> json) {
    final val = MonitoringData(
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num).toDouble(),
    );
    return val;
  }

  final DateTime timestamp;
  final double value;

  @override
  List<Object?> get props => [timestamp, value];
}
