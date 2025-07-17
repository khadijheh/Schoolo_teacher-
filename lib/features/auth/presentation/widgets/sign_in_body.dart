import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/build_input_field..dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    context.read<AuthBloc>().add(
      LoginEvent(
        phoneNumber: _phoneController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _navigateToResetPassword() {
    Navigator.pushNamed(context, "forgetPassword");
  }

  void _navigateToSignUp() {
    Navigator.pushReplacementNamed(context, "signUp");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth! * 0.8,
                  child: Image.asset("images/splash.png", fit: BoxFit.contain),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! / 10,
                  //  vertical: SizeConfig.screenHeight! / 70,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VerticalSpace(SizeConfig.screenHeight! / 19.5),
                      Text(
                        "Sign in as Teacher in the application",
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth! / 19,
                          color: blockColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: SizeConfig.screenHeight! / 40),
                      BuildInputField(
                        controller: _phoneController,
                        label: "Phone Number",
                        icon: Icons.phone_android,
                        //   keyboardType: TextInputType.,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Your phone number";
                          }
                          if (value.length != 9) {
                            return "It must consist of 9 numbers";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: SizeConfig.screenHeight! / 45),

                      BuildInputField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.yellowAccent,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password have to be 8 letter or plus ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SizeConfig.screenHeight! / 55),

                      // forget password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _navigateToResetPassword,
                            child: Text(
                              'Forget Password',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.screenWidth! / 28,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.screenHeight! / 50),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth! / 5,
                        ),
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenHeight! / 70,
                              horizontal: SizeConfig.screenWidth! / 30,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            // ignore: deprecated_member_use
                            shadowColor: Colors.black.withOpacity(0.5),
                          ),
                          child: state is AuthLoading
                              ? CircularProgressIndicator(
                                  color: secondaryColor,
                                  strokeWidth: 3,
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: SizeConfig.screenWidth! / 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.screenHeight! / 80),

                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "You dont have an account?",
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth! / 40,
                                color: blockColor,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToSignUp,
                              child: Text(
                                "Sign Up now",
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! / 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      // ignore: deprecated_member_use
                                      color: primaryColor.withOpacity(0.7),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
