class WeatherForecast {
  final double latitude;
  final double longitude;
  final double elevation;
  final double generationTimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final HourlyData hourly;
  final HourlyUnits hourlyUnits;

  WeatherForecast({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.generationTimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.hourly,
    required this.hourlyUnits,
  });

  // Метод для преобразования из JSON
  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      latitude: json['latitude'],
      longitude: json['longitude'],
      elevation: json['elevation'],
      generationTimeMs: json['generationtime_ms'],
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      hourly: HourlyData.fromJson(json['hourly']),
      hourlyUnits: HourlyUnits.fromJson(json['hourly_units']),
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'generationtime_ms': generationTimeMs,
      'utc_offset_seconds': utcOffsetSeconds,
      'timezone': timezone,
      'timezone_abbreviation': timezoneAbbreviation,
      'hourly': hourly.toJson(),
      'hourly_units': hourlyUnits.toJson(),
    };
  }
}

class HourlyData {
  final List<String> time;
  final List<double> temperature2m;

  HourlyData({
    required this.time,
    required this.temperature2m,
  });

  // Метод для преобразования из JSON
  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return HourlyData(
      time: List<String>.from(json['time']),
      temperature2m: List<double>.from(json['temperature_2m']),
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature2m,
    };
  }
}

class HourlyUnits {
  final String temperature2m;

  HourlyUnits({required this.temperature2m});

  // Метод для преобразования из JSON
  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return HourlyUnits(
      temperature2m: json['temperature_2m'],
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'temperature_2m': temperature2m,
    };
  }
}
