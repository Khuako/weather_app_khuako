import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_assistant/data/models/daily_weather.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/data/services/weather_request.dart';

part 'route_detail_state.dart';

class RouteDetailCubit extends Cubit<RouteDetailState> {
  RouteDetailCubit() : super(RouteDetailLoading());

  void getRoute(List<RoutePoint> points) async {
    emit(RouteDetailLoading());
    final routes = await fetchWeatherForRoute(points);
    emit(RouteDetailInfo(routes));
  }
}
