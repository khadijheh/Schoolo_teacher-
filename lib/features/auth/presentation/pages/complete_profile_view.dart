import 'package:flutter/material.dart';
import 'package:schoolo_teacher/features/auth/presentation/widgets/complete_profile_body.dart';

class CompleteProfileView extends StatelessWidget {
  final String phoneNumber;

  const CompleteProfileView({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CompleteProfileBody(phoneNumber: phoneNumber));
    
  }
}
