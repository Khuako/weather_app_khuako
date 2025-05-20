import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:weather_assistant/config/api_keys.dart';
import 'package:weather_assistant/data/services/http_utils.dart';
import '../model/climate_day_record_model.dart';

@LazySingleton()
class ClimateApiService {
  final String host = 'meteostat.p.rapidapi.com';

  // In-memory кеш для stationId
  final Map<String, String> _stationCache = {};

  ClimateApiService();
  Future<String?> getNearestStationId(double lat, double lon) async {
    final key = '${lat.toStringAsFixed(4)}_${lon.toStringAsFixed(4)}';
    if (_stationCache.containsKey(key)) {
      return _stationCache[key];
    }

    final url = Uri.https(host, '/stations/nearby', {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });

    final response = await retryGet(
      url,
      headers: {
        'X-RapidAPI-Key': meteostatKey,
        'X-RapidAPI-Host': host,
      },
    );

    if (response.statusCode != 200) {
      print('Ошибка получения станции: ${response.body}');
      return null;
    }

    final data = jsonDecode(response.body)['data'] as List;
    if (data.isEmpty) return null;

    final stationId = data.first['id'] as String;
    _stationCache[key] = stationId;
    return stationId;
  }

  Future<List<ClimateDayRecordModel>> fetchMonthlyClimateByStation({
    required String cityId,
    required String stationId,
    required String start,
    required String end,
  }) async {
    final url = Uri.https(host, '/stations/monthly', {
      'station': stationId,
      'start': start,
      'end': end,
    });

    final response = await retryGet(
      url,
      headers: {
        'X-RapidAPI-Key': meteostatKey,
        'X-RapidAPI-Host': host,
      },
    );

    if (response.statusCode != 200) {
      print('Ошибка загрузки: ${response.body}');
      throw Exception('Ошибка: ${response.statusCode}');
    }

    final data = jsonDecode(response.body)['data'] as List;
    return data.map((json) {
      return ClimateDayRecordModel.fromJson(cityId, json);
    }).toList();
  }
}
