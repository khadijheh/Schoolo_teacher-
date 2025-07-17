import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/strings.dart';

class ActionButton extends StatelessWidget {
  final bool isCodeSent;
  final VoidCallback onPressed;
  final bool isLoading;
  final StreamController<ErrorAnimationType>? errorController;
  final Animation<double>? scaleAnimation;
  
  const ActionButton({
    super.key,
    required this.isCodeSent,
    required this.onPressed,
    required this.isLoading,
    this.errorController,
    this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(
          vertical: screenHeight / 50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        // ignore: deprecated_member_use
        shadowColor: primaryColor.withOpacity(0.3),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              isCodeSent
                  ? Strings.appStrings['verify'] ?? 'Verify' // قيمة افتراضية
                  : Strings.appStrings['sendCode'] ?? 'Send Code',
              style: TextStyle(
                fontSize: screenWidth / 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );

    if (scaleAnimation != null) {
      return ScaleTransition(
        scale: scaleAnimation!,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth / 7),
          child: button,
        ),
      );
    }

    // العودة للزر العادي إذا لم يكن هناك تأثير scale
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth / 7),
      child: button,
    );
  }
}