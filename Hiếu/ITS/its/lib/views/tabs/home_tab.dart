import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:its/controllers/auth_controller.dart';
import 'package:its/controllers/vehicle_controller.dart';
import 'package:its/controllers/alert_controller.dart';
import 'package:its/views/app_theme.dart';
import 'package:its/views/widgets/glass_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user         = context.watch<AuthController>().currentUser;
    final vehicleCount = context.watch<VehicleController>().vehicleCount;
    final unreadCount  = context.watch<AlertController>().unreadCount;
    final firstName    = user?.name.split(' ').last ?? 'Resident';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentBlue.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $firstName',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                              ),
                            ),
                            Text(
                              'Apt ${user?.apartmentNumber ?? '—'}  ·  ${_today()}',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentBlue.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            firstName[0].toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.15, curve: Curves.easeOut),

                  const SizedBox(height: 28),

                  // Status Banner
                  _StatusBanner()
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 500.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOut),

                  const SizedBox(height: 24),

                  // Section label
                  _SectionLabel('Quick Summary')
                      .animate()
                      .fadeIn(delay: 180.ms, duration: 400.ms),
                  const SizedBox(height: 14),

                  // Summary cards row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.directions_car_rounded,
                          value: '$vehicleCount',
                          label: 'Registered\nVehicles',
                          accentColor: AppTheme.accentBlue,
                          gradient: AppTheme.cardGlowBlue,
                        ).animate()
                            .fadeIn(delay: 250.ms, duration: 500.ms)
                            .slideX(begin: -0.1, curve: Curves.easeOut),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.notifications_active_rounded,
                          value: '$unreadCount',
                          label: 'Unread\nAlerts',
                          accentColor: unreadCount > 0
                              ? AppTheme.alertRed
                              : AppTheme.accentGreen,
                          gradient: unreadCount > 0
                              ? const LinearGradient(colors: [
                            Color(0x1AFF4560),
                            Color(0x06FF4560)
                          ])
                              : const LinearGradient(colors: [
                            Color(0x1A10B981),
                            Color(0x0610B981)
                          ]),
                        ).animate()
                            .fadeIn(delay: 300.ms, duration: 500.ms)
                            .slideX(begin: 0.1, curve: Curves.easeOut),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  _SectionLabel('Parking Reminders')
                      .animate()
                      .fadeIn(delay: 360.ms, duration: 400.ms),
                  const SizedBox(height: 14),

                  ..._reminders.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ReminderRow(
                        icon: e.value.$1,
                        text: e.value.$2,
                      ).animate()
                          .fadeIn(
                          delay: Duration(milliseconds: 420 + e.key * 60),
                          duration: 400.ms)
                          .slideX(begin: 0.08, curve: Curves.easeOut),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _today() {
    final now = DateTime.now();
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month]} ${now.day}, ${now.year}';
  }

  static const _reminders = [
    (Icons.access_time_rounded, 'Visitor parking is limited to 4 hours per day.'),
    (Icons.block_rounded, 'Do not park in fire exit lanes — violators will be fined.'),
    (Icons.camera_alt_rounded, 'Surveillance cameras are active 24/7 in all zones.'),
  ];
}

class _StatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A2E50), Color(0xFF0F1E38)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.borderGlass, width: 1),
        ),
        child: Stack(
          children: [
            // Decorative scan line
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(120, 100),
                painter: _ScanLinePainter(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGreen,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SYSTEM ACTIVE',
                      style: GoogleFonts.poppins(
                        color: AppTheme.accentGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'All Clear',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'No active violations detected',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentBlue.withOpacity(0.06)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height * 2; y += 8) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - size.width), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accentColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      gradient: gradient,
      borderColor: accentColor.withOpacity(0.25),
      shadows: [
        BoxShadow(
          color: accentColor.withOpacity(0.08),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: accentColor,
              fontWeight: FontWeight.w800,
              fontSize: 32,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ReminderRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      borderRadius: 14,
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.accentBlue.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: AppTheme.textSecondary,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        color: AppTheme.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }
}