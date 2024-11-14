import 'package:intl/intl.dart';

/// Formats a given [DateTime] object to a string in the default format 'yyyy-MM-dd'.
///
/// - [date]: The [DateTime] to format.
/// - Returns: A `String` representation of the date in 'yyyy-MM-dd' format.
String defaultDateFormat(DateTime date) =>
    DateFormat('yyyy-MM-dd').format(date);

/// Checks if a given [DateTime] object represents today’s date.
///
/// - [date]: The [DateTime] to check.
/// - Returns: `true` if [date] is the same day as today, otherwise `false`.
bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}
