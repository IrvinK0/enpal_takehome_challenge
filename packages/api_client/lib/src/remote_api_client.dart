import 'package:http/http.dart' as http;
import 'api_client.dart';

/// A concrete implementation of [ApiClient] for fetching monitoring data
/// from a remote Enpal API.
final class RemoteApiClient extends ApiClient {
  /// Creates a [RemoteApiClient] instance.
  ///
  /// - [baseUrl]: The base URL for the Enpal API.
  /// - [httpClient]: An optional HTTP client to use for requests; if not
  ///   provided, a new [http.Client] will be created.
  RemoteApiClient({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  /// Fetches monitoring data for the specified [date] and [type].
  ///
  /// This method sends a GET request to the API at the endpoint:
  /// `$_baseUrl/monitoring?date=$date&type=$type`.
  /// If the response status is not 200 or if response body is empty, a [MonitoringRequestFailure] exception is thrown.
  ///
  /// - [date]: A `String` representing the date for which data is requested.
  /// - [type]: A `String` specifying the data type
  ///
  /// Returns a `Future` that completes with monitoring data.
  @override
  Future<String> getMonitoringData({
    required String date,
    required String type,
  }) async {
    final request = Uri.parse('$_baseUrl/monitoring')
        .replace(queryParameters: {'date': date, 'type': type});

    final response = await _httpClient.get(request);

    if (response.statusCode != 200 || response.body.isEmpty)
      throw MonitoringRequestFailure();

    return response.body;
  }
}

/// Exception thrown when a request for monitoring data fails.
///
/// [MonitoringRequestFailure] is thrown when the [RemoteApiClient]
/// encounters an error during the API request or when the response data
/// format is not as expected.
class MonitoringRequestFailure implements Exception {}
