import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:weather_assistant/config/api_keys.dart';
import 'package:weather_assistant/data/models/daily_weather.dart';
import 'package:weather_assistant/data/models/weather_forecast.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/ui/screens/notifs/storage/notification_settings_storage.dart';
import 'package:weather_assistant/ui/screens/notifs/weather_notifications_screen.dart';
import 'package:xml/xml.dart';

Future<Map<String, dynamic>> fetchWeatherData({LatLng? mapPoint, String? cityName}) async {
  try {
    final response = await http.get(
        Uri.parse(
            'https://weatherapi-com.p.rapidapi.com/current.json?q=${mapPoint != null ? '${mapPoint!.latitude}%2C${mapPoint!.longitude}' : cityName}&lang=ru'),
        headers: {
          'X-RapidAPI-Key': weatherApiKey,
          'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
        });
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception("Плохой статус");
    }
  } catch (ex) {
    debugPrint(ex.toString());
    throw Exception("Не удалось получить информацию");
  }
}

Future<Map<String, dynamic>> fetchWeatherForecast(LatLng mapPoint) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${mapPoint.latitude}&longitude=${mapPoint.longitude}&hourly=temperature_2m&&forecast_days=7'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Плохой статус");
    }
  } catch (ex) {
    debugPrint(ex.toString());
    throw Exception("Не удалось получить информацию");
  }
}

Future<List<DailyWeather>> fetchWeatherForRoute(List<RoutePoint> routePoints) async {
  final List<DailyWeather> weatherData = [];

  for (final point in routePoints) {
    final String formattedDate = point.arrivalDate.toIso8601String().split('T')[0];

    Uri url;
    // Проверяем, прошлая дата или будущая
    if (point.arrivalDate.isBefore(DateTime.now()) && point.arrivalDate.day != DateTime.now().day) {
      url = Uri.parse(
        'https://archive-api.open-meteo.com/v1/archive'
        '?latitude=${point.latitude}'
        '&longitude=${point.longitude}'
        '&start_date=$formattedDate'
        '&end_date=$formattedDate'
        '&timezone=Europe%2FMoscow'
        '&daily=precipitation_sum,wind_speed_10m_max,uv_index_max,precipitation_probability_max,'
        'temperature_2m_max,temperature_2m_min',
      );
    } else {
      url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=${point.latitude}'
        '&longitude=${point.longitude}'
        '&start_date=$formattedDate'
        '&end_date=$formattedDate'
        '&timezone=Europe%2FMoscow'
        '&daily=precipitation_sum,wind_speed_10m_max,uv_index_max,precipitation_probability_mean,'
        'temperature_2m_max,temperature_2m_min',
      );
    }

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);

        // Преобразуем данные из JSON в объект DailyWeather
        final List<DailyWeather> dailyData = DailyWeather.fromJsonList(
          apiResponse,
          point.locationName,
        );

        if (dailyData.isNotEmpty) {
          // Берём только первый объект, так как запрос для одной даты
          weatherData.add(dailyData.first);
        }
      } else {
        print("Ошибка загрузки данных для ${point.locationName}: ${response.statusCode}");
      }
    } catch (e) {
      print("Ошибка запроса для ${point.locationName}: $e");
    }
  }

  return weatherData;
}

Future<Map<String, dynamic>> fetchWeatherForecastByDays(
    String? city, LatLng? mapPoint, int days) async {
  try {
    final uri =  Uri.parse('https://api.weatherapi.com/v1/forecast'
        '.json?key=$forecastKey${mapPoint != null ? '&q=${mapPoint.latitude},${mapPoint
        .longitude}' : ''}&days=$days&aqi=no&alerts=no');
    final response = await http.get(uri,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Плохой статус");
    }
  } catch (ex) {
    debugPrint(ex.toString());
    throw Exception("Не удалось получить информацию");
  }
}

Future<Map<String, dynamic>> fetchWeatherDataByName(String city) async {
  try {
    final response = await http.get(
        Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?q=${city}&lang=ru'),
        headers: {
          'X-RapidAPI-Key': weatherApiKey,
          'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Плохой статус");
    }
  } catch (ex) {
    debugPrint(ex.toString());
    throw Exception("Не удалось получить информацию");
  }
}


Future<void> checkWeatherAndSendNotification() async {
  print("🔍 Проверяем погоду для уведомлений...");

  // Загружаем настройки уведомлений
  final settings = await NotificationSettingsStorage().loadSettings();

  // Определяем текущее время
  final now = DateTime.now();
  final bool isMorning = now.hour >= 6 && now.hour < 12; // 6:00 - 12:00
  final bool isEvening = now.hour >= 18 && now.hour < 23; // 18:00 - 23:00

  // Если выключены утренние и вечерние уведомления — ничего не делаем
  if (!settings.morningNotification && !settings.eveningNotification &&
      !settings.severeWeatherAlerts) {
    print("🚫 Все уведомления отключены пользователем.");
    return;
  }

  // Данные о местоположении (можно добавить реальные)
  double latitude = 55.75;
  double longitude = 37.61;

  // Запрос к Open-Meteo API
  final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,precipitation_sum&timezone=auto'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Получаем прогноз на завтра
    final maxTemp = data["daily"]["temperature_2m_max"][1];
    final precipitation = data["daily"]["precipitation_sum"][1];

    String message = "";
    int priority = 0;

    // Логика уведомлений
    if (settings.morningNotification && isMorning) {
      message = "Доброе утро! Сегодня будет ${maxTemp}°C. ";
      priority = 0;
      if (precipitation > 5) {
        message += "Ожидаются осадки, возьмите зонт! ☔";
        priority = 1;
      }
    }

    if (settings.eveningNotification && isEvening) {
      message = "Прогноз на завтра: ${maxTemp}°C. ";
      priority = 0;
      if (precipitation > 5) {
        message += "Ожидаются осадки, возьмите зонт! ☔";
        priority = 1;
      }
    }

    if (settings.severeWeatherAlerts && precipitation > 20) {
      message = "⚠ Внимание! Сильные осадки: ${precipitation} мм. Будьте осторожны!";
      priority = 2;
    }

    // Отправляем уведомление, если есть текст
    if (message.isNotEmpty) {
      await showWeatherNotification("Погодное уведомление", message, priority);
      print("✅ Уведомление отправлено: $message");
    } else {
      print("❌ Нет оснований для отправки уведомления.");
    }
  }
}

