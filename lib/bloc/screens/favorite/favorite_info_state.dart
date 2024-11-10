part of 'favorite_info_bloc.dart';

@immutable
sealed class FavoriteInfoState {}

final class FavLoading extends FavoriteInfoState {}
final class FavSuccess extends FavoriteInfoState {
  List<WeatherResponse> cities;
  FavSuccess(this.cities);
}
final class FavError extends FavoriteInfoState {
  final String error;
  FavError(this.error);
}