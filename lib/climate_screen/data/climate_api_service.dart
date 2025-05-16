import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:weather_assistant/config/api_keys.dart';
import '../model/climate_day_record_model.dart';

@LazySingleton()
class ClimateApiService {
  final String host = 'meteostat.p.rapidapi.com';

  ClimateApiService();
  Future<String?> getNearestStationId(double lat, double lon) async {
    final url = Uri.https(host, '/stations/nearby', {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });

    final response = await http.get(
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

    return data.first['id'] as String;
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

    final response = await http.get(
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
