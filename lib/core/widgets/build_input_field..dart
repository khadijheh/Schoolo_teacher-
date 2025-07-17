import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class BuildInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
   final InputDecoration? decoration;

  const BuildInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    required this.validator,  this. decoration,
  });

  @override
  State<BuildInputField> createState() => _BuildInputFieldState();
}

class _BuildInputFieldState extends State<BuildInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textDirection: TextDirection.ltr,
      obscureText: widget.obscureText,
      
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(widget.icon, color: Colors.white70),
        prefixText: widget.label == "Phone Number" ? " " : null,
        
        filled: true,
        // ignore: deprecated_member_use
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight! / 50,
          horizontal: 20,
        ),
        suffixIcon: widget.suffixIcon,
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.screenWidth! / 25,
      ),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      
    );
  }
}