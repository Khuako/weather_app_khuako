part of 'create_route_cubit.dart';

sealed class CreateRouteState {}

final class CreateRouteLoading extends CreateRouteState {}

final class CreateRouteDatePicker extends CreateRouteState {
  List<WeatherResponse> allLocations;

  CreateRouteDatePicker(this.allLocations);
}
