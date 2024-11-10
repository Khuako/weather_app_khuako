import 'package:weather_assistant/data/models/weather_model.dart';

WeatherResponse processWeatherData(Map<String, dynamic> responseData) {

  return WeatherResponse.fromJson(responseData);
}