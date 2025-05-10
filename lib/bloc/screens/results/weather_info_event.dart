part of 'weather_info_bloc.dart';

@immutable
sealed class WeatherInfoEvent {}

class GetWeatherInfoEvent extends WeatherInfoEvent {
  final LatLng? mapPoint;
  final String? cityName;
  GetWeatherInfoEvent({this.mapPoint, this.cityName});
}
