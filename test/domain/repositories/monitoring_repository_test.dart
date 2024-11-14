import 'package:caching/caching.dart';
import 'package:enpal/domain/models/monitoring_data.dart';
import 'package:enpal/domain/models/monitoring_type.dart';
import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:enpal/core/helpers/datetime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:api_client/api_client.dart';

class MockRemoteSolarApiClient extends Mock implements ApiClient {}

class MockSharedPreferencesClient extends Mock implements CachingClient {}

void main() {
  group('MonitoringRepository', () {
    late ApiClient apiClient;
    late CachingClient cache;
    late MonitoringRepository repository;

    final date = DateTime(2024, 11, 1);
    const type = MonitoringType.solar;
    final dateStr = defaultDateFormat(date);
    final cacheKey = '$dateStr-${type.label}';
    var monitoringData = [MonitoringData(timestamp: date, value: 3656)];
    const responseJson = '''
  [
    {
      "timestamp": "2024-11-01 00:00:00.000",
      "value": 3656
    }
  ]
''';

    setUp(() {
      apiClient = MockRemoteSolarApiClient();
      cache = MockSharedPreferencesClient();
      repository = MonitoringRepository(apiClient: apiClient, cache: cache);
    });

    setUpAll(() {
      registerFallbackValue(MonitoringType.solar);
    });

    test('does require an apiClient and cache', () {
      expect(
          MonitoringRepository(apiClient: apiClient, cache: cache), isNotNull);
    });

    group('getMonitoringData', () {
      test('returns cached data if available', () async {
        // Arrange: Simulate cached data
        when(() => cache.getResponse(cacheKey)).thenReturn(responseJson);

        // Act: Call the method
        final result =
            await repository.getMonitoringData(date: date, type: type);

        // Assert: Verify the returned data matches expected result and cache is used
        expect(result, equals(monitoringData));
        verify(() => cache.getResponse(cacheKey)).called(1);
        verifyNever(
            () => apiClient.getMonitoringData(date: dateStr, type: type.label));
      });

      test('fetches data from API if not cached', () async {
        when(() => cache.getResponse(cacheKey)).thenReturn(null);
        when(() => cache.saveResponse(any(), any())).thenAnswer((_) async {});
        when(() => apiClient.getMonitoringData(date: dateStr, type: type.label))
            .thenAnswer((_) async => responseJson);

        final result =
            await repository.getMonitoringData(date: date, type: type);

        expect(result, equals(monitoringData));
        verify(() => cache.getResponse(cacheKey)).called(1);
        verify(() =>
                apiClient.getMonitoringData(date: dateStr, type: type.label))
            .called(1);
        verify(() => cache.saveResponse(responseJson, cacheKey)).called(1);
      });
    });

    group('refreshMonitoringData', () {
      test('fetches data from API and saves it in cache', () async {
        // Arrange: Mock API response
        when(() => apiClient.getMonitoringData(date: dateStr, type: type.label))
            .thenAnswer((_) async => responseJson);
        when(() => cache.saveResponse(any(), any())).thenAnswer((_) async {});

        // Act: Call the method
        final result =
            await repository.refreshMonitoringData(date: date, type: type);

        // Assert: Verify API call and cache update
        expect(result, equals(monitoringData));
        verify(() =>
                apiClient.getMonitoringData(date: dateStr, type: type.label))
            .called(1);
        verify(() => cache.saveResponse(responseJson, cacheKey)).called(1);
      });

      test('throws MonitoringRequestFailure if API response is invalid',
          () async {
        // Arrange: Mock an invalid API response
        when(() => apiClient.getMonitoringData(date: dateStr, type: type.label))
            .thenAnswer((_) async => '{}'); // Invalid JSON format

        // Act & Assert: Expect an exception to be thrown
        expect(
          () async =>
              await repository.refreshMonitoringData(date: date, type: type),
          throwsA(isA<MonitoringRequestFailure>()),
        );
      });
    });

    group('clearData', () {
      test('calls clearResponses on cache', () async {
        // Arrange: Mock cache clear response
        when(() => cache.clearResponses()).thenAnswer((_) async => true);

        // Act: Call the method
        final result = await repository.clearData();

        // Assert: Verify cache clear method is called
        expect(result, isTrue);
        verify(() => cache.clearResponses()).called(1);
      });
    });
  });
}
