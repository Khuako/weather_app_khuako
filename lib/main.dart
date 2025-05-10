import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/app.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'package:weather_assistant/config/config.dart';
import 'package:intl/intl.dart';
import 'package:weather_assistant/data/repositories/route_repository.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:weather_assistant/data/services/weather_request.dart';
import 'package:weather_assistant/ui/screens/search_screen.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  tz.initializeTimeZones();
  scheduleWeatherCheck();
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  final loc = await getCurrentLocation();

  await notificationsPlugin.initialize(initSettings);
  await initDepends();
  runApp(
    WeatherAssistantApp(
      loc: loc == null ? constMapPoint : LatLng(loc.latitude, loc.longitude),
    ),
  );
}

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Проверка включения сервисов геолокации
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("Геолокация отключена.");
    return null;
  }

  // Проверка разрешений
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Пользователь отклонил доступ к геолокации.");
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("Геолокация запрещена навсегда.");
    return null;
  }

  // Получение текущих координат
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<void> initDepends() async {
  configureDependencies();
  getIt.get<FavoriteInfoBloc>();
  getIt.get<RouteRepository>();
  getIt.get<LocalDatabase>();
  getIt.get<AllRoutesCubit>();
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Фоновая задача: $task");
    if (task == "check_weather") {
      await checkWeatherAndSendNotification();
    }
    return Future.value(true);
  });
}

void scheduleWeatherCheck() {
  Workmanager().registerPeriodicTask(
    "daily_weather_check",
    "check_weather",
    frequency: const Duration(hours: 12), // Утром и вечером
  );
}
