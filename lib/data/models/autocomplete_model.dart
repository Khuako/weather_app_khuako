class AutocompleteModel {
  String? country;
  String? countryCode;
  String? state;
  String? city;
  String? postcode;
  String? latitude;
  String? longitude;

  AutocompleteModel.fromJson(Map<String, dynamic> json) {
    country = json.containsKey('country') ? json['country'] as String : '';
    countryCode = json.containsKey('country_code') ? json['country_code'] as String : '';
    state = json.containsKey('state') ? json['state'] as String : '';
    city = json.containsKey('city') ? json['city'] as String : '';
    latitude = json.containsKey('latitude') ? json['latitude'].toString() : '';
    longitude = json.containsKey('longitude') ? json['longitude'].toString() : '';
  }
}