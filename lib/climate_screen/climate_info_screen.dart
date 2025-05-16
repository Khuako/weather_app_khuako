import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_assistant/climate_screen/bloc/climate_cubit.dart';
import 'package:weather_assistant/climate_screen/model/city_climate_rating.dart';
import 'package:weather_assistant/climate_screen/widget/monthly_temperature_chart.dart';
import 'package:weather_assistant/climate_screen/widget/monthly_extremes_chart.dart';
import 'package:weather_assistant/ui/widgets/colors.dart';
import 'package:weather_assistant/ui/widgets/core/custom_loading_screen.dart';

class ClimateInfoScreen extends StatelessWidget {
  final String cityId;

  const ClimateInfoScreen({super.key, required this.cityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: BlocBuilder<ClimateCubit, ClimateState>(
          builder: (context, state) {
            if (state is ClimateLoaded) {
              final coords = state.cityId.split('_');
              final lat = double.parse(coords[0]);
              final lon = double.parse(coords[1]);
              return Text(
                'Климат-аналитика',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Text(
              'Климат-аналитика',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<ClimateCubit, ClimateState>(
        builder: (context, state) {
          if (state is ClimateLoading) {
            return Center(child: CustomLoadingScreen());
          } else if (state is ClimateError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is ClimateLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Локация',
                                style: GoogleFonts.rubik(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.cityName,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 394,
                    child: PageView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: MonthlyTemperatureChart(data: state.monthlyStats),
                        ),
                        MonthlyExtremesChart(data: state.extremeValues),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Идеальный месяц',
                                style: GoogleFonts.rubik(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatMonth(state.idealMonth?.month ?? ''),
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '🌤️',
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Экстремальные значения',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...state.extremeValues
                            .where((e) =>
                                (e.maxTemp != null && e.maxTemp != 0) ||
                                (e.minTemp != null && e.minTemp != 0) ||
                                (e.maxPrecipitation != null && e.maxPrecipitation != 0))
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            e.year.toString(),
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildExtremeValueRow(
                                                'Макс. температура',
                                                e.maxTemp != null
                                                    ? '${e.maxTemp!.toStringAsFixed(1)}°C'
                                                    : '—',
                                                Icons.thermostat,
                                              ),
                                              const SizedBox(height: 4),
                                              _buildExtremeValueRow(
                                                'Мин. температура',
                                                e.minTemp != null
                                                    ? '${e.minTemp!.toStringAsFixed(1)}°C'
                                                    : '—',
                                                Icons.thermostat_outlined,
                                              ),
                                              const SizedBox(height: 4),
                                              _buildExtremeValueRow(
                                                'Макс. осадки',
                                                '${e.maxPrecipitation?.toStringAsFixed(1)} мм',
                                                Icons.water_drop,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildClimateRating(state.climateRating),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'Загрузка данных...',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExtremeValueRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.rubik(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatMonth(String? month) {
    if (month == null) return '—';
    const names = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    final index = int.tryParse(month) ?? 1;
    return names[index - 1];
  }

  Widget _buildClimateRating(CityClimateRating rating) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(79, 79, 79, 1.0),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Рейтинг климата',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRatingItem(
                  'Температура',
                  rating.temperatureScore,
                  Icons.thermostat,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRatingItem(
                  'Осадки',
                  rating.precipitationScore,
                  Icons.water_drop,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRatingItem(
                  'Сезонность',
                  rating.seasonalityScore,
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRatingItem(
                  'Комфорт',
                  rating.comfortScore,
                  Icons.sentiment_satisfied,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getScoreColor(rating.overallScore).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Общий рейтинг',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  rating.overallScore.toInt().toString(),
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(rating.overallScore),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(String label, double score, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getScoreColor(score).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: _getScoreColor(score),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toInt().toString(),
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getScoreColor(score),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
