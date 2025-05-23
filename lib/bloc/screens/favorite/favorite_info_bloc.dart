import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/data/repositories/weather_treatment.dart';
import 'package:weather_assistant/data/services/local_bd.dart';

import '../../../data/services/weather_request.dart';

part 'favorite_info_state.dart';
@LazySingleton()
class FavoriteInfoBloc extends Cubit<FavoriteInfoState> {
  FavoriteInfoBloc() : super(FavLoading());
  final String favKey = 'favorites';
  List<WeatherResponse> weathers = [];
  List<String> cityNames = [];
  Future<void> getFavCities() async {
    emit(FavLoading());
    try {
      final bd = LocalBd(await SharedPreferences.getInstance());
      final cities = await bd.read(favKey);
      if(cities != null) {
        weathers.clear();
        cityNames.clear();
        for (int i = 0; i < cities.length; i++) {
          final weather = await fetchWeatherData(cityName: cities[i]);
          weathers.add(processWeatherData(weather));
          cityNames.add(cities[i]);
        }
      }
      emit(FavSuccess(weathers));
    } catch (e) {
      emit(FavError(e.toString()));
    }
  }
  Future<void> addCity(String city) async {
    emit(FavLoading());
    try {
      final bd = LocalBd(await SharedPreferences.getInstance());
      cityNames.add(city);
      await bd.write(favKey, cityNames);
      await getFavCities();
    } catch (e) {
      emit(FavError(e.toString()));
    }
  }
  Future<void> deleteCity(String city) async {
    emit(FavLoading());
    try {
      final bd = LocalBd(await SharedPreferences.getInstance());
      cityNames.remove(city);
      await bd.write(favKey, cityNames);
      await getFavCities();
    } catch (e) {
      emit(FavError(e.toString()));
    }
  }
}
List<String> decodeCoords(String code){
  return code.split(',');
}
String encodeCoords(double lat, double lon){
  return '$lat,$lon';
}