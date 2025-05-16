import 'monthly_climate_stats.dart';

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

  // Метод для расчета общего рейтинга
  static CityClimateRating calculateRating(List<MonthlyClimateStats> stats) {
    final tempScore = _calculateTemperatureScore(stats);
    final precipScore = _calculatePrecipitationScore(stats);
    final seasonScore = _calculateSeasonalityScore(stats);
    final comfortScore = _calculateComfortScore(stats);

    final overallScore = (tempScore + precipScore + seasonScore + comfortScore) / 4;

    return CityClimateRating(
      cityId: stats.first.month.substring(0, 2),
      temperatureScore: tempScore,
      precipitationScore: precipScore,
      seasonalityScore: seasonScore,
      comfortScore: comfortScore,
      overallScore: overallScore,
    );
  }

  static double _calculateTemperatureScore(List<MonthlyClimateStats> stats) {
    double score = 0;
    for (var stat in stats) {
      final avgTemp = (stat.avgMin + stat.avgMax) / 2;
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
    return score / stats.length;
  }

  static double _calculatePrecipitationScore(List<MonthlyClimateStats> stats) {
    double score = 0;
    for (var stat in stats) {
      if (stat.rainyDays < 8) {
        score += 100;
      } else if (stat.rainyDays < 12) {
        score += 80;
      } else if (stat.rainyDays < 15) {
        score += 60;
      } else {
        score += 40;
      }
    }
    return score / stats.length;
  }

  static double _calculateSeasonalityScore(List<MonthlyClimateStats> stats) {
    if (stats.length < 12) return 0;

    final summerTemps = stats
        .where((s) => ['06', '07', '08'].contains(s.month))
        .map((s) => (s.avgMin + s.avgMax) / 2);
    final winterTemps = stats
        .where((s) => ['12', '01', '02'].contains(s.month))
        .map((s) => (s.avgMin + s.avgMax) / 2);

    final summerAvg = summerTemps.reduce((a, b) => a + b) / summerTemps.length;
    final winterAvg = winterTemps.reduce((a, b) => a + b) / winterTemps.length;
    final tempDiff = (summerAvg - winterAvg).abs();

    if (tempDiff <= 10) return 100;
    if (tempDiff <= 20) return 80;
    if (tempDiff <= 30) return 60;
    return 40;
  }

  static double _calculateComfortScore(List<MonthlyClimateStats> stats) {
    double score = 0;
    for (var stat in stats) {
      final avgTemp = (stat.avgMin + stat.avgMax) / 2;
      if (avgTemp >= 15 && avgTemp <= 28 && stat.rainyDays < 10) {
        score += 100;
      } else if (avgTemp >= 10 && avgTemp <= 32 && stat.rainyDays < 12) {
        score += 80;
      } else if (avgTemp >= 5 && avgTemp <= 35 && stat.rainyDays < 15) {
        score += 60;
      } else {
        score += 40;
      }
    }
    return score / stats.length;
  }
}
