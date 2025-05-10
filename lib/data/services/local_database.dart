import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'dart:io';

import 'package:weather_assistant/data/repositories/route_repository.dart';

part 'local_database.g.dart';

// Таблица маршрутов
class Routes extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID маршрута
  TextColumn get name => text()();                // Название маршрута
}

// Таблица точек маршрута
class RoutePoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routeId => integer().customConstraint('REFERENCES routes(id) NOT NULL')();
  TextColumn get locationName => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get arrivalDate => dateTime()();
}
@LazySingleton()
// Определяем базу данных
@DriftDatabase(tables: [Routes, RoutePoints])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Получение всех маршрутов с точками
  Future<List<Map<String, dynamic>>> getAllRoutesWithPoints() async {
    final query = select(routes).join(
      [
        innerJoin(routePoints, routePoints.routeId.equalsExp(routes.id)),
      ],
    );

    final result = await query.get();
    return result.map((row) {
      final route = row.readTable(routes);
      final point = row.readTable(routePoints);

      return {
        'route': route,
        'point': point,
      };
    }).toList();
  }

  // Добавление маршрута
  Future<int> addRoute(String name, List<RoutePointsCompanion> points) async {
    return transaction(() async {
      final routeId = await into(routes).insert(RoutesCompanion(name: Value(name)));
      for (final point in points) {
        await into(routePoints).insert(
          point.copyWith(routeId: Value(routeId)),
        );
      }
      return routeId;
    });
  }

  // Удаление маршрута и его точек
  Future<void> deleteRoute(int routeId) async {
    await transaction(() async {
      await (delete(routePoints)..where((tbl) => tbl.routeId.equals(routeId))).go();
      await (delete(routes)..where((tbl) => tbl.id.equals(routeId))).go();
    });
  }
}

// Открытие подключения к базе данных
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'routes.db'));
    return NativeDatabase(file);
  });
}
final getIt = GetIt.instance;

