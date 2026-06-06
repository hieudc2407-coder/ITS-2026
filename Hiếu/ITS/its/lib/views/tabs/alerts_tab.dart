// ============================================================
// --- lib/views/tabs/alerts_tab.dart ---
// ============================================================
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:its/controllers/alert_controller.dart';
import 'package:its/models/alert_model.dart';
import 'package:its/views/app_theme.dart';
import 'package:its/views/widgets/gradient_button.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AlertController>();
    final alerts = ctrl.alerts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alerts',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          ctrl.unreadCount > 0
                              ? '${ctrl.unreadCount} unread notification${ctrl.unreadCount > 1 ? 's' : ''}'
                              : 'All caught up',
                          style: GoogleFonts.poppins(
                            color: ctrl.unreadCount > 0
                                ? AppTheme.alertRed.withOpacity(0.8)
                                : AppTheme.accentGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (ctrl.unreadCount > 0)
                    GestureDetector(
                      onTap: ctrl.markAllAsRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppTheme.accentBlue.withOpacity(0.25),
                              width: 1),
                        ),
                        child: Text(
                          'Mark all read',
                          style: GoogleFonts.poppins(
                            color: AppTheme.accentBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: alerts.isEmpty
                  ? _EmptyAlerts()
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: alerts.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _AlertCard(
                  alert: alerts[i],
                  index: i,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertModel alert;
  final int index;
  const _AlertCard({required this.alert, required this.index});

  @override
  Widget build(BuildContext context) {
    final isCritical = alert.severity == AlertSeverity.critical;
    final accentColor = isCritical ? AppTheme.alertRed : AppTheme.alertYellow;
    final timeStr =
    DateFormat('MMM d, HH:mm').format(alert.timestamp);

    return GestureDetector(
      onTap: () => context.read<AlertController>().markAsRead(alert.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: alert.isRead
                    ? Colors.white.withOpacity(0.03)
                    : accentColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: alert.isRead
                      ? AppTheme.borderSubtle
                      : accentColor.withOpacity(0.4),
                  width: alert.isRead ? 1 : 1.5,
                ),
                boxShadow: alert.isRead
                    ? null
                    : [
                  BoxShadow(
                    color: accentColor.withOpacity(0.12),
                    blurRadius: 20,
                    spreadRadius: -4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Severity icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: alert.isRead
                          ? Colors.white.withOpacity(0.04)
                          : accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: alert.isRead
                            ? AppTheme.borderSubtle
                            : accentColor.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: alert.isRead
                          ? null
                          : [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: Icon(
                      isCritical
                          ? Icons.warning_amber_rounded
                          : Icons.info_outline_rounded,
                      color: alert.isRead
                          ? AppTheme.textMuted
                          : accentColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plate + unread dot
                        Row(
                          children: [
                            if (!alert.isRead)
                              ShaderMask(
                                shaderCallback: (b) => LinearGradient(
                                  colors: [accentColor, accentColor.withOpacity(0.7)],
                                ).createShader(b),
                                child: Text(
                                  alert.licensePlate,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              )
                            else
                              Text(
                                alert.licensePlate,
                                style: GoogleFonts.poppins(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            if (!alert.isRead) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: accentColor,
                                        blurRadius: 5,
                                        spreadRadius: 0)
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Location
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 12,
                                color: alert.isRead
                                    ? AppTheme.textMuted
                                    : accentColor.withOpacity(0.7)),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                alert.location,
                                style: GoogleFonts.poppins(
                                  color: alert.isRead
                                      ? AppTheme.textMuted
                                      : accentColor.withOpacity(0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Message
                        Text(
                          alert.message,
                          style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Bottom row
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined,
                                size: 11, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              timeStr,
                              style: GoogleFonts.poppins(
                                color: AppTheme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (!alert.isRead)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: accentColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  isCritical ? 'CRITICAL' : 'WARNING',
                                  style: GoogleFonts.poppins(
                                    color: accentColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
        delay: Duration(milliseconds: 80 * index), duration: 500.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }
}

class _EmptyAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (b) =>
                AppTheme.primaryGradient.createShader(b),
            child: const Icon(Icons.notifications_off_outlined,
                size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'No alerts',
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You\'re all clear — no notifications',
            style: GoogleFonts.poppins(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}