import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_assistant/data/models/weather_model.dart';
import 'package:intl/intl.dart';
class TemperatureChart extends StatelessWidget {
  final List<CurrentWeather> hourlyData;

  const TemperatureChart({Key? key, required this.hourlyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Фильтруем данные, оставляя только каждые третьи точки
    final filteredData = hourlyData
        .asMap()
        .entries
        .where((entry) => entry.key % 3 == 0) // Интервал в 3 точки
        .map((entry) => entry.value)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(
            show: false,
            border: const Border(
              bottom: BorderSide(color: Colors.white, width: 1),
              left: BorderSide(color: Colors.white, width: 1),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: filteredData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.tempC ?? 0,
              ))
                  .toList(),
              isStrokeCapRound: true,
              barWidth: 3,
              color: const Color(0xFFBDBDBD),
              belowBarData: BarAreaData(
                show: true,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFBDBDBD),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: const Color(0xFFBDBDBD),
                    strokeColor: Colors.black,
                    strokeWidth: 0,
                  );
                },
              ),
            ),
          ],
          lineTouchData: LineTouchData(

            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 8,
              getTooltipColor: (touchedSpot) => Colors.white,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final hour = filteredData[spot.x.toInt()];
                  return LineTooltipItem(
                    '${DateFormat('HH:mm EE', 'ru').format(DateTime.fromMillisecondsSinceEpoch(hour
                        .timeEpoch! * 1000))}\n${hour.tempC?.floor()}°C',
                    const TextStyle(color: Color(0xFF212121)),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
