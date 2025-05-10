import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/results/weather_info_bloc.dart';
import 'package:weather_assistant/config/config.dart';
import 'package:weather_assistant/ui/screens/results_screen.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:weather_assistant/ui/widgets/core/custom_network_image.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    getIt<FavoriteInfoBloc>().getFavCities();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getIt<FavoriteInfoBloc>().getFavCities(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Избранные города',
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: BlocBuilder<FavoriteInfoBloc, FavoriteInfoState>(
          builder: (context, state) {
            if (state is FavSuccess) {
              return ListView.builder(
                itemCount: state.cities.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    BlocProvider.of<WeatherInfoBloc>(context).add(
                      GetWeatherInfoEvent(
                        cityName: state.cities[index].location?.name,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResultsScreen()),
                    );
                  },
                  title: Text(
                    state.cities[index].location?.name ?? '',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomNetworkImage(
                            url: "https:${state.cities[index].current?.condition?.icon}"),
                        Text(
                          "${(state.cities[index].current!.tempC!.toInt())}°",
                          style: GoogleFonts.rubik(
                              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (state is FavError) {
              return Center(child: Text(state.error));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
