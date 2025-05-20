import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_assistant/climate_screen/data/climate_api_service.dart';
import 'package:weather_assistant/climate_screen/db/climate_dao.dart';
import 'package:weather_assistant/climate_screen/model/climate_day_record_model.dart';
import 'package:weather_assistant/climate_screen/model/climate_search_history.dart';
import 'package:weather_assistant/climate_screen/model/extreme_values.dart';
import 'package:weather_assistant/climate_screen/model/ideal_month_result.dart';
import 'package:weather_assistant/climate_screen/model/monthly_climate_stats.dart';
import 'dart:convert';

@LazySingleton()
class ClimateRepository {
  final ClimateDao _dao;
  final ClimateApiService api;
  static const String _historyKey = 'climate_search_history';

  final Set<String> _loadedCities = {};

  ClimateRepository(this._dao, this.api);

  Future<void> loadAndCacheCityClimateFromApi(
    String cityId,
    double lat,
    double lon,
  ) async {
    if (_loadedCities.contains(cityId)) return;
    final existingData = await _dao.getMonthlyStats(cityId);
    if (existingData.isNotEmpty) {
      _loadedCities.add(cityId);
      return;
    }
    final stationId = await api.getNearestStationId(lat, lon);
    if (stationId == null) throw Exception('Станция не найдена');
    final records = await api.fetchMonthlyClimateByStation(
      cityId: cityId,
      stationId: stationId,
      start: '2005-01-01',
      end: '2024-12-31',
    );
    final companions = records.map((r) => r.toCompanion()).toList();
    await _dao.insertClimateRecords(companions);
    _loadedCities.add(cityId);
  }

  Future<void> addToSearchHistory(String cityId, String cityName, String stationId) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();

    history.removeWhere((item) => item.stationId == stationId);

    history.insert(
        0,
        ClimateSearchHistory(
          cityId: cityId,
          cityName: cityName,
          stationId: stationId,
          timestamp: DateTime.now(),
        ));

    if (history.length > 10) {
      history.removeLast();
    }

    final historyJson = history.map((h) => h.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(historyJson));
  }

  Future<List<ClimateSearchHistory>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);
    if (historyJson == null) return [];

    final List<dynamic> decoded = jsonDecode(historyJson);
    return decoded.map((item) => ClimateSearchHistory.fromJson(item)).toList();
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<List<MonthlyClimateStats>> getMonthlyStats(String cityId) async {
    try {
      final cachedStats = await _dao.getMonthlyStats(cityId);
      if (cachedStats.isNotEmpty) {
        return cachedStats;
      }
      final coords = cityId.split('_');
      final lat = double.parse(coords[0]);
      final lon = double.parse(coords[1]);
      await loadAndCacheCityClimateFromApi(cityId, lat, lon);
      return await _dao.getMonthlyStats(cityId);
    } catch (e) {
      debugPrint('Ошибка при получении месячной статистики: $e');
      rethrow;
    }
  }

  Future<List<ExtremeValues>> getExtremeValues(String cityId) async {
    try {
      final cachedExtremes = await _dao.getExtremeValues(cityId);
      if (cachedExtremes.isNotEmpty) {
        return cachedExtremes;
      }
      final coords = cityId.split('_');
      final lat = double.parse(coords[0]);
      final lon = double.parse(coords[1]);
      await loadAndCacheCityClimateFromApi(cityId, lat, lon);
      return await _dao.getExtremeValues(cityId);
    } catch (e) {
      debugPrint('Ошибка при получении экстремальных значений: $e');
      rethrow;
    }
  }

  Future<IdealMonthResult?> getIdealMonth(String cityId) async {
    try {
      final cachedIdealMonth = await _dao.getIdealMonth(cityId);
      if (cachedIdealMonth != null) {
        return cachedIdealMonth;
      }
      final coords = cityId.split('_');
      final lat = double.parse(coords[0]);
      final lon = double.parse(coords[1]);
      await loadAndCacheCityClimateFromApi(cityId, lat, lon);
      return await _dao.getIdealMonth(cityId);
    } catch (e) {
      debugPrint('Ошибка при получении идеального месяца: $e');
      rethrow;
    }
  }

  Future<List<ClimateDayRecordModel>> getAllDaysStats(String cityId) async {
    try {
      final allDays = await _dao.getAllDaysStats(cityId);
      return allDays;
    } catch (e) {
      debugPrint('Ошибка при получении всех дневных записей: $e');
      rethrow;
    }
  }
}

extension on Iterable<num> {
  double get average => isEmpty ? 0 : fold<double>(0, (a, b) => a + b.toDouble()) / length;
  double get max => isEmpty ? 0 : fold<double>(0, (a, b) => a > b ? a : b.toDouble());
  double get min => isEmpty ? 0 : fold<double>(double.infinity, (a, b) => a < b ? a : b.toDouble());
}
