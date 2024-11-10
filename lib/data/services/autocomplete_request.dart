import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_assistant/config/api_keys.dart';

Future<Map<String, dynamic>> fetchGeoData(String text) async {
  var url = Uri.parse('https://api.geoapify.com/v1/geocode/autocomplete?text=$text&apiKey=$mapApiKey');
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

