import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/results/weather_info_bloc.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/ui/widgets/core/custom_network_image.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/results/error_data.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Future<void> _showConfirmationDialog(BuildContext context, WeatherResponse weatherModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить в избранное?'),
          content:
              Text('Вы точно хотите добавить город "${weatherModel.location.name}" в избранное?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoriteInfoBloc>().addCity(weatherModel.location.name);
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<WeatherInfoBloc, WeatherInfoState>(
        builder: (context, state) {
          if (state is WeatherInfoReceivedState) {
            return FloatingActionButton(
              onPressed: () => _showConfirmationDialog(context, state.weatherModel),
              child: const Icon(Icons.star),
            );
          } else {
            return const SizedBox.shrink(); // Hide FAB if no data
          }
        },
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 32,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<WeatherInfoBloc, WeatherInfoState>(
          builder: (context, state) {
            if (state is WeatherInfoLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is WeatherInfoReceivedState) {
              return _ContentWidget(
                weatherModel: state.weatherModel,
              );
            } else {
              return const ErrorData();
            }
          },
        ),
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  final WeatherResponse weatherModel;

  const _ContentWidget({required this.weatherModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            weatherModel.location.name.toString(),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 32),
          ),
          Text(
            weatherModel.current.tempC.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
            ),
          ),
          CustomNetworkImage(
            url: "https:${weatherModel.current.condition.icon}",
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Ощущается ${weatherModel.current.feelslikeC.toString()}°",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.water_drop_outlined,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "${weatherModel.current.humidity.toInt()}%",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.thermostat_outlined,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "${weatherModel.current!.pressureMb?.toInt()}Bar",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
              )
            ],
          ),
        ],
      ),
    );
  }
}

String degCelsius(double num) => "${num.toInt() - 273}°";
