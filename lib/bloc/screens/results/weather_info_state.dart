part of 'weather_info_bloc.dart';

@immutable
sealed class WeatherInfoState {}

class WeatherInfoInitial extends WeatherInfoState {}

class WeatherInfoReceivedState extends WeatherInfoState {
  final WeatherResponse weatherModel;
  final bool isFavored;
  final WeatherForecast? weatherForecast;
  final String cityName;
  final WeatherResponse weatherForecast3days;

  WeatherInfoReceivedState({
    required this.weatherModel,
    required this.isFavored,
    this.weatherForecast,
    required this.cityName,
    required this.weatherForecast3days,
  });
}

class WeatherInfoLoadingState extends WeatherInfoState {}

class WeatherInfoErrorState extends WeatherInfoState {}
