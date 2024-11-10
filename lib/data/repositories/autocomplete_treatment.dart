import 'package:weather_assistant/data/models/autocomplete_model.dart';

List<AutocompleteModel> processAutocompleteData(Map<String, dynamic> responseData) {
  List<AutocompleteModel> resultList = [];

  if (responseData.containsKey('features')) {
    List<dynamic> features = responseData['features'];
    for (var feature in features) {
      Map<String, dynamic> featureData = {};
      featureData['country'] = feature['properties']['country'] ?? '';
      featureData['country_code'] = feature['properties']['country_code'] ?? '';
      featureData['state'] = feature['properties']['state'] ?? '';
      featureData['city'] = feature['properties']['city'] ?? '';
      featureData['postcode'] = feature['properties']['postcode'] ?? '';
      featureData['latitude'] = feature['geometry']['coordinates'][1] ?? 0.0;
      featureData['longitude'] = feature['geometry']['coordinates'][0] ?? 0.0;

      resultList.add(AutocompleteModel.fromJson(featureData));
    }
  }

  return resultList;
}