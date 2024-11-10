import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/ui/screens/results/results_screen.dart';
import 'package:weather_assistant/ui/widgets/core/custom_network_image.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<FavoriteInfoBloc>().getFavCities(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left,
              size: 32,
            ),
          ),
        ),
        body: BlocBuilder<FavoriteInfoBloc, FavoriteInfoState>(
          builder: (context, state) {
            if (state is FavSuccess) {
              return ListView.builder(
                itemCount: state.cities.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(state.cities[index].location.name ?? ''),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomNetworkImage(
                            url:
                            "https:/${state.cities[index].current.condition?.icon
                                .toString()
                            }"),
                        Text(
                          "${(state.cities[index].current!.tempC!.toInt())}",
                          style:
                          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors
                              .black),
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
