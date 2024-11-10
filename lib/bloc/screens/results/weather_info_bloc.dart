import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/data/repositories/weather_treatment.dart';
import 'package:weather_assistant/data/services/weather_request.dart';

part 'weather_info_event.dart';
part 'weather_info_state.dart';

class WeatherInfoBloc extends Bloc<WeatherInfoEvent, WeatherInfoState> {
  WeatherInfoBloc() : super(WeatherInfoInitial()) {
    on<GetWeatherInfoEvent>((event, emit) async {
      try{
        emit(WeatherInfoLoadingState());
        var data = await fetchWeatherData(event.mapPoint);
        if (data.isNotEmpty){
          emit(WeatherInfoReceivedState(weatherModel: processWeatherData(data)));
        }
      }catch(ex){
        debugPrint(ex.toString());
      }
    });
  }
}
