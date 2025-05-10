import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_assistant/config/api_keys.dart';

Future<Map<String, dynamic>> fetchGeoData(String text) async {
  var url = Uri.parse('https://geocoding-api.open-meteo'
      '.com/v1/search?name=${text}&count=10&language=ru&format=json');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw('Ошибка запроса: ${response.statusCode}.');
    }
  } catch (error) {
    throw('Ошибка: $error');
  }
}

