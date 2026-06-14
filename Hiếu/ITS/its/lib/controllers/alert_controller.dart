import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/mock_data_service.dart';

class AlertController extends ChangeNotifier {
  late List<AlertModel> _alerts;

  AlertController() {
    _alerts = MockDataService.instance.getAlerts();
  }

  List<AlertModel> get alerts => List.unmodifiable(_alerts);

  int get unreadCount => _alerts.where((a) => !a.isRead).length;

  void markAsRead(String id) {
    final alert = _alerts.firstWhere((a) => a.id == id);
    alert.isRead = true;
    notifyListeners();
  }

  void markAllAsRead() {
    for (final a in _alerts) {
      a.isRead = true;
    }
    notifyListeners();
  }
}