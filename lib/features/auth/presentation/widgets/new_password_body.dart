import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/build_logo.dart';
import 'package:schoolo_teacher/core/widgets/password_field.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/sign_in_view.dart';

class NewPasswordBody extends StatefulWidget {
  final dynamic phone;
  final bool isForgotPassword;

  const NewPasswordBody({
    super.key,
    required this.phone,
    required this.isForgotPassword,
  });

  @override
  State<NewPasswordBody> createState() => _NewPasswordBodyState();
}

class _NewPasswordBodyState extends State<NewPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isLoading = false);

        if (widget.isForgotPassword == true) {
          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'completeProfile');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.isForgotPassword
        ? "Create New Password"
        : "Set Your Password";

    final buttonText = widget.isForgotPassword
        ? "Save Password"
        : "Create Account";

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SignInView()),
          (route) => false,
        );

        Navigator.pushReplacementNamed(context, "newPasswordSignUp");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.isForgotPassword ? "Reset Password" : "Create Account",
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 18,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! / 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VerticalSpace(3),
                    BuildLogo(),
                    const VerticalSpace(4),
                    Text(
                      titleText,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! / 15,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace(1),

                    const VerticalSpace(3),
                    PasswordField(
                      controller: _newPasswordController,
                      labelText: 'New Password',
                      obscureText: _obscureNewPassword,
                      onToggleVisibility: () => setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter new password";
                        }
                        if (value.length < 8) {
                          return "Password must be 8+ characters";
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(2),
                    PasswordField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm New Password',
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icons.lock_reset_outlined,
                      onToggleVisibility: () => setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }),
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(3),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! / 7,
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight! / 50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! / 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const VerticalSpace(2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
