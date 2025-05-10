import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_assistant/data/models/location_info_model.dart';
import 'package:weather_assistant/data/models/weather_forecast.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/data/repositories/weather_treatment.dart';
import 'package:weather_assistant/data/services/local_bd.dart';
import 'package:weather_assistant/data/services/weather_request.dart';

part 'weather_info_event.dart';

part 'weather_info_state.dart';

class WeatherInfoBloc extends Bloc<WeatherInfoEvent, WeatherInfoState> {
  WeatherInfoBloc() : super(WeatherInfoInitial()) {
    on<GetWeatherInfoEvent>((event, emit) async {
      try {
        const String favKey = 'favorites';
        final bd = LocalBd(await SharedPreferences.getInstance());
        WeatherForecast? forecast;
        emit(WeatherInfoLoadingState());
        late WeatherResponse data;
        bool? isFavored;
        data = processWeatherData(
          await fetchWeatherData(
            mapPoint: event.mapPoint,
            cityName: event.cityName,
          ),
        );
        // forecast = WeatherForecast.fromJson(await fetchWeatherForecast(event.mapPoint!));
        final favs = await bd.read(favKey);
        final cityName = data.location?.name ?? '';
        isFavored = (favs ?? []).contains(cityName);
        final forecast3days = await fetchWeatherForecastByDays(
          null,
          LatLng(
            data.location?.lat ?? 0,
            data.location?.lon ?? 0,
          ),
          3,
        );
        emit(
          WeatherInfoReceivedState(
            weatherModel: data,
            isFavored: isFavored ?? false,
            weatherForecast: forecast,
            weatherForecast3days: WeatherResponse.fromJson(forecast3days),
            cityName: cityName,
          ),
        );
      } catch (ex) {
        debugPrint(ex.toString());
      }

    });
  }
}
