part of 'change_map_bloc.dart';

@immutable
class ChangeMapEvent {
  final LatLng mapCenter;

  const ChangeMapEvent({required this.mapCenter});
}
