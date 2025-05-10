import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'package:weather_assistant/bloc/screens/route/create_route_cubit.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/ui/screens/weather_routes/route_detail_screen.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:weather_assistant/ui/widgets/core/custom_loading_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateRouteDateScreen extends StatefulWidget {
  final List<LatLng> routeDetails;
  final int? routeId;

  const CreateRouteDateScreen({super.key, required this.routeDetails, this.routeId});

  @override
  State<CreateRouteDateScreen> createState() => _CreateRouteDateScreenState();
}

class _CreateRouteDateScreenState extends State<CreateRouteDateScreen> {
  Map<int, DateTime?> selectedDates = {};

  @override
  void initState() {
    super.initState();
    // Инициализируем даты пустыми значениями
    for (int i = 0; i < widget.routeDetails.length; i++) {
      selectedDates[i] = null;
    }
  }

  /// Обработка выбора даты
  void _selectDate(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 16)),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDates[index] = pickedDate;
      });
    }
  }

  /// Отправка запросов на Open-Meteo API
  Future<List<Map<String, dynamic>>> fetchRouteWeather() async {
    List<Map<String, dynamic>> weatherData = [];
    for (int i = 0; i < widget.routeDetails.length; i++) {
      final point = widget.routeDetails[i];
      final date = selectedDates[i];

      if (date != null) {
        final Uri url = Uri.parse(
            'https://api.open-meteo.com/v1/forecast?latitude=${point.latitude}&longitude=${point.longitude}&daily=temperature_2m_max,temperature_2m_min&start_date=${date.toIso8601String().substring(0, 10)}&end_date=${date.toIso8601String().substring(0, 10)}&timezone=auto');

        try {
          final response = await http.get(url);
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            weatherData.add({
              'location': 'Точка ${i + 1}', // Название точки (можно заменить на данные API)
              'date': date,
              'maxTemp': data['daily']['temperature_2m_max'][0],
              'minTemp': data['daily']['temperature_2m_min'][0],
            });
          } else {
            weatherData.add({'error': 'Ошибка при запросе точки ${i + 1}'});
          }
        } catch (e) {
          weatherData.add({'error': 'Ошибка сети для точки ${i + 1}'});
        }
      }
    }
    return weatherData;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRouteCubit()..fetchLocations(widget.routeDetails),
      child: BlocBuilder<CreateRouteCubit, CreateRouteState>(
        builder: (context, state) {
          if (state is CreateRouteDatePicker) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                title: Text(
                  "Детали маршрута",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color(0xFF212121),
              ),
              backgroundColor: const Color(0xFF212121),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Выберите дату прибытия для каждой точки маршрута.",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.allLocations.length,
                      itemBuilder: (context, index) {
                        final route = state.allLocations[index];
                        final date = selectedDates[index];
                        return Card(
                          color: const Color(0xFF333333),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                              route.location?.name ?? '',
                              style: GoogleFonts.rubik(color: Colors.white),
                            ),
                            subtitle: Text(
                              date != null
                                  ? "Дата прибытия: ${date.day}.${date.month}.${date.year}"
                                  : "Дата не выбрана",
                              style: GoogleFonts.rubik(color: Colors.white70),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _selectDate(context, index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightBlack.withOpacity(.4),
                              ),
                              child: Text(
                                "Выбрать дату",
                                style: GoogleFonts.rubik(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Проверяем, выбраны ли все даты
                          if (selectedDates.values.any((date) => date == null)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Пожалуйста, выберите даты для всех точек маршрута.",
                                ),
                              ),
                            );
                            return;
                          }
                          final List<RoutePointDto> routes = [];
                          for (int i = 0; i < state.allLocations.length; i++) {
                            final location = state.allLocations[i];
                            final date = selectedDates[i];
                            routes.add(RoutePointDto(
                              locationName: location.location?.name ?? '',
                              arrivalDate: date!,
                              latitude: location.location?.lat ?? 0,
                              longitude: location.location?.lon ?? 0,
                            ));
                          }
                          late final Map<String, dynamic> route;
                          if (widget.routeId != null) {
                            route = await context
                                .read<CreateRouteCubit>()
                                .editRoute(widget.routeId!, routes);
                          } else {
                            route = await context.read<CreateRouteCubit>().createRoute(routes);
                          }
                          context.read<AllRoutesCubit>().fetchAllRoutes();
                          Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              final List<RoutePoint> points = [];
                              for (var point in route['points']) {
                                points.add(RoutePoint(
                                  id: 0,
                                  locationName: point['locationName'],
                                  latitude: point['latitude'],
                                  longitude: point['longitude'],
                                  arrivalDate: point['arrivalDate'],
                                  routeId: 0,
                                ));
                              }

                              return RouteDetailScreen(
                                points: points,
                                title: route['routeName'],
                                routeId: route['routeId'],
                              );
                            }),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightBlack.withOpacity(.16),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          "${widget.routeId != null ? "Изменить" : "Создать"} маршрут",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return CustomLoadingScreen();
        },
      ),
    );
  }
}
