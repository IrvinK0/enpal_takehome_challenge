import 'package:flutter/material.dart';

/// A widget that displays a date picker with left and right arrow buttons
/// to navigate through dates.
///
/// Parameters:
/// - [text]: A `String` to display in the center of the widget, usually the currently selected date.
/// - [didTapLeft]: A `Function()` that is triggered when the left arrow button is tapped.
/// - [didTapRight]: A `Function()` that is triggered when the right arrow button is tapped.
/// - [isRightButtonEnabled]: A `bool` that determines if the right arrow button is enabled or disabled.
class MonitoringDatePicker extends StatelessWidget {
  const MonitoringDatePicker({
    super.key,
    required this.text,
    required this.didTapLeft,
    required this.didTapRight,
    required this.isRightButtonEnabled,
  });

  final String text;
  final Function() didTapLeft;
  final Function() didTapRight;
  final bool isRightButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: didTapLeft,
          icon: const Icon(Icons.arrow_left),
        ),
        Text(text),
        IconButton(
          onPressed: isRightButtonEnabled ? didTapRight : null,
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}
