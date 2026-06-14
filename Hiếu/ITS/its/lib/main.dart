import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:its/controllers/auth_controller.dart';
import 'package:its/controllers/vehicle_controller.dart';
import 'package:its/controllers/alert_controller.dart';
import 'package:its/views/login_screen.dart';
import 'package:its/views/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.bgDeep,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => VehicleController()),
        ChangeNotifierProvider(create: (_) => AlertController()),
      ],
      child: const SmartParkingApp(),
    ),
  );
}
