import 'package:drift/drift.dart';
import 'package:weather_assistant/data/services/local_database.dart';

class ClimateDayRecordModel {
  final String cityId;
  final DateTime date;
  final double? tempMin;
  final double? tempMax;
  final double? tempAvg;
  final double? precipitation;

  ClimateDayRecordModel({
    required this.cityId,
    required this.date,
    this.tempMin,
    this.tempMax,
    this.tempAvg,
    this.precipitation,
  });

  ClimateDayRecordsCompanion toCompanion() {
    return ClimateDayRecordsCompanion(
      cityId: Value(cityId),
      date: Value(date),
      tempMin: Value(tempMin),
      tempMax: Value(tempMax),
      tempAvg: Value(tempAvg),
      precipitation: Value(precipitation),
    );
  }

  factory ClimateDayRecordModel.fromJson(String cityId, Map<String, dynamic> json) {
    return ClimateDayRecordModel(
      cityId: cityId,
      date: DateTime.parse(json['date']), // ← тут ключ `date`, не `month`
      tempMin: (json['tmin'] as num?)?.toDouble(),
      tempMax: (json['tmax'] as num?)?.toDouble(),
      tempAvg: (json['tavg'] as num?)?.toDouble(),
      precipitation: (json['prcp'] as num?)?.toDouble(),
    );
  }
}
