import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_assistant/climate_screen/data/climate_api_service.dart';
import 'package:weather_assistant/climate_screen/db/climate_dao.dart';
import 'package:weather_assistant/climate_screen/model/climate_day_record_model.dart';
import 'package:weather_assistant/climate_screen/model/extreme_values.dart';
import 'package:weather_assistant/climate_screen/model/ideal_month_result.dart';
import 'package:weather_assistant/climate_screen/model/monthly_climate_stats.dart';

@LazySingleton()
class ClimateRepository {
  final ClimateDao _dao;
  final ClimateApiService _api;

  ClimateRepository(this._dao, this._api);

  Future<void> loadAndCacheCityClimateFromApi(
    String cityId,
    double lat,
    double lon,
  ) async {
    final stationId = await _api.getNearestStationId(lat, lon);
    if (stationId == null) throw Exception('Станция не найдена');

    final records = await _api.fetchMonthlyClimateByStation(
      cityId: cityId,
      stationId: stationId,
      start: '2005-01-01',
      end: '2024-12-31',
    );

    final companions = records.map((r) => r.toCompanion()).toList();

    await _dao.deleteCityData(cityId);

    await _dao.insertClimateRecords(companions);
  }

  Future<List<MonthlyClimateStats>> getMonthlyStats(String cityId) async {
    try {
      final stationId = await _api.getNearestStationId(
        double.parse(cityId.split('_')[0]),
        double.parse(cityId.split('_')[1]),
      );
      if (stationId == null) throw Exception('Станция не найдена');

      final records = await _api.fetchMonthlyClimateByStation(
        cityId: cityId,
        stationId: stationId,
        start: '2005-01-01',
        end: '2024-12-31',
      );

      final monthlyData = <String, List<ClimateDayRecordModel>>{};
      for (var record in records) {
        final month = record.date.month.toString().padLeft(2, '0');
        monthlyData.putIfAbsent(month, () => []).add(record);
      }

      return monthlyData.entries.map((entry) {
        final monthRecords = entry.value;
        return MonthlyClimateStats(
          month: entry.key,
          avgMin: monthRecords.map((r) => r.tempMin ?? 0).average,
          avgMax: monthRecords.map((r) => r.tempMax ?? 0).average,
          rainyDays: monthRecords.where((r) => (r.precipitation ?? 0) > 0.1).length,
        );
      }).toList()
        ..sort((a, b) => a.month.compareTo(b.month));
    } catch (e) {
      print('Ошибка при получении месячной статистики: $e');
      rethrow;
    }
  }

  Future<List<ExtremeValues>> getExtremeValues(String cityId) async {
    try {
      final stationId = await _api.getNearestStationId(
        double.parse(cityId.split('_')[0]),
        double.parse(cityId.split('_')[1]),
      );
      if (stationId == null) throw Exception('Станция не найдена');

      final records = await _api.fetchMonthlyClimateByStation(
        cityId: cityId,
        stationId: stationId,
        start: '2005-01-01',
        end: '2024-12-31',
      );

      final yearlyData = <int, List<ClimateDayRecordModel>>{};
      for (var record in records) {
        final year = record.date.year;
        yearlyData.putIfAbsent(year, () => []).add(record);
      }

      return yearlyData.entries.map((entry) {
        final yearRecords = entry.value;
        final validTempRecords = yearRecords.where((r) => r.tempMax != null && r.tempMin != null);

        if (validTempRecords.isEmpty) {
          return ExtremeValues(
            year: entry.key,
            maxTemp: null,
            minTemp: null,
            maxPrecipitation: yearRecords.map((r) => r.precipitation ?? 0).max,
          );
        }

        return ExtremeValues(
          year: entry.key,
          maxTemp: validTempRecords.map((r) => r.tempMax!).max,
          minTemp: validTempRecords.map((r) => r.tempMin!).min,
          maxPrecipitation: yearRecords.map((r) => r.precipitation ?? 0).max,
        );
      }).toList()
        ..sort((a, b) => a.year.compareTo(b.year));
    } catch (e) {
      print('Ошибка при получении экстремальных значений: $e');
      rethrow;
    }
  }

  Future<IdealMonthResult?> getIdealMonth(String cityId) async {
    try {
      final stationId = await _api.getNearestStationId(
        double.parse(cityId.split('_')[0]),
        double.parse(cityId.split('_')[1]),
      );
      if (stationId == null) throw Exception('Станция не найдена');

      final records = await _api.fetchMonthlyClimateByStation(
        cityId: cityId,
        stationId: stationId,
        start: '2005-01-01',
        end: '2024-12-31',
      );

      final monthlyData = <String, List<ClimateDayRecordModel>>{};
      for (var record in records) {
        final month = record.date.month.toString().padLeft(2, '0');
        monthlyData.putIfAbsent(month, () => []).add(record);
      }

      String? bestMonth;
      int maxComfortDays = 0;

      for (var entry in monthlyData.entries) {
        final comfortDays = entry.value.where((record) {
          final tempAvg = record.tempAvg ?? 0;
          final precip = record.precipitation ?? 0;
          return tempAvg >= 10 && tempAvg <= 30 && precip < 10;
        }).length;

        if (comfortDays > maxComfortDays) {
          maxComfortDays = comfortDays;
          bestMonth = entry.key;
        }
      }

      if (bestMonth == null) return null;

      return IdealMonthResult(
        month: bestMonth,
      );
    } catch (e) {
      debugPrint('Ошибка при получении идеального месяца: $e');
      rethrow;
    }
  }
}

extension on Iterable<num> {
  double get average => isEmpty ? 0 : fold<double>(0, (a, b) => a + b.toDouble()) / length;
  double get max => isEmpty ? 0 : fold<double>(0, (a, b) => a > b ? a : b.toDouble());
  double get min => isEmpty ? 0 : fold<double>(double.infinity, (a, b) => a < b ? a : b.toDouble());
}
