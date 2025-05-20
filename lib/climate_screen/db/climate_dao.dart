import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_assistant/climate_screen/db/climate_day_records.dart';
import 'package:weather_assistant/climate_screen/model/extreme_values.dart';
import 'package:weather_assistant/climate_screen/model/ideal_month_result.dart';
import 'package:weather_assistant/climate_screen/model/monthly_climate_stats.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/climate_screen/model/climate_day_record_model.dart';

part 'climate_dao.g.dart';

@LazySingleton()
@DriftAccessor(tables: [ClimateDayRecords])
class ClimateDao extends DatabaseAccessor<LocalDatabase> with _$ClimateDaoMixin {
  ClimateDao(LocalDatabase db) : super(db);

  // 1. Вставка списка записей (bulk insert)
  Future<void> insertClimateRecords(List<ClimateDayRecordsCompanion> entries) async {
    try {
      print('Начало вставки ${entries.length} записей в БД');
      await batch((batch) {
        batch.insertAllOnConflictUpdate(climateDayRecords, entries);
      });
      print('Записи успешно вставлены в БД');
    } catch (e) {
      print('Ошибка при вставке климатических записей: $e');
      rethrow;
    }
  }

  // 2. Получение среднего по месяцам
  Future<List<MonthlyClimateStats>> getMonthlyStats(String cityId) async {
    try {
      print('Выполнение SQL-запроса для получения месячной статистики');
      final result = await customSelect(
        '''
        SELECT 
          month,
          COALESCE(AVG(temp_min), 0) AS avg_min,
          COALESCE(AVG(temp_max), 0) AS avg_max,
          COALESCE(COUNT(*) FILTER (WHERE precipitation > 0.1), 0) AS rainy_days
        FROM climate_day_records
        WHERE city_id = ? AND month IS NOT NULL
        GROUP BY month
        ORDER BY CAST(month AS INTEGER)
        ''',
        variables: [Variable.withString(cityId)],
      ).get();
      print('Получено ${result.length} записей из БД');

      return result
          .where((row) => row.data['month'] != null)
          .map((row) => MonthlyClimateStats(
                month: row.read<String>('month'),
                avgMin: row.read<double>('avg_min'),
                avgMax: row.read<double>('avg_max'),
                rainyDays: row.read<int>('rainy_days'),
              ))
          .toList();
    } catch (e) {
      print('Ошибка при получении месячной статистики для города $cityId: $e');
      rethrow;
    }
  }

  // 3. Экстремальные значения по годам
  Future<List<ExtremeValues>> getExtremeValues(String cityId) async {
    try {
      print('Выполнение SQL-запроса для получения экстремальных значений');
      final result = await customSelect(
        '''
        WITH YearlyStats AS (
          SELECT 
            year,
            COUNT(CASE WHEN temp_max IS NOT NULL THEN 1 END) as max_days,
            COUNT(CASE WHEN temp_min IS NOT NULL THEN 1 END) as min_days,
            MAX(temp_max) as max_temp,
            MIN(temp_min) as min_temp,
            MAX(precipitation) as max_precip
          FROM climate_day_records
          WHERE city_id = ? AND year IS NOT NULL
          GROUP BY year
          HAVING 
            COUNT(CASE WHEN temp_max IS NOT NULL THEN 1 END) >= 5 AND
            COUNT(CASE WHEN temp_min IS NOT NULL THEN 1 END) >= 5
        )
        SELECT 
          year,
          CASE 
            WHEN max_days < 180 THEN max_temp + 5.5
            ELSE max_temp
          END as max_temp,
          CASE 
            WHEN max_days < 180 THEN min_temp - 5.5
            ELSE min_temp
          END as min_temp,
          min_temp,
          max_precip
        FROM YearlyStats
        WHERE max_temp IS NOT NULL AND min_temp IS NOT NULL
        ORDER BY year
        ''',
        variables: [Variable.withString(cityId)],
      ).get();
      print('Получено ${result.length} записей из БД');

      return result
          .where((row) => row.data['year'] != null)
          .map((row) => ExtremeValues(
                year: int.parse(row.read<String>('year')),
                maxTemp: row.read<double?>('max_temp'),
                minTemp: row.read<double?>('min_temp'),
                maxPrecipitation: row.read<double?>('max_precip'),
              ))
          .toList();
    } catch (e) {
      print('Ошибка при получении экстремальных значений для города $cityId: $e');
      rethrow;
    }
  }

  // 4. Идеальный месяц (самое большое число "комфортных" дней)
  Future<IdealMonthResult?> getIdealMonth(String cityId) async {
    try {
      print('Выполнение SQL-запроса для получения идеального месяца');
      final result = await customSelect(
        '''
        SELECT 
          month,
          COUNT(*) AS comfort_days
        FROM climate_day_records
        WHERE city_id = ? AND month IS NOT NULL
          AND temp_avg BETWEEN 15 AND 30
          AND precipitation < 25
        GROUP BY month
        ORDER BY comfort_days DESC
        LIMIT 1
        ''',
        variables: [Variable.withString(cityId)],
      ).getSingleOrNull();
      print('Результат запроса идеального месяца: ${result != null ? 'найден' : 'не найден'}');

      if (result == null || result.data['month'] == null) return null;

      return IdealMonthResult(
        month: result.read<String>('month'),
      );
    } catch (e) {
      print('Ошибка при получении идеального месяца для города $cityId: $e');
      rethrow;
    }
  }

  // 5. Удаление данных по городу (например, при обновлении)
  Future<void> deleteCityData(String cityId) async {
    try {
      print('Удаление данных для города $cityId');
      await (delete(climateDayRecords)..where((tbl) => tbl.cityId.equals(cityId))).go();
      print('Данные успешно удалены');
    } catch (e) {
      print('Ошибка при удалении данных города $cityId: $e');
      rethrow;
    }
  }

  // Получение всех дневных записей для города
  Future<List<ClimateDayRecordModel>> getAllDaysStats(String cityId) async {
    try {
      print('Выполнение SQL-запроса для получения всех дневных записей');
      final result = await customSelect(
        '''
        SELECT * FROM climate_day_records WHERE city_id = ?
        ''',
        variables: [Variable.withString(cityId)],
      ).get();
      print('Получено ${result.length} дневных записей из БД');
      return result
          .map((row) => ClimateDayRecordModel(
                cityId: row.read<String>('city_id'),
                month: row.read<String>('month'),
                year: row.read<String>('year'),
                tempMin: row.read<double?>('temp_min'),
                tempMax: row.read<double?>('temp_max'),
                tempAvg: row.read<double?>('temp_avg'),
                precipitation: row.read<double?>('precipitation'),
              ))
          .toList();
    } catch (e) {
      print('Ошибка при получении дневных записей для города $cityId: $e');
      rethrow;
    }
  }
}
