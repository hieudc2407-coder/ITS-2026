import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:its/controllers/alert_controller.dart';
import 'package:its/views/app_theme.dart';
import 'package:its/views/tabs/home_tab.dart';
import 'package:its/views/tabs/vehicles_tab.dart';
import 'package:its/views/tabs/alerts_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const List<Widget> _tabs = [
    HomeTab(),
    VehiclesTab(),
    AlertsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<AlertController>().unreadCount;

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.borderGlass,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          elevation: 0,
          height: 68,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(Icons.directions_car_rounded),
              label: 'Vehicles',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  '$unreadCount',
                  style: GoogleFonts.poppins(fontSize: 9),
                ),
                backgroundColor: AppTheme.alertRed,
                child: const Icon(Icons.notifications_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  '$unreadCount',
                  style: GoogleFonts.poppins(fontSize: 9),
                ),
                backgroundColor: AppTheme.alertRed,
                child: const Icon(Icons.notifications_rounded),
              ),
              label: 'Alerts',
            ),
          ],
        ),
      ),
    );
  }
}