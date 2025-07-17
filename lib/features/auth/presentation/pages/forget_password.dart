import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/widgets/forget_password_body.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: BlocProvider.of<AuthBloc>(context),
        child: const ForgotPasswordBody(),
      ),
    );
  }
}
