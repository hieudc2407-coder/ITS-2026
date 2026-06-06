// ============================================================
// --- lib/views/login_screen.dart ---
// ============================================================
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:its/controllers/auth_controller.dart';
import 'package:its/views/main_screen.dart';
import 'package:its/views/app_theme.dart';
import 'package:its/views/widgets/gradient_button.dart';
import 'package:its/views/widgets/cyber_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  late AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthController>();
    final ok = await auth.login(_phoneController.text, _passController.text);
    if (ok && mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const MainScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthController>().isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Stack(
        children: [
          // Animated background orbs
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final t = _orbController.value;
              return Stack(children: [
                Positioned(
                  top: -80 + 30 * math.sin(t * 2 * math.pi),
                  left: -60 + 20 * math.cos(t * 2 * math.pi),
                  child: _Orb(
                    size: 280,
                    color: AppTheme.accentBlue.withOpacity(0.15),
                  ),
                ),
                Positioned(
                  bottom: 100 + 20 * math.sin(t * 2 * math.pi + 1),
                  right: -80,
                  child: _Orb(
                    size: 240,
                    color: AppTheme.accentPurple.withOpacity(0.12),
                  ),
                ),
                Positioned(
                  top: size.height * 0.45,
                  left: size.width * 0.3,
                  child: _Orb(
                    size: 150,
                    color: AppTheme.accentCyan.withOpacity(0.06),
                  ),
                ),
              ]);
            },
          ),

          // Subtle grid overlay
          CustomPaint(
            size: size,
            painter: _GridPainter(),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // Logo mark
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentBlue.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_parking_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMART PARK',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'RESIDENT PORTAL',
                            style: GoogleFonts.poppins(
                              color: AppTheme.accentBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2, curve: Curves.easeOut),

                  const SizedBox(height: 64),

                  Text(
                    'Welcome\nBack.',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 42,
                      height: 1.1,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 600.ms)
                      .slideY(begin: 0.2, curve: Curves.easeOut),

                  const SizedBox(height: 8),
                  Text(
                    'Sign in to manage your parking.',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 600.ms),

                  const SizedBox(height: 52),

                  // Phone field
                  _FieldLabel('Phone Number')
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 8),
                  CyberTextField(
                    controller: _phoneController,
                    hint: '0901 234 567',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 500.ms)
                      .slideX(begin: -0.05),

                  const SizedBox(height: 20),

                  _FieldLabel('Password')
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 8),
                  CyberTextField(
                    controller: _passController,
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                  )
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 500.ms)
                      .slideX(begin: -0.05),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.poppins(
                          color: AppTheme.accentBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 380.ms, duration: 400.ms),

                  const SizedBox(height: 28),

                  GradientButton(
                    label: 'Sign In',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _handleLogin,
                  )
                      .animate()
                      .fadeIn(delay: 420.ms, duration: 500.ms)
                      .slideY(begin: 0.3, curve: Curves.easeOut),

                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Smart Apartment Parking  ·  v1.0',
                      style: GoogleFonts.poppins(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.018)
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}