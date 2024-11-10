class WeatherResponse {
  Location location;
  CurrentWeather current;

  WeatherResponse({required this.location, required this.current});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
    );
  }
}

class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  String localtime;
  int localtimeEpoch;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtime,
    required this.localtimeEpoch,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      tzId: json['tz_id'],
      localtime: json['localtime'],
      localtimeEpoch: json['localtime_epoch'],
    );
  }
}

class CurrentWeather {
  double tempC;
  double tempF;
  int isDay;
  Condition condition;
  double windMph;
  double windKph;
  num windDegree; // Изменено с int на num
  String windDir;
  num pressureMb; // Изменено с int на num
  double pressureIn;
  double precipMm;
  double precipIn;
  int humidity;
  int cloud;
  double feelslikeC;
  double feelslikeF;
  double windchillC;
  double windchillF;
  double heatindexC;
  double heatindexF;
  double dewpointC;
  double dewpointF;
  double visKm;
  double visMiles;
  num uv; // Изменено с int на num
  double gustMph;
  double gustKph;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      isDay: json['is_day'],
      condition: Condition.fromJson(json['condition']),
      windMph: json['wind_mph'].toDouble(),
      windKph: json['wind_kph'].toDouble(),
      windDegree: json['wind_degree'] is int ? json['wind_degree'] : (json['wind_degree'] as double).toInt(),
      windDir: json['wind_dir'],
      pressureMb: json['pressure_mb'],
      pressureIn: json['pressure_in'].toDouble(),
      precipMm: json['precip_mm'].toDouble(),
      precipIn: json['precip_in'].toDouble(),
      humidity: json['humidity'],
      cloud: json['cloud'],
      feelslikeC: json['feelslike_c'].toDouble(),
      feelslikeF: json['feelslike_f'].toDouble(),
      windchillC: json['windchill_c'].toDouble(),
      windchillF: json['windchill_f'].toDouble(),
      heatindexC: json['heatindex_c'].toDouble(),
      heatindexF: json['heatindex_f'].toDouble(),
      dewpointC: json['dewpoint_c'].toDouble(),
      dewpointF: json['dewpoint_f'].toDouble(),
      visKm: json['vis_km'].toDouble(),
      visMiles: json['vis_miles'].toDouble(),
      uv: json['uv'],
      gustMph: json['gust_mph'].toDouble(),
      gustKph: json['gust_kph'].toDouble(),
    );
  }
}

class Condition {
  int code;
  String text;
  String icon;

  Condition({required this.code, required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      code: json['code'],
      text: json['text'],
      icon: json['icon'],
    );
  }
}
