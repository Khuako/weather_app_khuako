import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:weather_assistant/config/api_keys.dart';

Future<Map<String, dynamic>> fetchWeatherData(LatLng mapPoint) async {
  try {
    final response = await http.get(
        Uri.parse(
            'https://weatherapi-com.p.rapidapi.com/current.json?q=${mapPoint.latitude}%2C${mapPoint
                .longitude}'),
        headers: {
          'X-RapidAPI-Key':
          weatherApiKey,
          'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
        });
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    }
    else{
      throw Exception("Плохой статус");
    }
  } catch(ex) {
    debugPrint(ex.toString());
    throw Exception("Не удалось получить информацию");
  }
}
Future<Map<String, dynamic>> fetchWeatherDataByName(String city) async {
  try {
    final response = await http.get(
        Uri.parse(
            'https://open-weather13.p.rapidapi.com/city/${city}/RU'),
        headers: {
          'X-RapidAPI-Key':
          weatherApiKey,
          'X-RapidAPI-Host': 'open-weather13.p.rapidapi.com',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else{
      throw Exception("Плохой статус");
    }
  } catch(ex) {
    debugPrint(ex.toString());
    throw Exception("Не удалось получить информацию");
  }
}