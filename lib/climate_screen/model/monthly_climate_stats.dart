class MonthlyClimateStats {
  final String month; // "01" – "12"
  final double avgMin;
  final double avgMax;
  final int rainyDays;

  MonthlyClimateStats({
    required this.month,
    required this.avgMin,
    required this.avgMax,
    required this.rainyDays,
  });
}
