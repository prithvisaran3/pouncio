import 'package:flutter/cupertino.dart';
import '../../core/utils.dart';
import '../../theme/colors.dart';

/// A modern, glassmorphic text field designed for Pouncio.
/// Displays an active highlighted state on focus with subtle transitions.
class ModernTextField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isFocused
            ? AppColors.accent.withValues(alpha: isDark ? 0.08 : 0.04)
            : AppColors.surface(context).withValues(alpha: isDark ? 0.45 : 0.65),
        borderRadius: BorderRadius.circular(Responsive.scale(context, 16.0)),
        border: Border.all(
          color: _isFocused
              ? AppColors.accent
              : AppColors.border(context).withValues(alpha: isDark ? 0.6 : 0.8),
          width: _isFocused ? 1.5 : 1.0,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: CupertinoTextField(
        controller: widget.controller,
        focusNode: _focusNode,
        placeholder: widget.placeholder,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        clearButtonMode: OverlayVisibilityMode.editing,
        prefix: Padding(
          padding: EdgeInsets.only(left: Responsive.scale(context, 14.0)),
          child: Icon(
            widget.icon,
            size: Responsive.scale(context, 18.0),
            color: _isFocused ? AppColors.accent : AppColors.textSecondary(context),
          ),
        ),
        decoration: const BoxDecoration(color: Color(0x00000000)),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.scale(context, 12.0),
          vertical: Responsive.scale(context, 14.0),
        ),
        placeholderStyle: TextStyle(
          color: AppColors.textSecondary(context).withValues(alpha: 0.55),
          fontSize: Responsive.scaleText(context, 15.0),
        ),
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontSize: Responsive.scaleText(context, 15.0),
        ),
      ),
    );
  }
}
