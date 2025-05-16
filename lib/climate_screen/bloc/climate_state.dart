part of 'climate_cubit.dart';

abstract class ClimateState {}

class ClimateInitial extends ClimateState {}

class ClimateLoading extends ClimateState {}

class ClimateLoaded extends ClimateState {
  final String cityId;
  final String cityName;
  final List<MonthlyClimateStats> monthlyStats;
  final List<ExtremeValues> extremeValues;
  final IdealMonthResult? idealMonth;
  final CityClimateRating climateRating;

  ClimateLoaded({
    required this.cityId,
    required this.cityName,
    required this.monthlyStats,
    required this.extremeValues,
    required this.idealMonth,
    required this.climateRating,
  });
}

class ClimateError extends ClimateState {
  final String message;

  ClimateError(this.message);
}
