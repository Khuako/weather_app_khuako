part of 'route_detail_cubit.dart';

sealed class RouteDetailState {}

final class RouteDetailLoading extends RouteDetailState {
}
final class RouteDetailInfo extends RouteDetailState {
  final List<DailyWeather> dailyWeather;
  RouteDetailInfo(this.dailyWeather);
}
