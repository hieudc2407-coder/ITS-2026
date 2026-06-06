import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../models/alert_model.dart';

class MockDataService {
  // Singleton pattern
  MockDataService._internal();
  static final MockDataService instance = MockDataService._internal();

  // Mock logged-in resident
  final UserModel currentUser = const UserModel(
    id: 'usr_001',
    name: 'Nguyen Van An',
    phone: '0901234567',
    apartmentNumber: 'A-1205',
  );

  // Mock vehicle list
  List<VehicleModel> getVehicles() => [
        VehicleModel(
          id: 'veh_001',
          type: VehicleType.car,
          licensePlate: '51G-123.45',
          color: 'White',
        ),
        VehicleModel(
          id: 'veh_002',
          type: VehicleType.motorcycle,
          licensePlate: '59P1-678.90',
          color: 'Black',
        ),
      ];

  // Mock alerts
  List<AlertModel> getAlerts() => [
        AlertModel(
          id: 'alt_001',
          licensePlate: '51G-123.45',
          location: 'Lobby A — Entrance Gate',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          message:
              'Your vehicle is parked illegally. Please move it immediately to avoid a penalty.',
          severity: AlertSeverity.critical,
        ),
        AlertModel(
          id: 'alt_002',
          licensePlate: '59P1-678.90',
          location: 'Basement B2 — Fire Exit',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
          message:
              'Your vehicle is parked illegally. Please move it immediately to avoid a penalty.',
          severity: AlertSeverity.critical,
        ),
        AlertModel(
          id: 'alt_003',
          licensePlate: '51G-123.45',
          location: 'Pool Area — No Parking Zone',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          message:
              'Your vehicle is parked in a restricted area. This is a courtesy warning.',
          severity: AlertSeverity.warning,
          isRead: true,
        ),
      ];
}