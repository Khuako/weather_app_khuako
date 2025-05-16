// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../bloc/screens/favorite/favorite_info_bloc.dart' as _i5;
import '../bloc/screens/route/all_routes_cubit.dart' as _i8;
import '../climate_screen/bloc/climate_cubit.dart' as _i10;
import '../climate_screen/data/climate_api_service.dart' as _i3;
import '../climate_screen/data/climate_respository.dart' as _i9;
import '../climate_screen/db/climate_dao.dart' as _i6;
import '../data/repositories/route_repository.dart' as _i7;
import '../data/services/local_database.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.ClimateApiService>(() => _i3.ClimateApiService());
    gh.lazySingleton<_i4.LocalDatabase>(() => _i4.LocalDatabase());
    gh.lazySingleton<_i5.FavoriteInfoBloc>(() => _i5.FavoriteInfoBloc());
    gh.lazySingleton<_i6.ClimateDao>(
        () => _i6.ClimateDao(gh<_i4.LocalDatabase>()));
    gh.lazySingleton<_i7.RouteRepository>(
        () => _i7.RouteRepository(gh<_i4.LocalDatabase>()));
    gh.lazySingleton<_i8.AllRoutesCubit>(
        () => _i8.AllRoutesCubit(repository: gh<_i7.RouteRepository>()));
    gh.lazySingleton<_i9.ClimateRepository>(() => _i9.ClimateRepository(
          gh<_i6.ClimateDao>(),
          gh<_i3.ClimateApiService>(),
        ));
    gh.factory<_i10.ClimateCubit>(
        () => _i10.ClimateCubit(gh<_i9.ClimateRepository>()));
    return this;
  }
}
