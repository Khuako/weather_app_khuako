import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/results/weather_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/search/change_map/change_map_bloc.dart';
import 'package:weather_assistant/bloc/screens/search/search_info/search_info_bloc.dart';
import 'package:weather_assistant/ui/screens/search/search_screen.dart';

class WeatherAssistantApp extends StatelessWidget {
  const WeatherAssistantApp({super.key});

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
          value: FavoriteInfoBloc()..getFavCities(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: GoogleFonts.rubik.call().fontFamily),
        home: const SearchScreen(),
      ),
    );
  }
}
