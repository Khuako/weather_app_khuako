import 'package:drift/drift.dart';
import 'package:weather_assistant/data/services/local_database.dart';

class ClimateDayRecordModel {
  final String cityId;
  final String month;
  final String year;
  final double? tempMin;
  final double? tempMax;
  final double? tempAvg;
  final double? precipitation;

  ClimateDayRecordModel({
    required this.cityId,
    required this.month,
    required this.year,
    this.tempMin,
    this.tempMax,
    this.tempAvg,
    this.precipitation,
  });

  ClimateDayRecordsCompanion toCompanion() {
    return ClimateDayRecordsCompanion(
      cityId: Value(cityId),
      month: Value(month),
      year: Value(year),
      tempMin: Value(tempMin),
      tempMax: Value(tempMax),
      tempAvg: Value(tempAvg),
      precipitation: Value(precipitation),
    );
  }

  factory ClimateDayRecordModel.fromJson(String cityId, Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);
    return ClimateDayRecordModel(
      cityId: cityId,
      month: date.month.toString(),
      year: date.year.toString(),
      tempMin: (json['tmin'] as num?)?.toDouble(),
      tempMax: (json['tmax'] as num?)?.toDouble(),
      tempAvg: (json['tavg'] as num?)?.toDouble(),
      precipitation: (json['prcp'] as num?)?.toDouble(),
    );
  }
}
