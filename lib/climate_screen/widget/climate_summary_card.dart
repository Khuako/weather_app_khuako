import 'package:flutter/material.dart';
import 'package:weather_assistant/climate_screen/model/ideal_month_result.dart';

class ClimateSummaryCard extends StatelessWidget {
  final IdealMonthResult? idealMonth;

  const ClimateSummaryCard({super.key, required this.idealMonth});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          idealMonth != null
              ? 'Идеальный месяц для посещения: ${idealMonth!.month}'
              : 'Нет подходящих данных для рекомендации',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
