import 'package:enpal/domain/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonitoringData', () {
    const mockDateTime = '2024-11-01 09:25:00.000Z';
    const mockValue = 5877;

    test('returns correct MonitoringData object', () {
      expect(
          MonitoringData.fromJson(const <String, dynamic>{
            'timestamp': mockDateTime,
            'value': mockValue
          }),
          isA<MonitoringData>()
              .having(
                  (w) => w.timestamp, 'timestamp', DateTime.parse(mockDateTime))
              .having((w) => w.value, 'value', mockValue));
    });
  });
}
