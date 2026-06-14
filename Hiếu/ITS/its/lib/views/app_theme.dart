import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:its/views/login_screen.dart';

class AppTheme {
  // Background palette
  static const Color bgDeep = Color(0xFF080C14);
  static const Color bgBase = Color(0xFF0B0F1C);
  static const Color bgSurface = Color(0xFF10162A);
  static const Color bgCard = Color(0xFF131929);

  // Accent palette
  static const Color accentBlue = Color(0xFF3D8EFF);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color accentGreen = Color(0xFF10B981);

  // Alert colors
  static const Color alertRed = Color(0xFFFF4560);
  static const Color alertYellow = Color(0xFFFFB800);

  // Text palette
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8B95B0);
  static const Color textMuted = Color(0xFF3D4A6B);

  // Border
  static const Color borderGlass = Color(0x1A3D8EFF);
  static const Color borderSubtle = Color(0x0DFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [accentBlue, accentPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0B0F1C), Color(0xFF060A14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGlowBlue = LinearGradient(
    colors: [Color(0x1A3D8EFF), Color(0x063D8EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowPurple = LinearGradient(
    colors: [Color(0x1A8B5CF6), Color(0x068B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgBase,
    colorScheme: const ColorScheme.dark(
      primary: accentBlue,
      secondary: accentPurple,
      surface: bgSurface,
      error: alertRed,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: textSecondary, displayColor: textPrimary),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0A0E1A),
      indicatorColor: accentBlue.withOpacity(0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.poppins(
            color: accentBlue,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          );
        }
        return GoogleFonts.poppins(
          color: textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: accentBlue, size: 22);
        }
        return const IconThemeData(color: textMuted, size: 22);
      }),
    ),
    dividerColor: Colors.transparent,
    useMaterial3: true,
  );
}

class SmartParkingApp extends StatelessWidget {
  const SmartParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
