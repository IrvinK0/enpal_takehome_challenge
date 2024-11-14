import 'dart:convert';
import 'package:caching/caching.dart';
import 'package:enpal/domain/models/monitoring_data.dart';
import 'package:enpal/domain/models/monitoring_type.dart';
import 'package:enpal/core/helpers/datetime.dart';
import 'package:api_client/api_client.dart';

/// Decides which elements to include from api response (e.g. hours 00:00, 01:00 etc..) in order to have clearer chart
const _itemOffset = 12;

/// A repository for managing and caching solar monitoring data.
///
/// The [MonitoringRepository] provides a way to fetch monitoring data, either
/// from a cache or a remote solar API. If cached data is available for a given
/// date and type, it will be returned immediately to improve performance.
/// Otherwise, fresh data will be fetched from the API and saved in the cache.
class MonitoringRepository {
  /// Creates a [MonitoringRepository] instance.
  ///
  /// - [apiClient]: The client responsible for fetching monitoring data from the remote API.
  /// - [cache]: A caching client to store and retrieve previously fetched data.
  MonitoringRepository({required apiClient, required cache})
      : _apiClient = apiClient,
        _cache = cache;

  final ApiClient _apiClient;
  final CachingClient _cache;

  /// Retrieves monitoring data for a specific [date] and [type].
  ///
  /// Checks the cache first. If data is cached, it is returned immediately.
  /// Otherwise, it fetches fresh data from the API by calling [refreshMonitoringData].
  ///
  /// - [date]: The `DateTime` object representing the date of the requested data.
  /// - [type]: The [MonitoringType] specifying the type of monitoring data.
  ///
  /// Returns a `Future` that completes with a list of [MonitoringData].
  Future<List<MonitoringData>> getMonitoringData({
    required DateTime date,
    required MonitoringType type,
  }) async {
    final dateTime = defaultDateFormat(date);
    var cachedResponse = _cache.getResponse(cacheKey(dateTime, type.label));

    if (cachedResponse != null) return _parse(cachedResponse);

    return refreshMonitoringData(date: date, type: type);
  }

  /// Fetches and caches fresh monitoring data from the API for a given [date] and [type].
  ///
  /// This method always calls the API, bypassing the cache. After retrieving the data,
  /// it saves the response in the cache for future requests.
  ///
  /// - [date]: The `DateTime` object representing the date of the requested data.
  /// - [type]: The [MonitoringType] specifying the type of monitoring data.
  ///
  /// Returns a `Future` that completes with a list of [MonitoringData].
  Future<List<MonitoringData>> refreshMonitoringData({
    required DateTime date,
    required MonitoringType type,
  }) async {
    final dateTime = defaultDateFormat(date);
    final response =
        await _apiClient.getMonitoringData(date: dateTime, type: type.label);

    final monitoringList = _parse(response);
    _cache.saveResponse(response, cacheKey(dateTime, type.label));
    return monitoringList;
  }

  /// Clears all cached monitoring data.
  ///
  /// Returns a `Future` that completes with `true` if the cache was successfully cleared,
  /// or `false` if it failed.
  Future<bool> clearData() => _cache.clearResponses();

  /// Parses a JSON response string into a list of [MonitoringData] objects.
  ///
  /// This function decodes the JSON response, checks if the decoded JSON is a
  /// list, and then maps each item in the list to a [MonitoringData] object.
  /// It then reduces the list to only include every [itemOffset]th element (e.g. hours 00:00, 01:00 etc..), starting from
  /// the first element.
  List<MonitoringData> _parse(String response) {
    final json = jsonDecode(response);

    // Check if the JSON is a list. If not, throw a custom error.
    if (json is! List<dynamic>) throw MonitoringRequestFailure();

    // Map the decoded JSON to MonitoringData objects.
    final fullList = json
        .map((value) => MonitoringData.fromJson(value as Map<String, dynamic>))
        .toList();

    // Generate a reduced list with every _itemOffset element.
    List<MonitoringData> reducedList = List.generate(
      (fullList.length / _itemOffset).ceil(),
      (index) => fullList[index * _itemOffset],
    );

    // Return the reduced list.
    return reducedList;
  }

  /// Generates a unique cache key based on [firstPart] and [secondPart].
  ///
  /// - [firstPart]: Typically the date string.
  /// - [secondPart]: Typically the monitoring type label.
  ///
  /// Returns a `String` that combines the two parts with a hyphen.
  String cacheKey(String firstPart, String secondPart) =>
      '$firstPart-$secondPart';
}
