import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/data/models/autocomplete_model.dart';
import 'package:weather_assistant/data/repositories/autocomplete_treatment.dart';
import 'package:weather_assistant/data/services/autocomplete_request.dart';

part 'search_info_event.dart';
part 'search_info_state.dart';

class SearchInfoBloc extends Bloc<SearchInfoEvent, SearchInfoState> {
  LatLng mapPoint = const LatLng(55.748886, 37.617209);
  String text = "";

  SearchInfoBloc() : super(SearchInfoInitial()) {
    on<TextControllerEvent>((event, emit) async {
      text = event.text;
      emit(SearchInfoLoading());
      if (text.isNotEmpty && text.length>2) {
        var data = await fetchGeoData(text);
        if (data.isNotEmpty) {
          var result = processAutocompleteData(data);
          if (result.isNotEmpty) {
            emit(SearchInfoFetched(autocompleteList: result));
          }
        }
      }
    });
  }
}