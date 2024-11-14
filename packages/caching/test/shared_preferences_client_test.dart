import 'package:caching/caching.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'shared_preferences_client_test.mocks.dart';

void main() {
  group('SharedPreferencesClient', () {
    late SharedPreferencesClient client;
    late MockSharedPreferences mockPreferences;

    setUp(() async {
      mockPreferences = MockSharedPreferences();
      client = await SharedPreferencesClient.createWithSharedPreferences(
        preferences: mockPreferences,
      );
    });

    test('saves a response with a specific key', () async {
      const key = 'testKey';
      const response = 'testResponse';

      when(mockPreferences.setString(key, response))
          .thenAnswer((_) async => true);

      await client.saveResponse(response, key);

      verify(mockPreferences.setString(key, response)).called(1);
    });

    test('retrieves a response by key', () {
      const key = 'testKey';
      const response = 'testResponse';

      when(mockPreferences.getString(key)).thenReturn(response);

      final result = client.getResponse(key);

      expect(result, response);
      verify(mockPreferences.getString(key)).called(1);
    });

    test('returns null if key does not exist', () {
      const key = 'nonexistentKey';

      when(mockPreferences.getString(key)).thenReturn(null);

      final result = client.getResponse(key);

      expect(result, isNull);
      verify(mockPreferences.getString(key)).called(1);
    });

    test('clears all responses', () async {
      when(mockPreferences.clear()).thenAnswer((_) async => true);

      final result = await client.clearResponses();

      expect(result, isTrue);
      verify(mockPreferences.clear()).called(1);
    });

    test('returns false if clearing responses fails', () async {
      when(mockPreferences.clear()).thenAnswer((_) async => false);

      final result = await client.clearResponses();

      expect(result, isFalse);
      verify(mockPreferences.clear()).called(1);
    });
  });
}
