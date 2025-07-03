import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:weather_assistant/data/repositories/route_repository.dart';

part 'all_routes_state.dart';

@LazySingleton()
class AllRoutesCubit extends Cubit<AllRoutesState> {
  final RouteRepository repository;

  AllRoutesCubit({required this.repository}) : super(AllRoutesLoading());

  Future<void> fetchAllRoutes() async {
    emit(AllRoutesLoading());
    try {
      final routes = await repository.getAllRoutesWithPoints();
      emit(AllRoutesLoaded(routes));
    } catch (e) {
      emit(AllRoutesError("Не удалось загрузить маршруты: $e"));
    }
  }
  Future<void> deleteRoute(int id) async {
    emit(AllRoutesLoading());
    try {
      await repository.deleteRoute(id);
      final routes = await repository.getAllRoutesWithPoints();
      emit(AllRoutesLoaded(routes));
    } catch (e) {
      emit(AllRoutesError("Не удалось загрузить маршруты: $e"));
    }

  }
}
