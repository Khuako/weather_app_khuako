import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/bloc/screens/search/change_map/change_map_bloc.dart';
import 'package:weather_assistant/config/api_keys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_assistant/ui/screens/favorite/favorite_screen.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/search/get_data_field.dart';
import 'package:weather_assistant/ui/widgets/modules/screens/search/search_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LatLng _mapPoint = const LatLng(55.748886, 37.617209);
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Избранное'),
                leading: Icon(Icons.star),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
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
                      urlTemplate:
                          'https://maps.geoapify.com/v1/tile/positron/{z}/{x}/{y}.png?apiKey=$mapApiKey',
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
                      )
                    ]),
                    RichAttributionWidget(
                      animationConfig: const FadeRAWA(),
                      attributions: [
                        TextSourceAttribution(
                          textStyle: const TextStyle(fontSize: 16),
                          'Geoapify',
                          onTap: () => launchUrl(Uri.parse('https://www.geoapify.com/')),
                        ),
                        TextSourceAttribution(
                          textStyle: const TextStyle(fontSize: 16),
                          'OpenMapTiles',
                          onTap: () => launchUrl(Uri.parse('https://openmaptiles.org/')),
                        ),
                        TextSourceAttribution(
                          textStyle: const TextStyle(fontSize: 16),
                          'OpenStreetMap',
                          onTap: () =>
                              launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SearchField(),
                  GetDataField(mapPoint: _mapPoint),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
