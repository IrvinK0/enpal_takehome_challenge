/// An abstract class defining a caching interface for storing and retrieving
/// API responses.
///
/// The [CachingClient] class provides methods for saving, retrieving, and
/// clearing cached responses.
///
/// Methods:
/// - [saveResponse]: Saves a response associated with a unique key.
/// - [getResponse]: Retrieves a response based on a key, if it exists.
/// - [clearResponses]: Clears all stored responses from the cache.
abstract class CachingClient {
  /// Saves a [response] associated with a unique [key] to the cache.
  ///
  /// - [response]: The response data to be cached as a `String`.
  /// - [key]: A unique identifier for the cached data.
  Future<void> saveResponse(String response, String key);

  /// Retrieves a cached response based on the given [key].
  ///
  /// - [key]: The unique identifier for the cached response.
  /// - Returns a `String` containing the cached response if it exists,
  ///   or `null` if no response is associated with the key.
  String? getResponse(String key);

  /// Clears all cached responses.
  ///
  /// This method should remove all stored responses from the cache.
  ///
  /// Returns a `Future<bool>` indicating whether the operation was successful.
  Future<bool> clearResponses();
}
