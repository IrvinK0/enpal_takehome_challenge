import 'caching_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A client for caching responses using SharedPreferences with an optional prefix.
///
/// The [SharedPreferencesClient] provides methods to save, retrieve, and clear cached data.
/// It can be initialized with a custom prefix to differentiate between instances,
/// or with an existing [SharedPreferences] instance for advanced control.
final class SharedPreferencesClient extends CachingClient {
  /// Private constructor to prevent direct instantiation.
  SharedPreferencesClient._();

  /// Creates an instance of [SharedPreferencesClient] with a specific key prefix.
  ///
  /// The [prefix] parameter is used to differentiate stored data for multiple clients
  /// in SharedPreferences. This factory constructor initializes a new client with the specified
  /// prefix, which is set globally for the current session.
  ///
  /// - Parameter [prefix]: A string used as a prefix for all stored keys in this client.
  /// - Returns: A [SharedPreferencesClient] instance.
  static Future<SharedPreferencesClient> create({
    required String prefix,
  }) async {
    final client = SharedPreferencesClient._();
    await client._initializeWithPrefix(prefix);
    return client;
  }

  /// Creates an instance of [SharedPreferencesClient] using an existing [SharedPreferences] instance.
  ///
  /// This constructor is useful when a [SharedPreferences] instance is already available and
  /// doesn't require additional prefixing. The instance can be managed outside of this class,
  /// allowing for more control over stored data.
  ///
  /// - Parameter [preferences]: A pre-existing [SharedPreferences] instance.
  /// - Returns: A [SharedPreferencesClient] instance.
  static Future<SharedPreferencesClient> createWithSharedPreferences({
    required SharedPreferences preferences,
  }) async {
    final client = SharedPreferencesClient._();
    client._sharedPreferences = preferences;
    return client;
  }

  /// Initializes the SharedPreferences instance with a specific prefix.
  ///
  /// This method is called internally during the creation of a [SharedPreferencesClient]
  /// instance using the [create] factory constructor. It sets the global prefix to ensure
  /// that all keys are stored with the specified prefix.
  ///
  /// - Parameter [prefix]: The prefix for all keys stored in SharedPreferences.
  Future<void> _initializeWithPrefix(String prefix) async {
    SharedPreferences.setPrefix(prefix);
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  late final SharedPreferences _sharedPreferences;

  /// Saves a response in SharedPreferences under the specified key.
  ///
  /// - Parameters:
  ///   - [response]: The string data to save in SharedPreferences.
  ///   - [key]: The key under which the data will be stored.
  /// - Returns: A [Future] that completes when the save operation is done.
  @override
  Future<void> saveResponse(String response, String key) =>
      _sharedPreferences.setString(key, response);

  /// Retrieves a response from SharedPreferences using the specified key.
  ///
  /// - Parameter [key]: The key of the data to retrieve.
  /// - Returns: The retrieved string data, or `null` if the key does not exist.
  @override
  String? getResponse(String key) => _sharedPreferences.getString(key);

  /// Clears all responses stored in SharedPreferences for this client.
  ///
  /// - Returns: A [Future] that completes with `true` if the clear operation was successful, otherwise `false`.
  @override
  Future<bool> clearResponses() => _sharedPreferences.clear();
}
