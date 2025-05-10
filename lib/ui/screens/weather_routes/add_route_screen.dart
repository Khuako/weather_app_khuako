import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/config/api_keys.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/ui/screens/weather_routes/create_route_date_screen.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:weather_assistant/ui/widgets/core/toast.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/search/search_field.dart';

class AddRouteScreen extends StatefulWidget {
  const AddRouteScreen({super.key, this.routePoints, this.routeId});

  final List<RoutePointsCompanion>? routePoints;
  final int? routeId;
  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final MapController mapController = MapController();
  LatLng _mapPoint = const LatLng(55.748886, 37.617209); // Начальная точка
  List<LatLng> points = []; // Список точек маршрута
  void getPoints() {
    points = widget.routePoints!
        .map(
          (point) => LatLng(
            point.latitude.value,
            point.longitude.value,
          ),
        )
        .toList();
  }

  @override
  void initState() {
    if (widget.routePoints != null) {
      getPoints();
      _mapPoint = LatLng(
          widget.routePoints!.first.latitude.value, widget.routePoints!.first.longitude.value);
    }
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

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
          "Создание маршрута",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF212121),
      ),
      backgroundColor: const Color(0xFF212121),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _mapPoint,
              initialZoom: 8.2,
              onTap: (tapPosition, point) {
                setState(() {
                  _mapPoint = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://maps.geoapify.com/v1/tile/positron/{z}/{x}/{y}.png?apiKey=$mapApiKey',
              ),
              MarkerLayer(
                markers: [
                  ...points.map((point) => Marker(
                        point: point,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 32,
                        ),
                      )),
                  Marker(
                    point: _mapPoint,
                    child: const Icon(
                      Icons.location_on,
                      color: backgroundColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchField(
                onDrawerPressed: null,
                showMenu: false,
                changeLocation: (loc) {
                  mapController.move(loc, 9.0);
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
                    onPressed: () {
                      if (points.isEmpty) {
                        return showCustomToast(message: 'Выберите хотя бы 1 точку');
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateRouteDateScreen(
                            routeDetails: points,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Добавить точки',
                      style: GoogleFonts.rubik(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 60,
            height: 80,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        points.add(_mapPoint);
                      });
                    },
                    backgroundColor: grayBlack,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
                if (points.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        points.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
