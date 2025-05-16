import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_assistant/climate_screen/data/climate_respository.dart';
import 'package:weather_assistant/climate_screen/model/extreme_values.dart';
import 'package:weather_assistant/climate_screen/model/ideal_month_result.dart';
import 'package:weather_assistant/climate_screen/model/monthly_climate_stats.dart';
import 'package:weather_assistant/climate_screen/model/city_climate_rating.dart';
import 'package:latlong2/latlong.dart';

part 'climate_state.dart';

@injectable
class ClimateCubit extends Cubit<ClimateState> {
  final ClimateRepository repository;

  ClimateCubit(this.repository) : super(ClimateInitial());

  Future<void> loadClimateByPoint(LatLng point, String city) async {
    final cityId = '${point.latitude.toStringAsFixed(4)}_${point.longitude.toStringAsFixed(4)}';

    emit(ClimateLoading());

    try {
      await repository.loadAndCacheCityClimateFromApi(cityId, point.latitude, point.longitude);

      final monthly = await repository.getMonthlyStats(cityId);

      final extremes = await repository.getExtremeValues(cityId);

      final ideal = await repository.getIdealMonth(cityId);

      final rating = CityClimateRating.calculateRating(monthly);

      emit(ClimateLoaded(
        cityId: cityId,
        cityName: city,
        monthlyStats: monthly,
        extremeValues: extremes,
        idealMonth: ideal,
        climateRating: rating,
      ));
    } catch (e) {
      emit(ClimateError('Ошибка загрузки: $e'));
    }
  }
}
