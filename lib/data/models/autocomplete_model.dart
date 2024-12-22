class AutocompleteModel {
  final List<Result>? results;

  AutocompleteModel({this.results});

  // Метод для преобразования из JSON
  factory AutocompleteModel.fromJson(Map<String, dynamic> json) {
    return AutocompleteModel(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'results': results?.map((e) => e.toJson()).toList(),
    };
  }
}

class Result {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final double? elevation;
  final String? featureCode;
  final String? countryCode;
  final int? admin1Id;
  final int? admin2Id;
  final int? admin3Id;
  final int? admin4Id;
  final String? timezone;
  final int? population;
  final List<String>? postcodes;
  final int? countryId;
  final String? country;
  final String? admin1;
  final String? admin2;
  final String? admin3;
  final String? admin4;

  Result({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.elevation,
    this.featureCode,
    this.countryCode,
    this.admin1Id,
    this.admin2Id,
    this.admin3Id,
    this.admin4Id,
    this.timezone,
    this.population,
    this.postcodes,
    this.countryId,
    this.country,
    this.admin1,
    this.admin2,
    this.admin3,
    this.admin4,
  });

  // Метод для преобразования из JSON
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'] as int?,
      name: json['name'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble(),
      featureCode: json['feature_code'] as String?,
      countryCode: json['country_code'] as String?,
      admin1Id: json['admin1_id'] as int?,
      admin2Id: json['admin2_id'] as int?,
      admin3Id: json['admin3_id'] as int?,
      admin4Id: json['admin4_id'] as int?,
      timezone: json['timezone'] as String?,
      population: json['population'] as int?,
      postcodes: (json['postcodes'] as List<dynamic>?)?.cast<String>(),
      countryId: json['country_id'] as int?,
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      admin2: json['admin2'] as String?,
      admin3: json['admin3'] as String?,
      admin4: json['admin4'] as String?,
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'feature_code': featureCode,
      'country_code': countryCode,
      'admin1_id': admin1Id,
      'admin2_id': admin2Id,
      'admin3_id': admin3Id,
      'admin4_id': admin4Id,
      'timezone': timezone,
      'population': population,
      'postcodes': postcodes,
      'country_id': countryId,
      'country': country,
      'admin1': admin1,
      'admin2': admin2,
      'admin3': admin3,
      'admin4': admin4,
    };
  }
}
