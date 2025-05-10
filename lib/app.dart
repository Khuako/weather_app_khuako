import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/results/weather_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'package:weather_assistant/bloc/screens/search/change_map/change_map_bloc.dart';
import 'package:weather_assistant/bloc/screens/search/search_info/search_info_bloc.dart';
import 'package:weather_assistant/config/config.dart';
import 'package:weather_assistant/ui/screens/search_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class WeatherAssistantApp extends StatelessWidget {
  const WeatherAssistantApp({super.key, required this.loc});
  final LatLng loc;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchInfoBloc(),
        ),
        BlocProvider(
          create: (context) => ChangeMapBloc(),
        ),
        BlocProvider(
          create: (context) => WeatherInfoBloc(),
        ),
        BlocProvider.value(
          value: getIt<FavoriteInfoBloc>(),
        ),
        BlocProvider.value(
          value: getIt<AllRoutesCubit>(),
        )
      ],
      child: MaterialApp(
        supportedLocales: const [
          Locale('ru', ''), // Русский
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('ru', ''),
        debugShowCheckedModeBanner: false,
        home: SearchScreen(mapPoint: loc,),
      ),
    );
  }
}
