part of 'all_routes_cubit.dart';

abstract class AllRoutesState {}

class AllRoutesLoading extends AllRoutesState {}

class AllRoutesLoaded extends AllRoutesState {
  final List<Map<String, dynamic>> routes;

  AllRoutesLoaded(this.routes);
}

class AllRoutesError extends AllRoutesState {
  final String message;

  AllRoutesError(this.message);
}
