part of 'change_map_bloc.dart';

@immutable
abstract class ChangeMapState {}

class ChangeMapInitial extends ChangeMapState {}

class ChangeMapCenter extends ChangeMapState {
  final LatLng mapCenter;

  ChangeMapCenter({required this.mapCenter});
}
