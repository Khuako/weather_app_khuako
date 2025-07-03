import 'climate_day_record_model.dart';

class CityClimateRating {
  final String cityId;
  final double temperatureScore;
  final double precipitationScore;
  final double seasonalityScore;
  final double comfortScore;
  final double overallScore;

  CityClimateRating({
    required this.cityId,
    required this.temperatureScore,
    required this.precipitationScore,
    required this.seasonalityScore,
    required this.comfortScore,
    required this.overallScore,
  });

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
    int validDays = 0;
    for (var day in days) {
      if (day.tempMin == null || day.tempMax == null || day.tempMin == 0 || day.tempMax == 0) {
        continue;
      }
      validDays++;
      final avgTemp = (day.tempMin! + day.tempMax!) / 2;
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
    return validDays > 0 ? score / validDays : 0;
  }

  static double _calculatePrecipitationScore(List<ClimateDayRecordModel> days) {
    if (days.isEmpty) return 0;
    double score = 0;
    for (var day in days) {
      final precip = day.precipitation ?? 0;
      if (precip < 0.1) {
        score += 100;
      } else if (precip < 2) {
        score += 95;
      } else if (precip < 5) {
        score += 90;
      } else if (precip < 10) {
        score += 80;
      } else if (precip < 20) {
        score += 70;
      } else {
        score += 60;
      }
    }
    return score / days.length;
  }

  static double _calculateSeasonalityScore(List<ClimateDayRecordModel> days) {
    if (days.length < 30) return 40;
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
      // Пропускаем дни с нулевыми или отсутствующими данными температуры
      if (d.tempMin == null || d.tempMax == null || d.tempMin == 0 || d.tempMax == 0) {
        continue;
      }
      final avg = (d.tempMin! + d.tempMax!) / 2;
      if ([6, 7, 8].contains(m)) summerTemps.add(avg);
      if ([12, 1, 2].contains(m)) winterTemps.add(avg);
    }
    if (summerTemps.length < 15 || winterTemps.length < 15) {
      final allTemps = days
          .where((d) => d.tempMin != null && d.tempMax != null && d.tempMin != 0 && d.tempMax != 0)
          .map((d) => (d.tempMin! + d.tempMax!) / 2)
          .toList();
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
    int validDays = 0;
    for (var day in days) {
      // Пропускаем дни с нулевыми или отсутствующими данными температуры
      if (day.tempMin == null || day.tempMax == null || day.tempMin == 0 || day.tempMax == 0) {
        continue;
      }
      validDays++;
      final avgTemp = (day.tempMin! + day.tempMax!) / 2;
      final precip = day.precipitation ?? 0;

      if (avgTemp >= 15 && avgTemp <= 28 && precip < 0.1) {
        score += 100;
      } else if (avgTemp >= 12 && avgTemp <= 30 && precip < 2) {
        score += 95;
      } else if (avgTemp >= 10 && avgTemp <= 32 && precip < 5) {
        score += 90;
      } else if (avgTemp >= 5 && avgTemp <= 35 && precip < 10) {
        score += 80;
      } else if (avgTemp >= 0 && avgTemp <= 38 && precip < 20) {
        score += 70;
      } else {
        score += 60;
      }
    }
    return validDays > 0 ? score / validDays : 0;
  }
}
