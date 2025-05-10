import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/bloc/screens/results/weather_info_bloc.dart';
import 'package:weather_assistant/ui/screens/results_screen.dart';

class GetDataField extends StatelessWidget {
  final LatLng mapPoint;

  const GetDataField({super.key, required this.mapPoint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: TextButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                Color.fromRGBO(79, 79, 79, 1.0),
              ),
              padding: MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 12, horizontal: 24))),
          onPressed: () {
            BlocProvider.of<WeatherInfoBloc>(context).add(GetWeatherInfoEvent(mapPoint: mapPoint));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ResultsScreen()),
            );
          },
          child: const Text(
            "Узнать погоду",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }
}
