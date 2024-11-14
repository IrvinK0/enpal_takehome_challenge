import 'package:flutter/material.dart';

/// A widget that displays a switch to toggle between units, along with a label.
///
/// Parameters:
/// - [isOn]: A boolean value representing the current state of the switch.
/// - [onChanged]: A callback function that is triggered when the user toggles the switch.
///   It takes a boolean parameter that indicates the new state of the switch.
class UnitSwitch extends StatelessWidget {
  const UnitSwitch({
    super.key,
    required this.isOn,
    required this.onChanged,
  });

  final bool isOn;

  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        const Text('kW'),
        Switch(value: isOn, onChanged: onChanged),
      ],
    );
  }
}
