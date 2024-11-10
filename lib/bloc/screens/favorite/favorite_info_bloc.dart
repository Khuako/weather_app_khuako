import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/data/repositories/weather_treatment.dart';
import 'package:weather_assistant/data/services/local_bd.dart';

import '../../../data/services/weather_request.dart';

part 'favorite_info_event.dart';

part 'favorite_info_state.dart';

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
      for (String city in cities) {
        final weather = await fetchWeatherDataByName(city);
        weathers.add(processWeatherData(weather));
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
}
