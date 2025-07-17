import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color? fillColor;
  final Color? focusBorderColor;
  final Color? labelColor;
  final Color? iconColor;
  final Color? focusedIconColor;
  final TextStyle? prefixStyle;
  final void Function(String)? onChanged;
  final bool readOnly;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool autofocus;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.contentPadding,
    this.borderRadius = 12,
    this.fillColor,
    this.focusBorderColor,
    this.labelColor,
    this.iconColor,
    this.focusedIconColor,
    this.prefixStyle,
    this.onChanged,
    this.readOnly = false,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.autofocus = false,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _isFocused
        ? (widget.focusedIconColor ?? primaryColor)
        : (widget.iconColor ?? Colors.grey.shade600);

    return Focus(
      focusNode: _focusNode,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onChanged: widget.onChanged,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          prefixText: widget.prefixText,
          prefixStyle: widget.prefixStyle,
          labelStyle: widget.labelStyle ?? TextStyle(
            color:  primaryColor
          ),
          hintStyle: widget.hintStyle ?? TextStyle(
            color: Colors.grey.shade500,
          ),
          prefixIcon: 
              Icon(
                  widget.prefixIcon,
                  color: iconColor,
                )
              ,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color:  Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: primaryColor
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.focusBorderColor ?? Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          filled: true,
          fillColor: widget.fillColor ?? Colors.grey.shade50,
        ),
      ),
    );
  }
}