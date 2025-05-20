// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(Insertable<Route> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class Route extends DataClass implements Insertable<Route> {
  final int id;
  final String name;
  const Route({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Route.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Route(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Route copyWith({int? id, String? name}) => Route(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Route copyWithCompanion(RoutesCompanion data) {
    return Route(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Route(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Route && other.id == this.id && other.name == this.name);
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<int> id;
  final Value<String> name;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RoutesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Route> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RoutesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return RoutesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RoutePointsTable extends RoutePoints
    with TableInfo<$RoutePointsTable, RoutePoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutePointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routeIdMeta =
      const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<int> routeId = GeneratedColumn<int>(
      'route_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES routes(id) NOT NULL');
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _arrivalDateMeta =
      const VerificationMeta('arrivalDate');
  @override
  late final GeneratedColumn<DateTime> arrivalDate = GeneratedColumn<DateTime>(
      'arrival_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, routeId, locationName, latitude, longitude, arrivalDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'route_points';
  @override
  VerificationContext validateIntegrity(Insertable<RoutePoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta,
          routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('arrival_date')) {
      context.handle(
          _arrivalDateMeta,
          arrivalDate.isAcceptableOrUnknown(
              data['arrival_date']!, _arrivalDateMeta));
    } else if (isInserting) {
      context.missing(_arrivalDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutePoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutePoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}route_id'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      arrivalDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}arrival_date'])!,
    );
  }

  @override
  $RoutePointsTable createAlias(String alias) {
    return $RoutePointsTable(attachedDatabase, alias);
  }
}

class RoutePoint extends DataClass implements Insertable<RoutePoint> {
  final int id;
  final int routeId;
  final String locationName;
  final double latitude;
  final double longitude;
  final DateTime arrivalDate;
  const RoutePoint(
      {required this.id,
      required this.routeId,
      required this.locationName,
      required this.latitude,
      required this.longitude,
      required this.arrivalDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['route_id'] = Variable<int>(routeId);
    map['location_name'] = Variable<String>(locationName);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['arrival_date'] = Variable<DateTime>(arrivalDate);
    return map;
  }

  RoutePointsCompanion toCompanion(bool nullToAbsent) {
    return RoutePointsCompanion(
      id: Value(id),
      routeId: Value(routeId),
      locationName: Value(locationName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      arrivalDate: Value(arrivalDate),
    );
  }

  factory RoutePoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutePoint(
      id: serializer.fromJson<int>(json['id']),
      routeId: serializer.fromJson<int>(json['routeId']),
      locationName: serializer.fromJson<String>(json['locationName']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      arrivalDate: serializer.fromJson<DateTime>(json['arrivalDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routeId': serializer.toJson<int>(routeId),
      'locationName': serializer.toJson<String>(locationName),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'arrivalDate': serializer.toJson<DateTime>(arrivalDate),
    };
  }

  RoutePoint copyWith(
          {int? id,
          int? routeId,
          String? locationName,
          double? latitude,
          double? longitude,
          DateTime? arrivalDate}) =>
      RoutePoint(
        id: id ?? this.id,
        routeId: routeId ?? this.routeId,
        locationName: locationName ?? this.locationName,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        arrivalDate: arrivalDate ?? this.arrivalDate,
      );
  RoutePoint copyWithCompanion(RoutePointsCompanion data) {
    return RoutePoint(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      arrivalDate:
          data.arrivalDate.present ? data.arrivalDate.value : this.arrivalDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutePoint(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('locationName: $locationName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('arrivalDate: $arrivalDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routeId, locationName, latitude, longitude, arrivalDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutePoint &&
          other.id == this.id &&
          other.routeId == this.routeId &&
          other.locationName == this.locationName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.arrivalDate == this.arrivalDate);
}

class RoutePointsCompanion extends UpdateCompanion<RoutePoint> {
  final Value<int> id;
  final Value<int> routeId;
  final Value<String> locationName;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> arrivalDate;
  const RoutePointsCompanion({
    this.id = const Value.absent(),
    this.routeId = const Value.absent(),
    this.locationName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.arrivalDate = const Value.absent(),
  });
  RoutePointsCompanion.insert({
    this.id = const Value.absent(),
    required int routeId,
    required String locationName,
    required double latitude,
    required double longitude,
    required DateTime arrivalDate,
  })  : routeId = Value(routeId),
        locationName = Value(locationName),
        latitude = Value(latitude),
        longitude = Value(longitude),
        arrivalDate = Value(arrivalDate);
  static Insertable<RoutePoint> custom({
    Expression<int>? id,
    Expression<int>? routeId,
    Expression<String>? locationName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? arrivalDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeId != null) 'route_id': routeId,
      if (locationName != null) 'location_name': locationName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (arrivalDate != null) 'arrival_date': arrivalDate,
    });
  }

  RoutePointsCompanion copyWith(
      {Value<int>? id,
      Value<int>? routeId,
      Value<String>? locationName,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<DateTime>? arrivalDate}) {
    return RoutePointsCompanion(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      arrivalDate: arrivalDate ?? this.arrivalDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<int>(routeId.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (arrivalDate.present) {
      map['arrival_date'] = Variable<DateTime>(arrivalDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutePointsCompanion(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('locationName: $locationName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('arrivalDate: $arrivalDate')
          ..write(')'))
        .toString();
  }
}

class $ClimateDayRecordsTable extends ClimateDayRecords
    with TableInfo<$ClimateDayRecordsTable, ClimateDayRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClimateDayRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<String> cityId = GeneratedColumn<String>(
      'city_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
      'month', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
      'year', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tempMinMeta =
      const VerificationMeta('tempMin');
  @override
  late final GeneratedColumn<double> tempMin = GeneratedColumn<double>(
      'temp_min', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tempMaxMeta =
      const VerificationMeta('tempMax');
  @override
  late final GeneratedColumn<double> tempMax = GeneratedColumn<double>(
      'temp_max', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _precipitationMeta =
      const VerificationMeta('precipitation');
  @override
  late final GeneratedColumn<double> precipitation = GeneratedColumn<double>(
      'precipitation', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tempAvgMeta =
      const VerificationMeta('tempAvg');
  @override
  late final GeneratedColumn<double> tempAvg = GeneratedColumn<double>(
      'temp_avg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _humidityMeta =
      const VerificationMeta('humidity');
  @override
  late final GeneratedColumn<double> humidity = GeneratedColumn<double>(
      'humidity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _windSpeedMeta =
      const VerificationMeta('windSpeed');
  @override
  late final GeneratedColumn<double> windSpeed = GeneratedColumn<double>(
      'wind_speed', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cityId,
        month,
        year,
        tempMin,
        tempMax,
        precipitation,
        tempAvg,
        humidity,
        windSpeed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'climate_day_records';
  @override
  VerificationContext validateIntegrity(Insertable<ClimateDayRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('city_id')) {
      context.handle(_cityIdMeta,
          cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta));
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('temp_min')) {
      context.handle(_tempMinMeta,
          tempMin.isAcceptableOrUnknown(data['temp_min']!, _tempMinMeta));
    }
    if (data.containsKey('temp_max')) {
      context.handle(_tempMaxMeta,
          tempMax.isAcceptableOrUnknown(data['temp_max']!, _tempMaxMeta));
    }
    if (data.containsKey('precipitation')) {
      context.handle(
          _precipitationMeta,
          precipitation.isAcceptableOrUnknown(
              data['precipitation']!, _precipitationMeta));
    }
    if (data.containsKey('temp_avg')) {
      context.handle(_tempAvgMeta,
          tempAvg.isAcceptableOrUnknown(data['temp_avg']!, _tempAvgMeta));
    }
    if (data.containsKey('humidity')) {
      context.handle(_humidityMeta,
          humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta));
    }
    if (data.containsKey('wind_speed')) {
      context.handle(_windSpeedMeta,
          windSpeed.isAcceptableOrUnknown(data['wind_speed']!, _windSpeedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cityId, month, year};
  @override
  ClimateDayRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClimateDayRecord(
      cityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}year'])!,
      tempMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_min']),
      tempMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_max']),
      precipitation: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precipitation']),
      tempAvg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_avg']),
      humidity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}humidity']),
      windSpeed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}wind_speed']),
    );
  }

  @override
  $ClimateDayRecordsTable createAlias(String alias) {
    return $ClimateDayRecordsTable(attachedDatabase, alias);
  }
}

class ClimateDayRecord extends DataClass
    implements Insertable<ClimateDayRecord> {
  final String cityId;
  final String month;
  final String year;
  final double? tempMin;
  final double? tempMax;
  final double? precipitation;
  final double? tempAvg;
  final double? humidity;
  final double? windSpeed;
  const ClimateDayRecord(
      {required this.cityId,
      required this.month,
      required this.year,
      this.tempMin,
      this.tempMax,
      this.precipitation,
      this.tempAvg,
      this.humidity,
      this.windSpeed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['city_id'] = Variable<String>(cityId);
    map['month'] = Variable<String>(month);
    map['year'] = Variable<String>(year);
    if (!nullToAbsent || tempMin != null) {
      map['temp_min'] = Variable<double>(tempMin);
    }
    if (!nullToAbsent || tempMax != null) {
      map['temp_max'] = Variable<double>(tempMax);
    }
    if (!nullToAbsent || precipitation != null) {
      map['precipitation'] = Variable<double>(precipitation);
    }
    if (!nullToAbsent || tempAvg != null) {
      map['temp_avg'] = Variable<double>(tempAvg);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<double>(humidity);
    }
    if (!nullToAbsent || windSpeed != null) {
      map['wind_speed'] = Variable<double>(windSpeed);
    }
    return map;
  }

  ClimateDayRecordsCompanion toCompanion(bool nullToAbsent) {
    return ClimateDayRecordsCompanion(
      cityId: Value(cityId),
      month: Value(month),
      year: Value(year),
      tempMin: tempMin == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMin),
      tempMax: tempMax == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMax),
      precipitation: precipitation == null && nullToAbsent
          ? const Value.absent()
          : Value(precipitation),
      tempAvg: tempAvg == null && nullToAbsent
          ? const Value.absent()
          : Value(tempAvg),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      windSpeed: windSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(windSpeed),
    );
  }

  factory ClimateDayRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClimateDayRecord(
      cityId: serializer.fromJson<String>(json['cityId']),
      month: serializer.fromJson<String>(json['month']),
      year: serializer.fromJson<String>(json['year']),
      tempMin: serializer.fromJson<double?>(json['tempMin']),
      tempMax: serializer.fromJson<double?>(json['tempMax']),
      precipitation: serializer.fromJson<double?>(json['precipitation']),
      tempAvg: serializer.fromJson<double?>(json['tempAvg']),
      humidity: serializer.fromJson<double?>(json['humidity']),
      windSpeed: serializer.fromJson<double?>(json['windSpeed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cityId': serializer.toJson<String>(cityId),
      'month': serializer.toJson<String>(month),
      'year': serializer.toJson<String>(year),
      'tempMin': serializer.toJson<double?>(tempMin),
      'tempMax': serializer.toJson<double?>(tempMax),
      'precipitation': serializer.toJson<double?>(precipitation),
      'tempAvg': serializer.toJson<double?>(tempAvg),
      'humidity': serializer.toJson<double?>(humidity),
      'windSpeed': serializer.toJson<double?>(windSpeed),
    };
  }

  ClimateDayRecord copyWith(
          {String? cityId,
          String? month,
          String? year,
          Value<double?> tempMin = const Value.absent(),
          Value<double?> tempMax = const Value.absent(),
          Value<double?> precipitation = const Value.absent(),
          Value<double?> tempAvg = const Value.absent(),
          Value<double?> humidity = const Value.absent(),
          Value<double?> windSpeed = const Value.absent()}) =>
      ClimateDayRecord(
        cityId: cityId ?? this.cityId,
        month: month ?? this.month,
        year: year ?? this.year,
        tempMin: tempMin.present ? tempMin.value : this.tempMin,
        tempMax: tempMax.present ? tempMax.value : this.tempMax,
        precipitation:
            precipitation.present ? precipitation.value : this.precipitation,
        tempAvg: tempAvg.present ? tempAvg.value : this.tempAvg,
        humidity: humidity.present ? humidity.value : this.humidity,
        windSpeed: windSpeed.present ? windSpeed.value : this.windSpeed,
      );
  ClimateDayRecord copyWithCompanion(ClimateDayRecordsCompanion data) {
    return ClimateDayRecord(
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      tempMin: data.tempMin.present ? data.tempMin.value : this.tempMin,
      tempMax: data.tempMax.present ? data.tempMax.value : this.tempMax,
      precipitation: data.precipitation.present
          ? data.precipitation.value
          : this.precipitation,
      tempAvg: data.tempAvg.present ? data.tempAvg.value : this.tempAvg,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      windSpeed: data.windSpeed.present ? data.windSpeed.value : this.windSpeed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClimateDayRecord(')
          ..write('cityId: $cityId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('tempMin: $tempMin, ')
          ..write('tempMax: $tempMax, ')
          ..write('precipitation: $precipitation, ')
          ..write('tempAvg: $tempAvg, ')
          ..write('humidity: $humidity, ')
          ..write('windSpeed: $windSpeed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cityId, month, year, tempMin, tempMax,
      precipitation, tempAvg, humidity, windSpeed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClimateDayRecord &&
          other.cityId == this.cityId &&
          other.month == this.month &&
          other.year == this.year &&
          other.tempMin == this.tempMin &&
          other.tempMax == this.tempMax &&
          other.precipitation == this.precipitation &&
          other.tempAvg == this.tempAvg &&
          other.humidity == this.humidity &&
          other.windSpeed == this.windSpeed);
}

class ClimateDayRecordsCompanion extends UpdateCompanion<ClimateDayRecord> {
  final Value<String> cityId;
  final Value<String> month;
  final Value<String> year;
  final Value<double?> tempMin;
  final Value<double?> tempMax;
  final Value<double?> precipitation;
  final Value<double?> tempAvg;
  final Value<double?> humidity;
  final Value<double?> windSpeed;
  final Value<int> rowid;
  const ClimateDayRecordsCompanion({
    this.cityId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.tempMin = const Value.absent(),
    this.tempMax = const Value.absent(),
    this.precipitation = const Value.absent(),
    this.tempAvg = const Value.absent(),
    this.humidity = const Value.absent(),
    this.windSpeed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClimateDayRecordsCompanion.insert({
    required String cityId,
    required String month,
    required String year,
    this.tempMin = const Value.absent(),
    this.tempMax = const Value.absent(),
    this.precipitation = const Value.absent(),
    this.tempAvg = const Value.absent(),
    this.humidity = const Value.absent(),
    this.windSpeed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : cityId = Value(cityId),
        month = Value(month),
        year = Value(year);
  static Insertable<ClimateDayRecord> custom({
    Expression<String>? cityId,
    Expression<String>? month,
    Expression<String>? year,
    Expression<double>? tempMin,
    Expression<double>? tempMax,
    Expression<double>? precipitation,
    Expression<double>? tempAvg,
    Expression<double>? humidity,
    Expression<double>? windSpeed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cityId != null) 'city_id': cityId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (tempMin != null) 'temp_min': tempMin,
      if (tempMax != null) 'temp_max': tempMax,
      if (precipitation != null) 'precipitation': precipitation,
      if (tempAvg != null) 'temp_avg': tempAvg,
      if (humidity != null) 'humidity': humidity,
      if (windSpeed != null) 'wind_speed': windSpeed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClimateDayRecordsCompanion copyWith(
      {Value<String>? cityId,
      Value<String>? month,
      Value<String>? year,
      Value<double?>? tempMin,
      Value<double?>? tempMax,
      Value<double?>? precipitation,
      Value<double?>? tempAvg,
      Value<double?>? humidity,
      Value<double?>? windSpeed,
      Value<int>? rowid}) {
    return ClimateDayRecordsCompanion(
      cityId: cityId ?? this.cityId,
      month: month ?? this.month,
      year: year ?? this.year,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      precipitation: precipitation ?? this.precipitation,
      tempAvg: tempAvg ?? this.tempAvg,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cityId.present) {
      map['city_id'] = Variable<String>(cityId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (tempMin.present) {
      map['temp_min'] = Variable<double>(tempMin.value);
    }
    if (tempMax.present) {
      map['temp_max'] = Variable<double>(tempMax.value);
    }
    if (precipitation.present) {
      map['precipitation'] = Variable<double>(precipitation.value);
    }
    if (tempAvg.present) {
      map['temp_avg'] = Variable<double>(tempAvg.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<double>(humidity.value);
    }
    if (windSpeed.present) {
      map['wind_speed'] = Variable<double>(windSpeed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClimateDayRecordsCompanion(')
          ..write('cityId: $cityId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('tempMin: $tempMin, ')
          ..write('tempMax: $tempMax, ')
          ..write('precipitation: $precipitation, ')
          ..write('tempAvg: $tempAvg, ')
          ..write('humidity: $humidity, ')
          ..write('windSpeed: $windSpeed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $RoutesTable routes = $RoutesTable(this);
  late final $RoutePointsTable routePoints = $RoutePointsTable(this);
  late final $ClimateDayRecordsTable climateDayRecords =
      $ClimateDayRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [routes, routePoints, climateDayRecords];
}

typedef $$RoutesTableCreateCompanionBuilder = RoutesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$RoutesTableUpdateCompanionBuilder = RoutesCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$RoutesTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $RoutesTable,
    Route,
    $$RoutesTableFilterComposer,
    $$RoutesTableOrderingComposer,
    $$RoutesTableCreateCompanionBuilder,
    $$RoutesTableUpdateCompanionBuilder> {
  $$RoutesTableTableManager(_$LocalDatabase db, $RoutesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RoutesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RoutesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              RoutesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              RoutesCompanion.insert(
            id: id,
            name: name,
          ),
        ));
}

class $$RoutesTableFilterComposer
    extends FilterComposer<_$LocalDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter routePointsRefs(
      ComposableFilter Function($$RoutePointsTableFilterComposer f) f) {
    final $$RoutePointsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.routePoints,
        getReferencedColumn: (t) => t.routeId,
        builder: (joinBuilder, parentComposers) =>
            $$RoutePointsTableFilterComposer(ComposerState($state.db,
                $state.db.routePoints, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$RoutesTableOrderingComposer
    extends OrderingComposer<_$LocalDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$RoutePointsTableCreateCompanionBuilder = RoutePointsCompanion
    Function({
  Value<int> id,
  required int routeId,
  required String locationName,
  required double latitude,
  required double longitude,
  required DateTime arrivalDate,
});
typedef $$RoutePointsTableUpdateCompanionBuilder = RoutePointsCompanion
    Function({
  Value<int> id,
  Value<int> routeId,
  Value<String> locationName,
  Value<double> latitude,
  Value<double> longitude,
  Value<DateTime> arrivalDate,
});

class $$RoutePointsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $RoutePointsTable,
    RoutePoint,
    $$RoutePointsTableFilterComposer,
    $$RoutePointsTableOrderingComposer,
    $$RoutePointsTableCreateCompanionBuilder,
    $$RoutePointsTableUpdateCompanionBuilder> {
  $$RoutePointsTableTableManager(_$LocalDatabase db, $RoutePointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RoutePointsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RoutePointsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> routeId = const Value.absent(),
            Value<String> locationName = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<DateTime> arrivalDate = const Value.absent(),
          }) =>
              RoutePointsCompanion(
            id: id,
            routeId: routeId,
            locationName: locationName,
            latitude: latitude,
            longitude: longitude,
            arrivalDate: arrivalDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int routeId,
            required String locationName,
            required double latitude,
            required double longitude,
            required DateTime arrivalDate,
          }) =>
              RoutePointsCompanion.insert(
            id: id,
            routeId: routeId,
            locationName: locationName,
            latitude: latitude,
            longitude: longitude,
            arrivalDate: arrivalDate,
          ),
        ));
}

class $$RoutePointsTableFilterComposer
    extends FilterComposer<_$LocalDatabase, $RoutePointsTable> {
  $$RoutePointsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get locationName => $state.composableBuilder(
      column: $state.table.locationName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get arrivalDate => $state.composableBuilder(
      column: $state.table.arrivalDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$RoutesTableFilterComposer get routeId {
    final $$RoutesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routeId,
        referencedTable: $state.db.routes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$RoutesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.routes, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$RoutePointsTableOrderingComposer
    extends OrderingComposer<_$LocalDatabase, $RoutePointsTable> {
  $$RoutePointsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get locationName => $state.composableBuilder(
      column: $state.table.locationName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get arrivalDate => $state.composableBuilder(
      column: $state.table.arrivalDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$RoutesTableOrderingComposer get routeId {
    final $$RoutesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routeId,
        referencedTable: $state.db.routes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$RoutesTableOrderingComposer(ComposerState(
                $state.db, $state.db.routes, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ClimateDayRecordsTableCreateCompanionBuilder
    = ClimateDayRecordsCompanion Function({
  required String cityId,
  required String month,
  required String year,
  Value<double?> tempMin,
  Value<double?> tempMax,
  Value<double?> precipitation,
  Value<double?> tempAvg,
  Value<double?> humidity,
  Value<double?> windSpeed,
  Value<int> rowid,
});
typedef $$ClimateDayRecordsTableUpdateCompanionBuilder
    = ClimateDayRecordsCompanion Function({
  Value<String> cityId,
  Value<String> month,
  Value<String> year,
  Value<double?> tempMin,
  Value<double?> tempMax,
  Value<double?> precipitation,
  Value<double?> tempAvg,
  Value<double?> humidity,
  Value<double?> windSpeed,
  Value<int> rowid,
});

class $$ClimateDayRecordsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $ClimateDayRecordsTable,
    ClimateDayRecord,
    $$ClimateDayRecordsTableFilterComposer,
    $$ClimateDayRecordsTableOrderingComposer,
    $$ClimateDayRecordsTableCreateCompanionBuilder,
    $$ClimateDayRecordsTableUpdateCompanionBuilder> {
  $$ClimateDayRecordsTableTableManager(
      _$LocalDatabase db, $ClimateDayRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ClimateDayRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$ClimateDayRecordsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> cityId = const Value.absent(),
            Value<String> month = const Value.absent(),
            Value<String> year = const Value.absent(),
            Value<double?> tempMin = const Value.absent(),
            Value<double?> tempMax = const Value.absent(),
            Value<double?> precipitation = const Value.absent(),
            Value<double?> tempAvg = const Value.absent(),
            Value<double?> humidity = const Value.absent(),
            Value<double?> windSpeed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClimateDayRecordsCompanion(
            cityId: cityId,
            month: month,
            year: year,
            tempMin: tempMin,
            tempMax: tempMax,
            precipitation: precipitation,
            tempAvg: tempAvg,
            humidity: humidity,
            windSpeed: windSpeed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cityId,
            required String month,
            required String year,
            Value<double?> tempMin = const Value.absent(),
            Value<double?> tempMax = const Value.absent(),
            Value<double?> precipitation = const Value.absent(),
            Value<double?> tempAvg = const Value.absent(),
            Value<double?> humidity = const Value.absent(),
            Value<double?> windSpeed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClimateDayRecordsCompanion.insert(
            cityId: cityId,
            month: month,
            year: year,
            tempMin: tempMin,
            tempMax: tempMax,
            precipitation: precipitation,
            tempAvg: tempAvg,
            humidity: humidity,
            windSpeed: windSpeed,
            rowid: rowid,
          ),
        ));
}

class $$ClimateDayRecordsTableFilterComposer
    extends FilterComposer<_$LocalDatabase, $ClimateDayRecordsTable> {
  $$ClimateDayRecordsTableFilterComposer(super.$state);
  ColumnFilters<String> get cityId => $state.composableBuilder(
      column: $state.table.cityId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get month => $state.composableBuilder(
      column: $state.table.month,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get year => $state.composableBuilder(
      column: $state.table.year,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempMin => $state.composableBuilder(
      column: $state.table.tempMin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempMax => $state.composableBuilder(
      column: $state.table.tempMax,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get precipitation => $state.composableBuilder(
      column: $state.table.precipitation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get tempAvg => $state.composableBuilder(
      column: $state.table.tempAvg,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get humidity => $state.composableBuilder(
      column: $state.table.humidity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get windSpeed => $state.composableBuilder(
      column: $state.table.windSpeed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ClimateDayRecordsTableOrderingComposer
    extends OrderingComposer<_$LocalDatabase, $ClimateDayRecordsTable> {
  $$ClimateDayRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get cityId => $state.composableBuilder(
      column: $state.table.cityId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get month => $state.composableBuilder(
      column: $state.table.month,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get year => $state.composableBuilder(
      column: $state.table.year,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempMin => $state.composableBuilder(
      column: $state.table.tempMin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempMax => $state.composableBuilder(
      column: $state.table.tempMax,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get precipitation => $state.composableBuilder(
      column: $state.table.precipitation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get tempAvg => $state.composableBuilder(
      column: $state.table.tempAvg,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get humidity => $state.composableBuilder(
      column: $state.table.humidity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get windSpeed => $state.composableBuilder(
      column: $state.table.windSpeed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
  $$RoutePointsTableTableManager get routePoints =>
      $$RoutePointsTableTableManager(_db, _db.routePoints);
  $$ClimateDayRecordsTableTableManager get climateDayRecords =>
      $$ClimateDayRecordsTableTableManager(_db, _db.climateDayRecords);
}
