import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/mock_data_service.dart';

class VehicleController extends ChangeNotifier {
  late List<VehicleModel> _vehicles;

  VehicleController() {
    _vehicles = MockDataService.instance.getVehicles();
  }

  List<VehicleModel> get vehicles => List.unmodifiable(_vehicles);

  int get vehicleCount => _vehicles.length;

  void addVehicle({
    required VehicleType type,
    required String licensePlate,
    required String color,
  }) {
    final newVehicle = VehicleModel(
      id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      licensePlate: licensePlate.toUpperCase(),
      color: color,
    );
    _vehicles.add(newVehicle);
    notifyListeners();
  }

  void removeVehicle(String id) {
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }
}