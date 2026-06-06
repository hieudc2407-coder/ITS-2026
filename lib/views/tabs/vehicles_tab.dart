import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:its/controllers/vehicle_controller.dart';
import 'package:its/models/vehicle_model.dart';
import 'package:its/views/app_theme.dart';
import 'package:its/views/widgets/glass_card.dart';
import 'package:its/views/widgets/gradient_button.dart';
import 'package:its/views/widgets/cyber_text_field.dart';

class VehiclesTab extends StatelessWidget {
  const VehiclesTab({super.key});

  void _showAddSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddVehicleSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = context.watch<VehicleController>().vehicles;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // App bar area
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Vehicles',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          '${vehicles.length} vehicle${vehicles.length == 1 ? '' : 's'} registered',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FAB inline
                  GestureDetector(
                    onTap: () => _showAddSheet(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentBlue.withOpacity(0.45),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),
            ),

            const SizedBox(height: 24),

            // List
            Expanded(
              child: vehicles.isEmpty
                  ? _EmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: vehicles.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 14),
                itemBuilder: (ctx, i) => _VehicleCard(
                  vehicle: vehicles[i],
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

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final int index;
  const _VehicleCard({required this.vehicle, required this.index});

  @override
  Widget build(BuildContext context) {
    final isCar = vehicle.type == VehicleType.car;
    final accent = isCar ? AppTheme.accentBlue : AppTheme.accentPurple;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      gradient: LinearGradient(
        colors: [accent.withOpacity(0.09), accent.withOpacity(0.03)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: accent.withOpacity(0.3),
      borderWidth: 1,
      shadows: [
        BoxShadow(
          color: accent.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: -4,
          offset: const Offset(0, 6),
        ),
      ],
      child: Row(
        children: [
          // Vehicle icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withOpacity(0.2), width: 1),
            ),
            child: Center(
              child: Text(
                vehicle.typeIcon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glowing plate text
                ShaderMask(
                  shaderCallback: (b) =>
                      AppTheme.primaryGradient.createShader(b),
                  child: Text(
                    vehicle.licensePlate,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _Tag(vehicle.typeLabel, accent),
                    const SizedBox(width: 6),
                    _Tag(vehicle.color, AppTheme.accentCyan),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                color: AppTheme.alertRed.withOpacity(0.7), size: 20),
            onPressed: () =>
                context.read<VehicleController>().removeVehicle(vehicle.id),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
        delay: Duration(milliseconds: 80 * index), duration: 500.ms)
        .slideY(begin: 0.12, curve: Curves.easeOut);
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_transfer_rounded,
              size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 16),
          Text(
            'No vehicles registered',
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + to add your first vehicle',
            style: GoogleFonts.poppins(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

// Add Vehicle Bottom Sheet
class _AddVehicleSheet extends StatefulWidget {
  const _AddVehicleSheet();

  @override
  State<_AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends State<_AddVehicleSheet> {
  final _plateCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  VehicleType _type = VehicleType.car;

  @override
  void dispose() {
    _plateCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      context.read<VehicleController>().addVehicle(
        type: _type,
        licensePlate: _plateCtrl.text.trim(),
        color: _colorCtrl.text.trim(),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.bgCard,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  color: AppTheme.accentGreen, size: 18),
              const SizedBox(width: 10),
              Text(
                'Vehicle added successfully!',
                style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xF00B0F1C),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppTheme.borderGlass, width: 1),
          ),
          padding: EdgeInsets.only(
            left: 26,
            right: 26,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 36,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                ShaderMask(
                  shaderCallback: (b) =>
                      AppTheme.primaryGradient.createShader(b),
                  child: Text(
                    'Register Vehicle',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill in the details of your vehicle below.',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 26),

                // Type selector
                _SheetLabel('Vehicle Type'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _TypeToggle(
                      label: '🚗  Car',
                      selected: _type == VehicleType.car,
                      onTap: () => setState(() => _type = VehicleType.car),
                    ),
                    const SizedBox(width: 12),
                    _TypeToggle(
                      label: '🏍️  Motorcycle',
                      selected: _type == VehicleType.motorcycle,
                      onTap: () =>
                          setState(() => _type = VehicleType.motorcycle),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _SheetLabel('License Plate'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _plateCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary, fontSize: 14),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
                  decoration: InputDecoration(
                    hintText: 'e.g. 51G-123.45',
                    hintStyle:
                    GoogleFonts.poppins(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppTheme.borderGlass, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppTheme.borderGlass, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppTheme.accentBlue.withOpacity(0.6),
                          width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.credit_card_outlined,
                        color: AppTheme.textMuted, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                _SheetLabel('Color'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _colorCtrl,
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary, fontSize: 14),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
                  decoration: InputDecoration(
                    hintText: 'e.g. Midnight Silver',
                    hintStyle:
                    GoogleFonts.poppins(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppTheme.borderGlass, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppTheme.borderGlass, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppTheme.accentBlue.withOpacity(0.6),
                          width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.palette_outlined,
                        color: AppTheme.textMuted, size: 20),
                  ),
                ),
                const SizedBox(height: 30),

                GradientButton(label: 'Save Vehicle', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.poppins(
      color: AppTheme.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeToggle(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected ? AppTheme.primaryGradient : null,
            color: selected ? null : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : AppTheme.borderGlass,
              width: 1,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: AppTheme.accentBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: selected
                    ? Colors.white
                    : AppTheme.textSecondary,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
