part of 'weather_info_bloc.dart';

@immutable
sealed class WeatherInfoEvent {}

class GetWeatherInfoEvent extends WeatherInfoEvent{
  final LatLng mapPoint;

  GetWeatherInfoEvent({required this.mapPoint});
}
