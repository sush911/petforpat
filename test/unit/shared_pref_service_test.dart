import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../lib/app/shared_pref/shared_pref_service.dart';

void main() {
  late SharedPrefService sharedPrefService;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); // Reset before each test
    sharedPrefService = SharedPrefService();
  });

  group('SharedPrefService Tests', () {
    test('saveLoginSession saves userId and authToken', () async {
      await sharedPrefService.saveLoginSession(userId: '12345', authToken: 'abcd1234');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_logged_in'), true);
      expect(prefs.getString('user_id'), '12345');
      expect(prefs.getString('auth_token'), 'abcd1234');
    });

    test('clearSession removes all keys', () async {
      await sharedPrefService.saveLoginSession(userId: '12345', authToken: 'abcd1234');

      await sharedPrefService.clearSession();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().isEmpty, true);
    });

    test('isLoggedIn returns false if not set', () async {
      final result = await sharedPrefService.isLoggedIn();
      expect(result, false);
    });

    test('getUserId returns correct value', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', 'test_user');

      final result = await sharedPrefService.getUserId();
      expect(result, 'test_user');
    });

    test('getAuthToken returns correct value', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'token123');

      final result = await sharedPrefService.getAuthToken();
      expect(result, 'token123');
    });
  });
}
