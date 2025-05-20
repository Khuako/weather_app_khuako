import 'climate_day_record_model.dart';

class CityClimateRating {
  final String cityId;
  final double temperatureScore; // 0-100
  final double precipitationScore; // 0-100
  final double seasonalityScore; // 0-100
  final double comfortScore; // 0-100
  final double overallScore; // 0-100

  CityClimateRating({
    required this.cityId,
    required this.temperatureScore,
    required this.precipitationScore,
    required this.seasonalityScore,
    required this.comfortScore,
    required this.overallScore,
  });

  // Новый метод для расчета рейтинга по всем дням
  static CityClimateRating calculateRatingFromDays(List<ClimateDayRecordModel> days) {
    if (days.isEmpty) {
      return CityClimateRating(
        cityId: '',
        temperatureScore: 0,
        precipitationScore: 0,
        seasonalityScore: 0,
        comfortScore: 0,
        overallScore: 0,
      );
    }
    final tempScore = _calculateTemperatureScore(days);
    final precipScore = _calculatePrecipitationScore(days);
    final seasonScore = _calculateSeasonalityScore(days);
    final comfortScore = _calculateComfortScore(days);
    final overallScore = (tempScore + precipScore + seasonScore + comfortScore) / 4;
    return CityClimateRating(
      cityId: days.first.cityId,
      temperatureScore: tempScore,
      precipitationScore: precipScore,
      seasonalityScore: seasonScore,
      comfortScore: comfortScore,
      overallScore: overallScore,
    );
  }

  static double _calculateTemperatureScore(List<ClimateDayRecordModel> days) {
    if (days.isEmpty) return 0;
    double score = 0;
    for (var day in days) {
      final avgTemp = ((day.tempMin ?? 0) + (day.tempMax ?? 0)) / 2;
      if (avgTemp >= 10 && avgTemp <= 28) {
        score += 100;
      } else if (avgTemp >= 5 && avgTemp <= 32) {
        score += 80;
      } else if (avgTemp >= 0 && avgTemp <= 35) {
        score += 60;
      } else {
        score += 40;
      }
    }
    return score / days.length;
  }

  static double _calculatePrecipitationScore(List<ClimateDayRecordModel> days) {
    if (days.isEmpty) return 0;
    double score = 0;
    for (var day in days) {
      final precip = day.precipitation ?? 0;
      if (precip < 0.1) {
        score += 100; // Без осадков
      } else if (precip < 2) {
        score += 95; // Легкий дождь
      } else if (precip < 5) {
        score += 90; // Умеренный дождь
      } else if (precip < 10) {
        score += 80; // Сильный дождь
      } else if (precip < 20) {
        score += 70; // Очень сильный дождь
      } else {
        score += 60; // Экстремальные осадки
      }
    }
    return score / days.length;
  }

  static double _calculateSeasonalityScore(List<ClimateDayRecordModel> days) {
    if (days.length < 30) return 40; // слишком мало данных
    // Приводим month к int
    List<double> summerTemps = [];
    List<double> winterTemps = [];
    for (var d in days) {
      int? m;
      try {
        m = int.tryParse(d.month ?? '');
      } catch (_) {
        m = null;
      }
      if (m == null) continue;
      final avg = ((d.tempMin ?? 0) + (d.tempMax ?? 0)) / 2;
      if ([6, 7, 8].contains(m)) summerTemps.add(avg);
      if ([12, 1, 2].contains(m)) winterTemps.add(avg);
    }
    // Если мало летних/зимних дней — считаем по всем дням
    if (summerTemps.length < 15 || winterTemps.length < 15) {
      final allTemps = days.map((d) => ((d.tempMin ?? 0) + (d.tempMax ?? 0)) / 2).toList();
      if (allTemps.isEmpty) return 40;
      final maxT = allTemps.reduce((a, b) => a > b ? a : b);
      final minT = allTemps.reduce((a, b) => a < b ? a : b);
      final tempDiff = (maxT - minT).abs();
      if (tempDiff <= 10) return 80;
      if (tempDiff <= 20) return 60;
      if (tempDiff <= 30) return 50;
      return 40;
    }
    final summerAvg = summerTemps.reduce((a, b) => a + b) / summerTemps.length;
    final winterAvg = winterTemps.reduce((a, b) => a + b) / winterTemps.length;
    final tempDiff = (summerAvg - winterAvg).abs();
    if (tempDiff <= 10) return 100;
    if (tempDiff <= 20) return 80;
    if (tempDiff <= 30) return 60;
    return 40;
  }

  static double _calculateComfortScore(List<ClimateDayRecordModel> days) {
    if (days.isEmpty) return 0;
    double score = 0;
    for (var day in days) {
      final avgTemp = ((day.tempMin ?? 0) + (day.tempMax ?? 0)) / 2;
      final precip = day.precipitation ?? 0;

      // Идеальные условия
      if (avgTemp >= 15 && avgTemp <= 28 && precip < 0.1) {
        score += 100;
      }
      // Очень комфортные условия
      else if (avgTemp >= 12 && avgTemp <= 30 && precip < 2) {
        score += 95;
      }
      // Комфортные условия
      else if (avgTemp >= 10 && avgTemp <= 32 && precip < 5) {
        score += 90;
      }
      // Умеренно комфортные условия
      else if (avgTemp >= 5 && avgTemp <= 35 && precip < 10) {
        score += 80;
      }
      // Приемлемые условия
      else if (avgTemp >= 0 && avgTemp <= 38 && precip < 20) {
        score += 70;
      }
      // Не комфортные, но терпимые условия
      else {
        score += 60;
      }
    }
    return score / days.length;
  }
}
