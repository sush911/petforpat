// test/shared_prefs_helper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../lib/app/shared_pref/shared_preferences.dart'; // adjust the import path to your project

void main() {
  setUp(() {
    // Initialize shared_preferences with empty values before each test
    SharedPreferences.setMockInitialValues({});
  });

  test('saveToken and getToken should save and retrieve token correctly', () async {
    final helper = SharedPrefsHelper();

    await helper.saveToken('my_token');
    final token = await helper.getToken();

    expect(token, 'my_token');
  });

  test('clearToken should remove the token', () async {
    final helper = SharedPrefsHelper();

    await helper.saveToken('my_token');
    await helper.clearToken();
    final token = await helper.getToken();

    expect(token, null);
  });
}
