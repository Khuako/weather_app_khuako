import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:weather_assistant/bloc/screens/route/all_routes_cubit.dart';
import 'package:weather_assistant/bloc/screens/route/route_detail_cubit.dart';
import 'package:weather_assistant/data/models/daily_weather.dart';
import 'package:weather_assistant/data/services/local_database.dart';
import 'package:weather_assistant/ui/screens/weather_routes/add_route_screen.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:weather_assistant/ui/widgets/core/custom_loading_screen.dart';

class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({
    super.key,
    required this.points,
    required this.title,
    required this.routeId,
  });

  final List<RoutePoint> points;
  final String title;
  final int routeId;

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  Future<void> _generatePdf(
    BuildContext context,
    List<RoutePoint> points,
    String title,
    List<DailyWeather> weatherList,
  ) async {
    final pdf = pw.Document();

    // Загружаем шрифт с поддержкой кириллицы
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Заголовок маршрута
            pw.Text(
              title,
              style: pw.TextStyle(font: fontBold, fontSize: 26),
            ),
            pw.SizedBox(height: 16),

            // Перебираем точки маршрута
            for (int i = 0; i < points.length; i++)
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1, color: PdfColors.grey),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Локация: ${points[i].locationName}",
                      style: pw.TextStyle(font: fontBold, fontSize: 18),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      "Дата: ${DateFormat('dd MMMM yyyy', 'ru').format(points[i].arrivalDate)}",
                      style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey600),
                    ),
                    pw.SizedBox(height: 10),
                    if (i < weatherList.length)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          _buildWeatherRow(
                              "Макс. температура:", "${weatherList[i].maxTemp}°C", font),
                          _buildWeatherRow(
                              "Мин. температура:", "${weatherList[i].minTemp}°C", font),
                          _buildWeatherRow("Осадки:", "${weatherList[i].precipitation} мм", font),
                          _buildWeatherRow("Ветер:", "${weatherList[i].wind} км/ч", font),
                          if (weatherList[i].uv != null)
                            _buildWeatherRow("УФ (макс):", "${weatherList[i].uv}", font),
                          if (!weatherList[i].date.isBefore(DateTime.now()))
                            _buildWeatherRow("Вероятность осадков:",
                                "${weatherList[i].precipitationProbability}%", font),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    // Сохранение в локальный файл
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$title.pdf");
    await file.writeAsBytes(await pdf.save());

    // Открываем PDF
    await OpenFile.open(file.path);
  }

  /// Функция для красивого отображения строки с погодными параметрами
  pw.Widget _buildWeatherRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  font: font,
                  fontSize: 18,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 8),
          pw.Text(value,
              style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RouteDetailCubit()..getRoute(widget.points),
        child: BlocBuilder<RouteDetailCubit, RouteDetailState>(builder: (context, state) {
          if (state is RouteDetailInfo) {
            final dailyWeatherList = state.dailyWeather;
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
                actions: [
                  PopupMenuButton<String>(
                    color: grayBlack,
                    onSelected: (value) {
                      if (value == "edit") {
                        final points = widget.points.map((point) {
                          return RoutePointsCompanion(
                              arrivalDate: Value(point.arrivalDate),
                              latitude: Value(point.latitude),
                              longitude: Value(point.longitude),
                              locationName: Value(point.locationName));
                        }).toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRouteScreen(
                              routePoints: points,
                              routeId: widget.routeId,
                            ),
                          ),
                        );
                      }
                      if (value == 'pdf') {
                        _generatePdf(context, widget.points, widget.title, state.dailyWeather);
                      }
                      if (value == "delete") {
                        showDialog(
                          context: context,
                          builder: (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                backgroundColor: backgroundColor,
                                title: Text(
                                  'Удаление маршрута',
                                  style: GoogleFonts.rubik(color: Colors.white),
                                ),
                                content: Text(
                                  'Вы точно хотите удалить маршрут?',
                                  style: GoogleFonts.rubik(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Отмена",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<AllRoutesCubit>().deleteRoute(widget.routeId);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Удалить",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          "Изменить маршрут",
                          style: GoogleFonts.rubik(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pdf',
                        child: Text(
                          "Выгрузить маршрут",
                          style: GoogleFonts.rubik(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text(
                          "Удалить маршрут",
                          style: GoogleFonts.rubik(color: Colors.white),
                        ),
                      ),
                    ],
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
                title: Text(
                  widget.title,
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color(0xFF212121),
              ),
              backgroundColor: const Color(0xFF212121),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  itemCount: dailyWeatherList.length,
                  separatorBuilder: (context, index) => const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                    size: 32,
                  ),
                  itemBuilder: (context, index) {
                    final weather = dailyWeatherList[index];

                    return Card(
                      color: const Color(0xFF333333),
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  weather.name,
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMMM yyyy', 'ru').format(weather.date),
                                  style: GoogleFonts.rubik(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _WeatherInfoWithIcon(
                                  label: "Макс. температура",
                                  value: "${weather.maxTemp}°C",
                                  icon: Icons.thermostat_outlined,
                                ),
                                _WeatherInfoWithIcon(
                                  label: "Мин. температура",
                                  value: "${weather.minTemp}°C",
                                  icon: Icons.ac_unit,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _WeatherInfoWithIcon(
                                  label: "Осадки",
                                  value: "${weather.precipitation} мм",
                                  icon: Icons.water_drop,
                                ),
                                if (weather.wind != null)
                                  _WeatherInfoWithIcon(
                                    label: "Ветер",
                                    value: "${weather.wind} км/ч",
                                    icon: Icons.air_outlined,
                                  ),
                                if (weather.uv != null)
                                  _WeatherInfoWithIcon(
                                    label: "УФ (макс)",
                                    value: "${weather.uv!.toInt()}",
                                    icon: Icons.sunny,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (weather.date.isBefore(DateTime.now()) &&
                                weather.date.day != DateTime.now().day)
                              const SizedBox(height: 8)
                            else
                              Text(
                                "Вероятность осадков: ${weather.precipitationProbability}%",
                                style: GoogleFonts.rubik(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: const Color(0xFF212121),
              body: CustomLoadingScreen(),
            );
          }
        }));
  }
}

class _WeatherInfoWithIcon extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherInfoWithIcon({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.rubik(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
