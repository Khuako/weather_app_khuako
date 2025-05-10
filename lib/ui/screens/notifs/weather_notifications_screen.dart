import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/data/services/weather_request.dart';
import 'package:weather_assistant/main.dart';
import 'package:weather_assistant/ui/screens/notifs/model/notification_settings.dart';
import 'package:weather_assistant/ui/screens/notifs/storage/notification_settings_storage.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';

class WeatherNotificationsScreen extends StatefulWidget {
  const WeatherNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<WeatherNotificationsScreen> createState() =>
      _WeatherNotificationsScreenState();
}

class _WeatherNotificationsScreenState extends State<WeatherNotificationsScreen> {
  bool morningNotification = true;
  bool eveningNotification = true;
  bool severeWeatherAlerts = true;
  final NotificationSettingsStorage _storage = NotificationSettingsStorage();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storage.loadSettings();
    setState(() {
      morningNotification = settings.morningNotification;
      eveningNotification = settings.eveningNotification;
      severeWeatherAlerts = settings.severeWeatherAlerts;
    });
  }

  void _saveSettings()async {
    final settings = NotificationSettings(
      morningNotification: morningNotification,
      eveningNotification: eveningNotification,
      severeWeatherAlerts: severeWeatherAlerts,
    );
    _storage.saveSettings(settings);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Настройки сохранены"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Уведомления',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitchTile(
              title: "Утренние уведомления",
              subtitle: "Прогноз на день",
              value: morningNotification,
              onChanged: (value) => setState(() => morningNotification = value),
              icon: Icons.wb_sunny_outlined,
            ),
            _buildSwitchTile(
              title: "Вечерние уведомления",
              subtitle: "Прогноз на завтра",
              value: eveningNotification,
              onChanged: (value) => setState(() => eveningNotification = value),
              icon: Icons.nights_stay_outlined,
            ),
            _buildSwitchTile(
              title: "Экстренные уведомления",
              subtitle: "Шторм, ураганы, сильные осадки",
              value: severeWeatherAlerts,
              onChanged: (value) => setState(() => severeWeatherAlerts = value),
              icon: Icons.warning_amber_outlined,
            ),
            const Spacer(),
            SafeArea(child: _buildSaveButton()),
          ],
        ),
      ),
    );
  }

  /// Стильный переключатель уведомлений
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Card(
      color: grayBlack.withOpacity(.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: GoogleFonts.rubik(color: Colors.white, fontSize: 16)),
        subtitle: Text(subtitle, style: GoogleFonts.rubik(color: Colors.white70, fontSize: 14)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          inactiveTrackColor: backgroundColor,
          activeColor: lightBlack,
        ),
      ),
    );
  }

  /// Кнопка сохранения
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: grayBlack,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text("Сохранить", style: GoogleFonts.rubik(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}

Future<void> showWeatherNotification(String title, String body, int priority) async {
  print("📩 Отправляем уведомление: $title - $body");

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'weather_channel',
    'Weather Notifications',
    description: 'Канал для погодных уведомлений',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Регистрируем канал (для Android 8.0+)
  final AndroidFlutterLocalNotificationsPlugin? androidSettings =
  notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  await androidSettings?.createNotificationChannel(channel);

  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    importance: priority == 2 ? Importance.max : priority == 1 ? Importance.high : Importance.defaultImportance,
    priority: priority == 2 ? Priority.max : priority == 1 ? Priority.high : Priority.defaultPriority,
  );

  NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

  await notificationsPlugin.show(
    0, // Уникальный ID уведомления
    title,
    body,
    notificationDetails,
  );

  print("✅ Уведомление отправлено!");
}

