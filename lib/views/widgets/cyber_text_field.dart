// ============================================================
// --- lib/views/widgets/cyber_text_field.dart ---
// ============================================================
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:its/views/app_theme.dart';

class CyberTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const CyberTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CyberTextField> createState() => _CyberTextFieldState();
}

class _CyberTextFieldState extends State<CyberTextField> {
  bool _obscure = false;
  bool _focused = false;
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _node = FocusNode()
      ..addListener(() => setState(() => _focused = _node.hasFocus));
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_focused ? 0.07 : 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _focused
                  ? AppTheme.accentBlue.withOpacity(0.7)
                  : AppTheme.borderGlass,
              width: _focused ? 1.5 : 1,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: AppTheme.accentBlue.withOpacity(0.12),
                      blurRadius: 16,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _node,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.poppins(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
              prefixIcon:
                  Icon(widget.prefixIcon, color: AppTheme.textMuted, size: 20),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
              filled: false,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 16, horizontal: 4),
            ),
          ),
        ),
      ),
    );
  }
}