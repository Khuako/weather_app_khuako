import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'package:weather_assistant/bloc/screens/route/create_route_cubit.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/ui/screens/weather_routes/add_route_screen.dart';
import 'package:weather_assistant/ui/screens/weather_routes/create_route_date_screen.dart';
import 'package:weather_assistant/ui/screens/weather_routes/route_detail_screen.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:weather_assistant/ui/widgets/core/custom_loading_screen.dart';
import 'package:intl/intl.dart';

class WeatherRoutesScreen extends StatelessWidget {
  const WeatherRoutesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Погодные маршруты",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF212121),
      ),
      backgroundColor: const Color(0xFF212121),
      body: BlocBuilder<AllRoutesCubit, AllRoutesState>(
        builder: (context, state) {
          if (state is AllRoutesLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<AllRoutesCubit>().fetchAllRoutes(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.routes.length,
                      itemBuilder: (context, index) {
                        final route = state.routes[index];

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: grayBlack.withOpacity(.5),
                          child: ListTile(
                            title: Text(
                              route['routeName'],
                              maxLines: 3,
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            titleTextStyle: GoogleFonts.rubik(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            subtitle: Text(
                              'Начало: ${DateFormat('dd-MM-yyyy').format(route['points'][0]['arrivalDate'])}',
                              style: GoogleFonts.rubik(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              // Пока просто выводим сообщение
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
                                    routeId:  route['routeId'],
                                  );
                                }),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Пока просто выводим сообщение
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const AddRouteScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightBlack.withOpacity(.5),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text(
                          "Создать маршрут",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
