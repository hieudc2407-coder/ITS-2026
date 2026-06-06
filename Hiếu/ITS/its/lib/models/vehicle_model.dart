enum VehicleType { car, motorcycle }

class VehicleModel {
  final String id;
  final VehicleType type;
  final String licensePlate;
  final String color;

  VehicleModel({
    required this.id,
    required this.type,
    required this.licensePlate,
    required this.color,
  });

  String get typeLabel => type == VehicleType.car ? 'Car' : 'Motorcycle';

  String get typeIcon => type == VehicleType.car ? '🚗' : '🏍️';
}