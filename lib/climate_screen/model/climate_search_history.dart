class ClimateSearchHistory {
  final String cityId;
  final String cityName;
  final String stationId;
  final DateTime timestamp;

  ClimateSearchHistory({
    required this.cityId,
    required this.cityName,
    required this.stationId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'cityName': cityName,
      'stationId': stationId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ClimateSearchHistory.fromJson(Map<String, dynamic> json) {
    return ClimateSearchHistory(
      cityId: json['cityId'] as String,
      cityName: json['cityName'] as String,
      stationId: json['stationId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
