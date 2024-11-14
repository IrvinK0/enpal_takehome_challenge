import 'package:enpal/core/helpers/datetime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTime', () {
    group('Dateformat', () {
      var mockDateTime = DateTime(2024, 11, 1);

      test('returns correct formatted date string', () {
        expect(defaultDateFormat(mockDateTime), '2024-11-01');
      });
    });

    group('datetime helpers', () {
      var mockDateTime = DateTime(2024, 11, 1);

      test('returns isToday', () {
        expect(isToday(mockDateTime), false);
        expect(isToday(DateTime.now()), true);
      });
    });
  });
}
