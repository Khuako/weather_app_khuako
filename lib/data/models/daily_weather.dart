class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final double precipitation; // Осадки (мм)
  final double? wind; // Дождь (мм)
  final double? uv;
  final int precipitationProbability; // Вероятность осадков (%)
  final String name;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
    required this.wind,
    required this.uv,
    required this.precipitationProbability,
    required this.name,
  });

  /// Метод для преобразования из JSON (для daily погоды)
  factory DailyWeather.fromJson(Map<String, dynamic> json, int index, String name) {
    final List<String> time = List<String>.from(json['daily']['time']);
    final List<double> maxTemps = List<double>.from(json['daily']['temperature_2m_max']);
    final List<double> minTemps = List<double>.from(json['daily']['temperature_2m_min']);
    final List<double>? precipitation = json['daily']['precipitation_sum'] != null
        ? List<double>.from(json['daily']['precipitation_sum'])
        : null;
    final List<double>? wind =
        json['daily']['wind_speed_10m_max'] != null ? List<double>.from(json['daily']['wind_speed_10m_max']) : null;
    final List<double?>? uv = json['daily']['uv_index_max'] != null
        ? List<double?>.from(json['daily']['uv_index_max'])
        : null;
    final List<int>? precipitationProbability =
        json['daily']['precipitation_probability_mean'] != null
            ? List<int>.from(json['daily']['precipitation_probability_mean'])
            : null;
    return DailyWeather(
      name: name,
      date: DateTime.parse(time[index]),
      maxTemp: maxTemps[index],
      minTemp: minTemps[index],
      precipitation: precipitation != null ? precipitation[index] : 0.0,
      wind: wind != null ? wind[index] : null,
      uv: uv != null ? uv[index] ?? null : null,
      precipitationProbability:
          precipitationProbability != null ? precipitationProbability[index] : 0,
    );
  }

  /// Метод для преобразования списка из JSON
  static List<DailyWeather> fromJsonList(Map<String, dynamic> json, String name) {
    final int length = (json['daily']['time'] as List).length;
    return List.generate(length, (index) => DailyWeather.fromJson(json, index, name));
  }

  /// Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'precipitation': precipitation,
      'rain': wind,
      'uv': uv,
      'precipitationProbability': precipitationProbability,
    };
  }
}
