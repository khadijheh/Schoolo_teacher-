import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/widgets/sign_up_body.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          _handleAuthState(context, state);
        },
        child: const SignUpBody(),
      ),
    );
  }

 void _handleAuthState(BuildContext context, AuthState state) {
  if (state is AuthError) {
    if (state.message.contains('تم تأكيد رقم الهاتف')) {
      // الحصول على رقم الهاتف من الـ controller بدلاً من state
      final phone = context.read<AuthBloc>().phoneNumber; // أو من مصدر آخر
      _navigateToNewPassword(context, phone!);
    } else {
      _showErrorMessage(context, state.message);
    }
  } else if (state is OtpVerifiedState) {
    _navigateToNewPassword(context, state.phoneNumber);
  } else if (state is PhoneAlreadyVerified) {
    _navigateToNewPassword(context, state.phoneNumber);
  }
}

  void _navigateToNewPassword(BuildContext context, String phoneNumber) {
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(
        context,
        "newPasswordSignUp",
        arguments: {'phone_number': phoneNumber},
      );
    });
  }

  void _showErrorMessage(BuildContext context, String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: message.contains('تم تأكيد رقم الهاتف')
              ? SnackBarAction(
                  label: 'تسجيل الدخول',
                  onPressed: () => Navigator.pushReplacementNamed(context, "signIn"),
                )
              : null,
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
  }
}