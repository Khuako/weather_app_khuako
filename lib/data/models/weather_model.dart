class WeatherResponse {
  Location? location;
  CurrentWeather? current;
  Forecast? forecast;

  WeatherResponse({
    this.location,
    this.current,
    this.forecast,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      current: json['current'] != null ? CurrentWeather.fromJson(json['current']) : null,
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
    );
  }
}

class Location {
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? tzId;
  String? localtime;
  int? localtimeEpoch;

  Location({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localtime,
    this.localtimeEpoch,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      tzId: json['tz_id'],
      localtime: json['localtime'],
      localtimeEpoch: json['localtime_epoch'] as int?,
    );
  }
}

class CurrentWeather {
  double? tempC;
  double? tempF;
  int? isDay;
  Condition? condition;
  double? windMph;
  double? windKph;
  int? windDegree;
  String? windDir;
  double? pressureMb;
  double? pressureIn;
  double? precipMm;
  double? precipIn;
  int? humidity;
  int? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? windchillC;
  double? windchillF;
  double? heatindexC;
  double? heatindexF;
  double? dewpointC;
  double? dewpointF;
  double? visKm;
  double? visMiles;
  double? uv;
  double? gustMph;
  double? gustKph;
  int? timeEpoch;
  String? time;
  CurrentWeather({
    this.timeEpoch,
    this.time,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.windchillC,
    this.windchillF,
    this.heatindexC,
    this.heatindexF,
    this.dewpointC,
    this.dewpointF,
    this.visKm,
    this.visMiles,
    this.uv,
    this.gustMph,
    this.gustKph,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      timeEpoch: json['time_epoch'] as int?,
      time: json['time'] as String?,
      tempC: (json['temp_c'] as num?)?.toDouble(),
      tempF: (json['temp_f'] as num?)?.toDouble(),
      isDay: json['is_day'] as int?,
      condition: json['condition'] != null ? Condition.fromJson(json['condition']) : null,
      windMph: (json['wind_mph'] as num?)?.toDouble(),
      windKph: (json['wind_kph'] as num?)?.toDouble(),
      windDegree: json['wind_degree'] as int?,
      windDir: json['wind_dir'],
      pressureMb: (json['pressure_mb'] as num?)?.toDouble(),
      pressureIn: (json['pressure_in'] as num?)?.toDouble(),
      precipMm: (json['precip_mm'] as num?)?.toDouble(),
      precipIn: (json['precip_in'] as num?)?.toDouble(),
      humidity: json['humidity'] as int?,
      cloud: json['cloud'] as int?,
      feelslikeC: (json['feelslike_c'] as num?)?.toDouble(),
      feelslikeF: (json['feelslike_f'] as num?)?.toDouble(),
      windchillC: (json['windchill_c'] as num?)?.toDouble(),
      windchillF: (json['windchill_f'] as num?)?.toDouble(),
      heatindexC: (json['heatindex_c'] as num?)?.toDouble(),
      heatindexF: (json['heatindex_f'] as num?)?.toDouble(),
      dewpointC: (json['dewpoint_c'] as num?)?.toDouble(),
      dewpointF: (json['dewpoint_f'] as num?)?.toDouble(),
      visKm: (json['vis_km'] as num?)?.toDouble(),
      visMiles: (json['vis_miles'] as num?)?.toDouble(),
      uv: (json['uv'] as num?)?.toDouble(),
      gustMph: (json['gust_mph'] as num?)?.toDouble(),
      gustKph: (json['gust_kph'] as num?)?.toDouble(),
    );
  }
}

class Condition {
  int? code;
  String? text;
  String? icon;

  Condition({
    this.code,
    this.text,
    this.icon,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      code: json['code'] as int?,
      text: json['text'],
      icon: json['icon'],
    );
  }
}

class Forecast {
  List<ForecastDay>? forecastDay;

