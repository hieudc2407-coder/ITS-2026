enum AlertSeverity { warning, critical }

class AlertModel {
  final String id;
  final String licensePlate;
  final String location;
  final DateTime timestamp;
  final String message;
  final AlertSeverity severity;
  bool isRead;

  AlertModel({
    required this.id,
    required this.licensePlate,
    required this.location,
    required this.timestamp,
    required this.message,
    required this.severity,
    this.isRead = false,
  });
}