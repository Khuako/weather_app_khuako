import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_assistant/data/services/local_database.dart';

@LazySingleton()
class RouteRepository {
  final LocalDatabase database;

  RouteRepository(this.database);

  /// Получение всех маршрутов с их точками
  Future<List<Map<String, dynamic>>> getAllRoutesWithPoints() async {
    final routesQuery = await database.select(database.routes).get();
    final List<Map<String, dynamic>> allRoutes = [];

    for (final route in routesQuery) {
      final pointsQuery = await (database.select(database.routePoints)
            ..where((tbl) => tbl.routeId.equals(route.id)))
          .get();

      final List<Map<String, dynamic>> points = pointsQuery.map((point) {
        return {
          'locationName': point.locationName,
          'latitude': point.latitude,
          'longitude': point.longitude,
          'arrivalDate': point.arrivalDate,
        };
      }).toList();

      allRoutes.add({
        'routeName': route.name,
        'routeId': route.id,
        'points': points,
      });
    }

    return allRoutes;
  }

  /// Добавление маршрута с точками
  Future<Map<String, dynamic>> addRoute(String routeName, List<RoutePointsCompanion> points) async {
    await database.transaction(() async {
      // Добавляем маршрут
      final routeId = await database.into(database.routes).insert(
            RoutesCompanion(name: Value(routeName)),
          );

      for (var point in points) {
        await database.into(database.routePoints).insert(
              point.copyWith(routeId: Value(routeId)),
            );
      }
      return routeId;
    });
    final routesQuery = await database.select(database.routes).get();
    final List<Map<String, dynamic>> allRoutes = [];

    for (final route in routesQuery) {
      final pointsQuery = await (database.select(database.routePoints)
            ..where((tbl) => tbl.routeId.equals(route.id)))
          .get();

      final List<Map<String, dynamic>> points = pointsQuery.map((point) {
        return {
          'locationName': point.locationName,
          'latitude': point.latitude,
          'longitude': point.longitude,
          'arrivalDate': point.arrivalDate,
        };
      }).toList();

      allRoutes.add({
        'routeName': route.name,
        'routeId': route.id,
        'points': points,
      });
    }

    return allRoutes.last;
  }

  /// Удаление маршрута и всех связанных точек
  Future<void> deleteRoute(int routeId) async {
    await database.transaction(() async {
      // Удаляем точки маршрута
      await (database.delete(database.routePoints)..where((tbl) => tbl.routeId.equals(routeId)))
          .go();

      // Удаляем маршрут
      await (database.delete(database.routes)..where((tbl) => tbl.id.equals(routeId))).go();
    });
  }

  /// Редактирование маршрута
  Future<Map<String, dynamic>> editRoute(int routeId, String newRouteName, List<RoutePointsCompanion> newPoints) async {
    await database.transaction(() async {
      // Обновляем название маршрута
      await (database.update(database.routes)
            ..where((tbl) => tbl.id.equals(routeId)))
          .write(RoutesCompanion(name: Value(newRouteName)));

      // Удаляем старые точки маршрута
      await (database.delete(database.routePoints)..where((tbl) => tbl.routeId.equals(routeId)))
          .go();

      // Добавляем новые точки маршрута
      for (var point in newPoints) {
        await database.into(database.routePoints).insert(
              point.copyWith(routeId: Value(routeId)),
            );
      }

    });
    final routesQuery = await database.select(database.routes).get();
    final List<Map<String, dynamic>> allRoutes = [];

    for (final route in routesQuery) {
      final pointsQuery = await (database.select(database.routePoints)
            ..where((tbl) => tbl.routeId.equals(route.id)))
          .get();

      final List<Map<String, dynamic>> points = pointsQuery.map((point) {
        return {
          'locationName': point.locationName,
          'latitude': point.latitude,
          'longitude': point.longitude,
          'arrivalDate': point.arrivalDate,
        };
      }).toList();

      allRoutes.add({
        'routeName': route.name,
        'routeId': route.id,
        'points': points,
      });
    }
    return allRoutes.firstWhere((route) => route['routeId'] == routeId);
  }

  /// Получение маршрута по ID
  Future<Route?> getRouteById(int routeId) async {
    final query = database.select(database.routes)..where((tbl) => tbl.id.equals(routeId));
    final route = await query.getSingleOrNull();
    return route;
  }

  /// Получение точек маршрута по ID маршрута
  Future<List<RoutePoint>> getRoutePointsByRouteId(int routeId) async {
    final query = database.select(database.routePoints)..where((tbl) => tbl.routeId.equals(routeId));
    final routePoints = await query.get();
    return routePoints;
  }
}