  Forecast({this.forecastDay});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastDay: (json['forecastday'] as List<dynamic>?)
          ?.map((day) => ForecastDay.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ForecastDay {
  String? date;
  int? dateEpoch;
  Day? day;
  List<CurrentWeather>? hour;

  ForecastDay({
    this.date,
    this.dateEpoch,
    this.day,
    this.hour,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      dateEpoch: json['date_epoch'] as int?,
      day: json['day'] != null ? Day.fromJson(json['day']) : null,
      hour: (json['hour'] as List<dynamic>?)
          ?.map((h) => CurrentWeather.fromJson(h as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Day {
  double? maxtempC;
  double? maxtempF;
  double? mintempC;
  double? mintempF;
  double? avgtempC;
  double? avgtempF;
  double? maxwindMph;
  double? maxwindKph;
  double? totalprecipMm;
  double? totalprecipIn;
  double? totalsnowCm;
  double? avgvisKm;
  double? avgvisMiles;
  int? avghumidity;
  int? dailyWillItRain;
  int? dailyChanceOfRain;
  int? dailyWillItSnow;
  int? dailyChanceOfSnow;
  Condition? condition;
  double? uv;

  Day({
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.avgtempC,
    this.avgtempF,
    this.maxwindMph,
    this.maxwindKph,
    this.totalprecipMm,
    this.totalprecipIn,
    this.totalsnowCm,
    this.avgvisKm,
    this.avgvisMiles,
    this.avghumidity,
    this.dailyWillItRain,
    this.dailyChanceOfRain,
    this.dailyWillItSnow,
    this.dailyChanceOfSnow,
    this.condition,
    this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: (json['maxtemp_c'] as num?)?.toDouble(),
      maxtempF: (json['maxtemp_f'] as num?)?.toDouble(),
      mintempC: (json['mintemp_c'] as num?)?.toDouble(),
      mintempF: (json['mintemp_f'] as num?)?.toDouble(),
      avgtempC: (json['avgtemp_c'] as num?)?.toDouble(),
      avgtempF: (json['avgtemp_f'] as num?)?.toDouble(),
      maxwindMph: (json['maxwind_mph'] as num?)?.toDouble(),
      maxwindKph: (json['maxwind_kph'] as num?)?.toDouble(),
      totalprecipMm: (json['totalprecip_mm'] as num?)?.toDouble(),
      totalprecipIn: (json['totalprecip_in'] as num?)?.toDouble(),
      totalsnowCm: (json['totalsnow_cm'] as num?)?.toDouble(),
      avgvisKm: (json['avgvis_km'] as num?)?.toDouble(),
      avgvisMiles: (json['avgvis_miles'] as num?)?.toDouble(),
      avghumidity: json['avghumidity'] as int?,
      dailyWillItRain: json['daily_will_it_rain'] as int?,
      dailyChanceOfRain: json['daily_chance_of_rain'] as int?,
      dailyWillItSnow: json['daily_will_it_snow'] as int?,
      dailyChanceOfSnow: json['daily_chance_of_snow'] as int?,
      condition: json['condition'] != null ? Condition.fromJson(json['condition']) : null,
      uv: (json['uv'] as num?)?.toDouble(),
    );
  }
}

class Hour {
  int? timeEpoch;
  String? time;
  double? tempC;
  double? tempF;
  int? isDay;
  Condition? condition;
  double? windMph;
  double? windKph;
  int? windDegree;
  String? windDir;
  double? pressureMb;
  double? pressureIn;
  double? precipMm;
  double? precipIn;
  double? snowCm;
  int? humidity;
  int? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? windchillC;
  double? windchillF;
  double? heatindexC;
  double? heatindexF;
  double? dewpointC;
  double? dewpointF;
  int? willItRain;
  int? chanceOfRain;
  int? willItSnow;
  int? chanceOfSnow;
  double? visKm;
  double? visMiles;
  double? gustMph;
  double? gustKph;
  int? uv;

  Hour({
    this.timeEpoch,
    this.time,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.snowCm,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.windchillC,
    this.windchillF,
    this.heatindexC,
    this.heatindexF,
    this.dewpointC,
    this.dewpointF,
    this.willItRain,
    this.chanceOfRain,
    this.willItSnow,
    this.chanceOfSnow,
    this.visKm,
    this.visMiles,
    this.gustMph,
    this.gustKph,
    this.uv,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      timeEpoch: json['time_epoch'] as int?,
      time: json['time'],
      tempC: (json['temp_c'] as num?)?.toDouble(),
      tempF: (json['temp_f'] as num?)?.toDouble(),
      isDay: json['is_day'] as int?,
      condition: json['condition'] != null ? Condition.fromJson(json['condition']) : null,
      windMph: (json['wind_mph'] as num?)?.toDouble(),
      windKph: (json['wind_kph'] as num?)?.toDouble(),
      windDegree: json['wind_degree'] as int?,
      windDir: json['wind_dir'],
      pressureMb: (json['pressure_mb'] as num?)?.toDouble(),
      pressureIn: (json['pressure_in'] as num?)?.toDouble(),
      precipMm: (json['precip_mm'] as num?)?.toDouble(),
      precipIn: (json['precip_in'] as num?)?.toDouble(),
      snowCm: (json['snow_cm'] as num?)?.toDouble(),
      humidity: json['humidity'] as int?,
      cloud: json['cloud'] as int?,
      feelslikeC: (json['feelslike_c'] as num?)?.toDouble(),
      feelslikeF: (json['feelslike_f'] as num?)?.toDouble(),
      windchillC: (json['windchill_c'] as num?)?.toDouble(),
      windchillF: (json['windchill_f'] as num?)?.toDouble(),
      heatindexC: (json['heatindex_c'] as num?)?.toDouble(),
      heatindexF: (json['heatindex_f'] as num?)?.toDouble(),
      dewpointC: (json['dewpoint_c'] as num?)?.toDouble(),
      dewpointF: (json['dewpoint_f'] as num?)?.toDouble(),
      willItRain: json['will_it_rain'] as int?,
      chanceOfRain: json['chance_of_rain'] as int?,
      willItSnow: json['will_it_snow'] as int?,
      chanceOfSnow: json['chance_of_snow'] as int?,
      visKm: (json['vis_km'] as num?)?.toDouble(),
      visMiles: (json['vis_miles'] as num?)?.toDouble(),
      gustMph: (json['gust_mph'] as num?)?.toDouble(),
      gustKph: (json['gust_kph'] as num?)?.toDouble(),
      uv: json['uv'] as int?,
    );
  }
}

WeatherResponse mapOpenWeather(Map<String, dynamic> src) {
  // 1. location
  final loc = Location(
    name: src['city']?['name'],
    country: src['city']?['country'],
    lat: (src['city']?['coord']?['lat'] as num?)?.toDouble(),
    lon: (src['city']?['coord']?['lon'] as num?)?.toDouble(),
    localtimeEpoch: src['list']?[0]?['dt'] as int?,
    localtime:
        DateTime.fromMillisecondsSinceEpoch((src['list']?[0]?['dt'] as int?)! * 1000, isUtc: true)
            .toLocal()
            .toIso8601String(),
  );

  // 2. current — берём первый элемент списка
  final first = src['list'][0];
  final cur = CurrentWeather(
    tempC: (first['main']?['temp'] as num?)?.toDouble(),
    feelslikeC: (first['main']?['feels_like'] as num?)?.toDouble(),
    humidity: first['main']?['humidity'] as int?,
    windKph: (first['wind']?['speed'] as num?)?.toDouble(),
    condition: Condition(
      text: first['weather']?[0]?['description'],
      icon: 'https://openweathermap.org/img/wn/${first['weather']?[0]?['icon']}@2x.png',
      code: first['weather']?[0]?['id'] as int?,
    ),
  );

  // 3. forecast на 3 дня — группируем list по дате
  final Map<String, List<dynamic>> byDay = {};
  for (final item in src['list']) {
    final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000, isUtc: true)
        .toLocal()
        .toIso8601String()
        .substring(0, 10); // YYYY-MM-DD
    byDay.putIfAbsent(date, () => []).add(item);
  }

  final forecastDays = byDay.entries.take(3).map((e) {
    final dayItems = e.value;

    // средние и экстремумы за день
    final temps = dayItems.map<double>((x) => (x['main']['temp'] as num).toDouble()).toList();
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final avgTemp = temps.reduce((a, b) => a + b) / temps.length;

    return ForecastDay(
      date: e.key,
      day: Day(
        maxtempC: maxTemp,
        mintempC: minTemp,
        avgtempC: avgTemp,
        condition: Condition(
          text: dayItems[0]['weather']?[0]?['description'],
          icon: 'https://openweathermap.org/img/wn/${dayItems[0]['weather']?[0]?['icon']}@2x.png',
          code: dayItems[0]['weather']?[0]?['id'] as int?,
        ),
      ),
      hour: dayItems.map((h) {
        final t = DateTime.fromMillisecondsSinceEpoch(h['dt'] * 1000, isUtc: true).toLocal();
        return CurrentWeather(
          timeEpoch: h['dt'] as int?,
          time: t.toIso8601String(),
          tempC: (h['main']['temp'] as num).toDouble(),
          condition: Condition(
            text: h['weather']?[0]?['description'],
            icon: 'https://openweathermap.org/img/wn/${h['weather']?[0]?['icon']}@2x.png',
            code: h['weather']?[0]?['id'] as int?,
          ),
          windKph: (h['wind']?['speed'] as num?)?.toDouble(),
          humidity: h['main']?['humidity'] as int?,
        );
      }).toList(),
    );
  }).toList();

  return WeatherResponse(
    location: loc,
    current: cur,
    forecast: Forecast(forecastDay: forecastDays),
  );
}
