// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../bloc/screens/favorite/favorite_info_bloc.dart' as _i4;
import '../bloc/screens/route/all_routes_cubit.dart' as _i6;
import '../data/repositories/route_repository.dart' as _i5;
import '../data/services/local_database.dart' as _i3;

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
    gh.lazySingleton<_i3.LocalDatabase>(() => _i3.LocalDatabase());
    gh.lazySingleton<_i4.FavoriteInfoBloc>(() => _i4.FavoriteInfoBloc());
    gh.lazySingleton<_i5.RouteRepository>(
        () => _i5.RouteRepository(gh<_i3.LocalDatabase>()));
    gh.lazySingleton<_i6.AllRoutesCubit>(
        () => _i6.AllRoutesCubit(repository: gh<_i5.RouteRepository>()));
    return this;
  }
}
