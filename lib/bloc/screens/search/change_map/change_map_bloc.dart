import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'change_map_event.dart';
part 'change_map_state.dart';

class ChangeMapBloc extends Bloc<ChangeMapEvent, ChangeMapState> {
  ChangeMapBloc() : super(ChangeMapInitial()) {
    on<ChangeMapEvent>((event, emit) {
      emit(ChangeMapCenter(mapCenter: event.mapCenter));
    });
  }
}
