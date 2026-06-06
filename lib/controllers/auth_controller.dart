import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/mock_data_service.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate a network delay for realistic UX
    await Future.delayed(const Duration(milliseconds: 800));

    // Bypassed auth: always succeeds
    _currentUser = MockDataService.instance.currentUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
