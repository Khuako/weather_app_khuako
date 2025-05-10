class NotificationSettings {
  bool morningNotification;
  bool eveningNotification;
  bool severeWeatherAlerts;

  NotificationSettings({
    required this.morningNotification,
    required this.eveningNotification,
    required this.severeWeatherAlerts,
  });

  Map<String, dynamic> toJson() => {
    'morningNotification': morningNotification,
    'eveningNotification': eveningNotification,
    'severeWeatherAlerts': severeWeatherAlerts,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      morningNotification: json['morningNotification'] ?? true,
      eveningNotification: json['eveningNotification'] ?? true,
      severeWeatherAlerts: json['severeWeatherAlerts'] ?? true,
    );
  }
}
