part of 'weather_info_bloc.dart';

@immutable
sealed class WeatherInfoState {}

class WeatherInfoInitial extends WeatherInfoState {}

class WeatherInfoReceivedState extends WeatherInfoState {
  final WeatherResponse weatherModel;

  WeatherInfoReceivedState({required this.weatherModel});
}
class WeatherInfoLoadingState extends WeatherInfoState {}
class WeatherInfoErrorState extends WeatherInfoState {}
