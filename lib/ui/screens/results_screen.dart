import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/results/weather_info_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:weather_assistant/ui/widgets/core/custom_loading_screen.dart';
import 'package:weather_assistant/ui/widgets/core/custom_network_image.dart';
import 'package:weather_assistant/ui/widgets/core/substrate.dart';
import 'package:weather_assistant/ui/widgets/core/toast.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/results/temperature_chart.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int forIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherInfoBloc, WeatherInfoState>(builder: (context, state) {
      if (state is WeatherInfoReceivedState) {
        final city = state.weatherModel.current;
        final cityName = state.weatherModel.location?.name ?? '';
        final forecast = state.weatherForecast3days.forecast?.forecastDay ?? [];
        List<CurrentWeather> allHours = [];
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF212121),
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          backgroundColor: const Color(0xFF212121),
          body: SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            cityName,
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              state.isFavored ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              if (state.isFavored) {
                                context.read<FavoriteInfoBloc>().deleteCity(cityName);
                                showCustomToast(
                                    message: 'Город удален из избранных',
                                    gravity: ToastGravity.BOTTOM);
                              } else {
                                context.read<FavoriteInfoBloc>().addCity(cityName);
                                showCustomToast(
                                    message: 'Город добавлен в избранные',
                                    gravity: ToastGravity.BOTTOM);
                              }
                              BlocProvider.of<WeatherInfoBloc>(context).add(
                                GetWeatherInfoEvent(
                                  cityName: cityName,
                                ),
                              );
                              // setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Карточка основной информации
                      Substrate(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd MMMM, HH:mm', 'ru').format(DateTime.now()),
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city?.condition?.text ?? '',
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${city?.tempC?.floor()}°C",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 106,
                                  child: CustomNetworkImage(
                                    url: "https:${city?.condition?.icon}",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "Ощущается как: ${"${getFeelsLikeTemperature(
                                    temperatureC: city?.tempC ?? 0,
                                    windKph: city?.windKph ?? 0,
                                    humidityPercent: city?.humidity?.toDouble() ?? 0,
                                  ).round()}°C"}",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Substrate(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        radius: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _DetailInfo(
                              icon: Icons.air_outlined,
                              color: Colors.white,
                              value: "${city?.windMph} м/с",
                              label: "Ветер",
                            ),
                            _DetailInfo(
                              icon: Icons.water_drop_outlined,
                              color: Colors.white,
                              value: "${city?.humidity}%",
                              label: "Влага",
                            ),
                            _DetailInfo(
                              icon: Icons.wb_sunny_outlined,
                              color: Colors.white,
                              value: "${city?.uv?.floor()}",
                              label: "УФ",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Навигация по дням
                      Row(
                        children: [
                          _AnimatedTabItem(
                            label: "Сегодня",
                            isSelected: forIndex == 0,
                            onTap: () => setState(() => forIndex = 0),
                          ),
                          const SizedBox(width: 24),
                          _AnimatedTabItem(
                            label: "Завтра",
                            isSelected: forIndex == 1,
                            onTap: () => setState(() => forIndex = 1),
                          ),
                          const SizedBox(width: 24),
                          _AnimatedTabItem(
                            label: "3 дня",
                            isSelected: forIndex == 2,
                            onTap: () => setState(() => forIndex = 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Приветственное сообщение
                const SizedBox(height: 24),
                // Почасовой прогноз
                SizedBox(
                  height: 172,
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        allHours = [];
                        if (forIndex == 2) {
                          for (final day in forecast) {
                            allHours.addAll(day.hour ?? []);
                          }
                        }
                        final hour = switch (forIndex) {
                          0 => forecast[0].hour?[index],
                          1 => forecast[1].hour?[index],
                          2 => allHours[index],
                          _ => null,
                        };
                        return _HourlyWeatherCard(
                          icon: "${hour?.condition?.icon}",
                          hour: DateFormat('HH:mm E', 'ru').format(DateTime.parse(hour?.time ??
                              ''
                                  '')),
                          temperature: "${hour?.tempC?.floor()}°C",
                        );
                      },
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 12,
                          ),
                      itemCount: switch (forIndex) {
                        0 => forecast[0].hour?.length ?? 0,
                        1 => forecast[2].hour?.length ?? 0,
                        2 =>
                          (state.weatherForecast3days.forecast?.forecastDay?.first.hour?.length ??
                                  0) +
                              (state.weatherForecast3days.forecast?.forecastDay?[1].hour?.length ??
                                  0) +
                              (state.weatherForecast3days.forecast?.forecastDay?[2].hour?.length ??
                                  0),
                        _ => 0,
                      }),
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: TemperatureChart(
                        hourlyData: forIndex == 0
                            ? forecast[0].hour ?? []
                            : forIndex == 1
                                ? forecast[1].hour ?? []
                                : (forecast[0].hour ?? []) +
                                    (forecast[1].hour ?? []) +
                                    (forecast[2].hour ?? []),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }
      return Scaffold(backgroundColor: const Color(0xFF212121), body: CustomLoadingScreen());
    });
  }
}

class _DetailInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DetailInfo({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.rubik(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _AnimatedTabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedTabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.rubik(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _HourlyWeatherCard extends StatelessWidget {
  final String hour;
  final String temperature;
  final String icon;

  const _HourlyWeatherCard({
    required this.hour,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Substrate(
      radius: 16,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hour,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.network(
            icon,
          ),
          Text(
            temperature,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

double calculateWindChill({
  required double temperatureC,
  required double windKph,
}) {
  final v = windKph;
  final t = temperatureC;
  return 13.12 + 0.6215 * t - 11.37 * pow(v, 0.16) + 0.3965 * t * pow(v, 0.16);
}

double calculateHeatIndex({
  required double temperatureC,
  required double humidityPercent,
}) {
  final T = temperatureC;
  final RH = humidityPercent;

  const c1 = -8.78469475556;
  const c2 = 1.61139411;
  const c3 = 2.33854883889;
  const c4 = -0.14611605;
  const c5 = -0.012308094;
  const c6 = -0.0164248277778;
  const c7 = 0.002211732;
  const c8 = 0.00072546;
  const c9 = -0.000003582;

  return c1 +
      c2 * T +
      c3 * RH +
      c4 * T * RH +
      c5 * T * T +
      c6 * RH * RH +
      c7 * T * T * RH +
      c8 * T * RH * RH +
      c9 * T * T * RH * RH;
}

double getFeelsLikeTemperature({
  required double temperatureC,
  required double windKph,
  required double humidityPercent,
}) {
  if (temperatureC >= 27) {
    return calculateHeatIndex(
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
    );
  } else {
    return calculateWindChill(
      temperatureC: temperatureC,
      windKph: windKph,
    );
  }
}
