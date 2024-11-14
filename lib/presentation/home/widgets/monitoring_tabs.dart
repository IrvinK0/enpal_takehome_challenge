import 'package:flutter/material.dart';
import '../../../domain/models/models.dart';

/// A widget that displays a segmented button to select between different monitoring types.
///
/// Parameters:
/// - [type]: The currently selected [MonitoringType], which determines which segment is initially selected.
/// - [onChanged]: A callback function that is triggered when the user selects a different monitoring type.
///   It passes the selected [MonitoringType] as an argument.
class MonitoringTabs extends StatelessWidget {
  const MonitoringTabs({
    super.key,
    required this.type,
    required this.onChanged,
  });

  final MonitoringType type;

  final Function(MonitoringType) onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<MonitoringType>(
      selected: <MonitoringType>{type},
      segments: _segments,
      selectedIcon: Container(),
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }

  /// Generates the list of button segments for each [MonitoringType].
  List<ButtonSegment<MonitoringType>> get _segments => MonitoringType.values
      .map((element) => ButtonSegment(value: element, icon: Icon(element.icon)))
      .toList();
}

/// Extension on [MonitoringType] to provide a corresponding icon for each type.
extension MonitoringTypeExtension on MonitoringType {
  IconData get icon => switch (this) {
        MonitoringType.solar => Icons.sunny,
        MonitoringType.house => Icons.house,
        MonitoringType.battery => Icons.charging_station
      };
}
