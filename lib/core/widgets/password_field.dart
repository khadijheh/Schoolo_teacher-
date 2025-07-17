import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
     this.onToggleVisibility,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {


    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon ?? Icons.lock_outline, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: blockColor,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: validator,
    );
  }
}
