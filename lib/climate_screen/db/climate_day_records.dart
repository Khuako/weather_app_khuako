import 'package:drift/drift.dart';

class ClimateDayRecords extends Table {
  TextColumn get cityId => text()();
  TextColumn get month => text()();
  TextColumn get year => text()();
  RealColumn get tempMin => real().nullable()();
  RealColumn get tempMax => real().nullable()();
  RealColumn get precipitation => real().nullable()();
  RealColumn get tempAvg => real().nullable()();
  RealColumn get humidity => real().nullable()();
  RealColumn get windSpeed => real().nullable()();

  @override
  Set<Column> get primaryKey => {cityId, month, year};
}
