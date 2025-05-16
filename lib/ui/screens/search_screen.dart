import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/bloc/screens/favorite/favorite_info_bloc.dart';
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'package:weather_assistant/bloc/screens/search/change_map/change_map_bloc.dart';
import 'package:weather_assistant/climate_screen/climate_screen.dart';
import 'package:weather_assistant/config/api_keys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_assistant/config/config.dart';
import 'package:weather_assistant/ui/screens/notifs/weather_notifications_screen.dart';
import 'package:weather_assistant/ui/screens/favorite_screen.dart';
import 'package:weather_assistant/ui/screens/weather_routes/weather_routes_screen.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/search/get_data_field.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/search/search_field.dart';

const LatLng constMapPoint = LatLng(55.748886, 37.617209);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.mapPoint});
  final LatLng mapPoint;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late LatLng _mapPoint;
  MapController mapController = MapController();
  bool showPrecipitationLayer = false; // Состояние отображения слоя осадков

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _mapPoint = widget.mapPoint;
    getIt<FavoriteInfoBloc>().getFavCities();
    getIt<AllRoutesCubit>().fetchAllRoutes();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromRGBO(79, 79, 79, 1.0),
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: const Color(0xFF212121),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Избранное',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.star, color: Colors.yellow),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Климат-аналитика',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.thermostat, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClimateScreen()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Погодные маршруты',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(
                  Icons.route,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeatherRoutesScreen()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Уведомления',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeatherNotificationsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocListener<ChangeMapBloc, ChangeMapState>(
            listener: (context, state) {
              if (state is ChangeMapCenter) {
                mapController.move(state.mapCenter, 8.2);
                setState(() {
                  _mapPoint = state.mapCenter;
                });
              }
            },
            child: FlutterMap(
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
                  urlTemplate: 'https://maps.geoapify.com/v1/tile/positron/{z}/{x}/{y}'
                      '.png?apiKey=$mapApiKey',
                  errorTileCallback: (tile, error, stackTrace) {
                    print(error);
                  },
                ),
                if (showPrecipitationLayer)
                  TileLayer(
                    urlTemplate: 'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}'
                        '.png?appid=$openWeatherMap',
                    errorTileCallback: (tile, error, stackTrace) {
                      print("Ошибка загрузки слоя осадков: $error");
                    },
                  ),
                MarkerLayer(markers: [
                  Marker(
                    point: _mapPoint,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                      size: 32,
                    ),
                    width: 80.0,
                    height: 80.0,
                  ),
                ]),
                RichAttributionWidget(
                  animationConfig: const FadeRAWA(),
                  attributions: [
                    TextSourceAttribution(
                      'Geoapify',
                      textStyle: GoogleFonts.rubik(color: Colors.white70),
                      onTap: () => launchUrl(Uri.parse('https://www.geoapify.com/')),
                    ),
                    TextSourceAttribution(
                      'OpenMapTiles',
                      textStyle: GoogleFonts.rubik(color: Colors.white70),
                      onTap: () => launchUrl(Uri.parse('https://openmaptiles.org/')),
                    ),
                    TextSourceAttribution(
                      'OpenStreetMap',
                      textStyle: GoogleFonts.rubik(color: Colors.white70),
                      onTap: () => launchUrl(
                        Uri.parse('https://www.openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchField(
                onDrawerPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                showMenu: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: GetDataField(mapPoint: _mapPoint),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showPrecipitationLayer = !showPrecipitationLayer;
          });
        },
        backgroundColor: backgroundColor,
        child: Icon(
          showPrecipitationLayer ? Icons.cloud_off : Icons.cloud,
          color: Colors.white,
        ),
      ),
    );
  }
}
