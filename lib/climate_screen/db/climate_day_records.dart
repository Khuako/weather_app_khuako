import 'package:drift/drift.dart';

class ClimateDayRecords extends Table {
  TextColumn get cityId => text()(); // город или станция
  DateTimeColumn get date => dateTime()();
  RealColumn get tempMin => real().nullable()(); // минимальная температура
  RealColumn get tempMax => real().nullable()(); // максимальная температура
  RealColumn get precipitation => real().nullable()(); // осадки, мм
  RealColumn get tempAvg => real().nullable()(); // может быть рассчитана при импорте
  RealColumn get humidity => real().nullable()(); // если будет
  RealColumn get windSpeed => real().nullable()(); // если будет

  @override
  Set<Column> get primaryKey => {cityId, date};
}
