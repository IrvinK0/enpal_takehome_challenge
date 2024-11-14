/// The [ApiClient] class defines an interface for working with Enpal monitoring API.
///
/// Methods:
/// - [getMonitoringData]: Fetches monitoring data for a specified date and type.
abstract class ApiClient {
  const ApiClient();

  /// Retrieves monitoring data for the given [date] and
  /// [type].
  ///
  /// The [date] parameter specifies the date to fetch the data for, while the [type] parameter indicates the type of
  /// monitoring data.
  ///
  /// - [date]: A `String` representing the date (format "YYYY-MM-DD").
  /// - [type]: A `String` specifying the data type (e.g., "solar", "house", "batery").
  ///
  /// Returns a `Future` that completes with monitoring String data.
  Future<String> getMonitoringData({
    required String date,
    required String type,
  });
}
