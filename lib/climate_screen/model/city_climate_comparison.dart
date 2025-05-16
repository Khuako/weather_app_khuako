import 'package:weather_assistant/climate_screen/model/monthly_climate_stats.dart';

class CityClimateComparison {
  final String cityA;
  final String cityB;
  final List<MonthlyClimateStats> statsA;
  final List<MonthlyClimateStats> statsB;

  CityClimateComparison({
    required this.cityA,
    required this.cityB,
    required this.statsA,
    required this.statsB,
  });
}
