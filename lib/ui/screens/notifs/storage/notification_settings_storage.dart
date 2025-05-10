import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:weather_assistant/ui/screens/notifs/model/notification_settings.dart';

class NotificationSettingsStorage {
  static const String _key = 'notification_settings';

  Future<void> saveSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(settings.toJson()));
  }

  Future<NotificationSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) {
      return NotificationSettings(
        morningNotification: true,
        eveningNotification: true,
        severeWeatherAlerts: true,
      );
    }
    return NotificationSettings.fromJson(jsonDecode(jsonString));
  }
}
