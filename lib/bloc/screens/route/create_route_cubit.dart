import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:weather_assistant/data/models/weather_forecast.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/data/repositories/route_repository.dart';
import 'package:weather_assistant/data/repositories/weather_treatment.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/data/services/weather_request.dart';

part 'create_route_state.dart';

class CreateRouteCubit extends Cubit<CreateRouteState> {
  CreateRouteCubit() : super(CreateRouteLoading());
  final List<String> cityNames = [];
  final repository = getIt<RouteRepository>();

  void fetchLocations(List<LatLng> locs) async {
    emit(CreateRouteLoading());
    List<WeatherResponse> allLocs = [];
    for (final loc in locs) {
      final weather = processWeatherData(await fetchWeatherData(mapPoint: loc));
      allLocs.add(
        weather,
      );
      cityNames.add(weather.location?.name ?? '');
    }
    emit(CreateRouteDatePicker(allLocs));
  }

  Future<Map<String, dynamic>> createRoute(List<RoutePointDto> locs) async {
    emit(CreateRouteLoading());
    locs.sort((a, b) => a.arrivalDate.compareTo(b.arrivalDate));
    final routePoints = locs.map((point) {
      return RoutePointsCompanion(
        locationName: Value(point.locationName),
        latitude: Value(point.latitude),
        longitude: Value(point.longitude),
        arrivalDate: Value(point.arrivalDate),
      );
    }).toList();
    final route = repository.addRoute(fromLocsToName(locs), routePoints);
    return route;
  }

  Future<Map<String, dynamic>> editRoute(
      int routeId, List<RoutePointDto> locs) async {
    emit(CreateRouteLoading());
    locs.sort((a, b) => a.arrivalDate.compareTo(b.arrivalDate));
    final routePoints = locs.map((point) {
      return RoutePointsCompanion(
        locationName: Value(point.locationName),
        latitude: Value(point.latitude),
        longitude: Value(point.longitude),
        arrivalDate: Value(point.arrivalDate),
      );
    }).toList();
    final route = repository.editRoute(
        routeId, fromLocsToName(locs), routePoints);
    return route;
  }

}

String fromLocsToName(List<RoutePointDto> locs) {
  String name = '';
  for (final loc in locs) {
    name += '${loc.locationName}  ${loc == locs.last ? '' : '->'} ';
  }
  return name;
}

class RoutePointDto {
  final String locationName;
  final double latitude;
  final double longitude;
  final DateTime arrivalDate;

  RoutePointDto({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.arrivalDate,
  });
}
