import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/build_logo.dart';
import 'package:schoolo_teacher/core/widgets/custom_text_field.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/reset_password.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _sendVerificationCode() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SendOtpEvent(_phoneController.text));
    }
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth! / 7,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
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
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! / 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is OtpSentState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  HorizontalSpace(2),
                  Text("the code has been sent"),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(phone: state.phoneNumber),
            ),
          );
        }
      },

      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: whiteColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Reset New Password",
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! / 22,
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
                        BuildLogo(),
                        Text(
                          "Reset your password",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth! / 18,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const VerticalSpace(2),
                        Text(
                          "Enter your phone number to receive a verification code",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth! / 28,
                            color: blockColor,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const VerticalSpace(5),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your phone number";
                            }
                            if (value.length <= 9) {
                              return "Please enter a valid 9-digit number";
                            }
                            return null;
                          },
                          prefixIcon: Icons.mobile_friendly,
                        ),
                        const VerticalSpace(4),
                        _buildActionButton("Send Code", _sendVerificationCode),
                        const VerticalSpace(1),
                        TextButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () => Navigator.popAndPushNamed(
                                  context,
                                  "signIn",
                                ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_back),
                              const SizedBox(width: 8),
                              Text(
                                "Back to login",
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! / 26,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
      },
    );
  }
}
