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
  WeatherForecast copyWith({
    double? latitude,
    double? longitude,
    double? elevation,
    double? generationTimeMs,
    int? utcOffsetSeconds,
    String? timezone,
    String? timezoneAbbreviation,
    HourlyData? hourly,
    HourlyUnits? hourlyUnits,
  }) {
    return WeatherForecast(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      elevation: elevation ?? this.elevation,
      generationTimeMs: generationTimeMs ?? this.generationTimeMs,
      utcOffsetSeconds: utcOffsetSeconds ?? this.utcOffsetSeconds,
      timezone: timezone ?? this.timezone,
      timezoneAbbreviation: timezoneAbbreviation ?? this.timezoneAbbreviation,
      hourly: hourly ?? this.hourly,
      hourlyUnits: hourlyUnits ?? this.hourlyUnits,
    );
  }
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
  final List<double>? precipitationSum;
  final List<double>? rainSum;
  final List<double>? snowfallSum;
  final List<int>? precipitationProbability;

  HourlyData({
    required this.time,
    required this.temperature2m,
    this.precipitationSum,
    this.rainSum,
    this.snowfallSum,
    this.precipitationProbability,
  });

  // Метод для преобразования из JSON
  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return HourlyData(
      time: List<String>.from(json['time']),
      temperature2m: List<double>.from(json['temperature_2m']),
      precipitationSum: json['precipitation_sum'] != null
          ? List<double>.from(json['precipitation_sum'])
          : null,
      rainSum: json['rain_sum'] != null
          ? List<double>.from(json['rain_sum'])
          : null,
      snowfallSum: json['snowfall_sum'] != null
          ? List<double>.from(json['snowfall_sum'])
          : null,
      precipitationProbability: json['precipitation_probability'] != null
          ? List<int>.from(json['precipitation_probability'])
          : null,
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature2m,
      if (precipitationSum != null) 'precipitation_sum': precipitationSum,
      if (rainSum != null) 'rain_sum': rainSum,
      if (snowfallSum != null) 'snowfall_sum': snowfallSum,
      if (precipitationProbability != null)
        'precipitation_probability': precipitationProbability,
    };
  }
}

class HourlyUnits {
  final String temperature2m;
  final String? precipitationSum;
  final String? rainSum;
  final String? snowfallSum;
  final String? precipitationProbability;

  HourlyUnits({
    required this.temperature2m,
    this.precipitationSum,
    this.rainSum,
    this.snowfallSum,
    this.precipitationProbability,
  });

  // Метод для преобразования из JSON
  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return HourlyUnits(
      temperature2m: json['temperature_2m'],
      precipitationSum: json['precipitation_sum'],
      rainSum: json['rain_sum'],
      snowfallSum: json['snowfall_sum'],
      precipitationProbability: json['precipitation_probability'],
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'temperature_2m': temperature2m,
      if (precipitationSum != null) 'precipitation_sum': precipitationSum,
      if (rainSum != null) 'rain_sum': rainSum,
      if (snowfallSum != null) 'snowfall_sum': snowfallSum,
      if (precipitationProbability != null)
        'precipitation_probability': precipitationProbability,
    };
  }
}
