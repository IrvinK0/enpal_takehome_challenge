import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:api_client/api_client.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<http.Response>(),
  MockSpec<Uri>(),
])
import 'remote_api_client_test.mocks.dart';

void main() {
  group('RemoteMonitoringClient', () {
    late http.Client httpClient;
    late RemoteApiClient apiClient;
    const scheme = 'http';
    const host = 'example.com';

    String baseUrl() => '$scheme://$host';

    const date = '2024-11-01';
    const type = 'solar';
    const responseBody = '{"data": "sample"}';

    final uri = Uri.parse('${baseUrl()}/monitoring')
        .replace(queryParameters: {'date': date, 'type': type});

    setUp(() {
      httpClient = MockClient();
      apiClient = RemoteApiClient(baseUrl: baseUrl(), httpClient: httpClient);
    });

    test('does not require an httpClient', () {
      expect(RemoteApiClient(baseUrl: ''), isNotNull);
    });

    test('makes correct http request', () async {
      final response = MockResponse();

      when(response.statusCode).thenReturn(200);
      when(response.body).thenReturn('{}');
      when(httpClient.get(uri)).thenAnswer((_) async => response);
      try {
        await apiClient.getMonitoringData(date: date, type: type);
      } catch (_) {}
      verify(
        httpClient.get(
          Uri(
              scheme: scheme,
              host: host,
              path: 'monitoring',
              queryParameters: {'date': date, 'type': type}),
        ),
      ).called(1);
    });

    test('returns data if the http call completes successfully', () async {
      final response = MockResponse();
      when(response.body).thenReturn(responseBody);
      when(response.statusCode).thenReturn(200);
      when(httpClient.get(uri)).thenAnswer((_) async => response);

      final result = await apiClient.getMonitoringData(date: date, type: type);

      expect(result, responseBody);
      expect(result, isA<String>());
      verify(httpClient.get(uri)).called(1);
    });

    test('throws MonitoringRequestFailure on non-200 response', () async {
      final response = MockResponse();

      when(response.statusCode).thenReturn(400);
      when(httpClient.get(uri)).thenAnswer((_) async => response);
      expect(
        apiClient.getMonitoringData(date: date, type: type),
        throwsA(isA<MonitoringRequestFailure>()),
      );
    });

    test('throws MonitoringRequestFailure on error response', () async {
      final response = MockResponse();
      when(response.statusCode).thenReturn(200);
      when(response.body).thenReturn('');
      when(httpClient.get(uri)).thenAnswer((_) async => response);
      await expectLater(
        apiClient.getMonitoringData(date: date, type: type),
        throwsA(isA<MonitoringRequestFailure>()),
      );
    });
  });
}
