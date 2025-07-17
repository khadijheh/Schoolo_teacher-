// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:schoolo_teacher/core/utils/constants.dart';
// import 'package:schoolo_teacher/core/utils/size_config.dart';
// import 'package:schoolo_teacher/core/widgets/build_logo.dart';
// import 'package:schoolo_teacher/core/widgets/space_widget.dart';
// import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';

// class ResetPassword extends StatefulWidget {
//   final String phone;

//   const ResetPassword({super.key, required this.phone});

//   @override
//   State<ResetPassword> createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _codeController;
//   late final TextEditingController _newPasswordController;
//   late final TextEditingController _confirmPasswordController;

//   int _remainingSeconds = 60;
//   late Timer _timer;
//   bool _isLoading = false;
//   bool _isCodeVerified = false;

//   late StreamController<ErrorAnimationType> errorController;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     _confirmPasswordController = TextEditingController();
//     _newPasswordController = TextEditingController();
//     _codeController = TextEditingController();
//     errorController = StreamController<ErrorAnimationType>();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         setState(() => _remainingSeconds--);
//       } else {
//         _timer.cancel();
//       }
//     });
//   }

//   void _verifyCode() {
//     if (_codeController.text.length == 6) {
//       if (mounted) setState(() => _isLoading = true);
//       context.read<AuthBloc>().add(
//         VerifyOtpEvent(
//           phoneNumber: widget.phone,
//           otp: _codeController.text,
//           purpose: 'password_reset',
//         ),
//       );
//     }
//   }

//   void _resetPassword() {
//     if (_formKey.currentState!.validate()) {
//       if (_newPasswordController.text != _confirmPasswordController.text) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
//         return;
//       }

//       setState(() => _isLoading = true);
//       context.read<AuthBloc>().add(
//         ResetPasswordEvent(
//           phoneNumber: widget.phone,
//           newPassword: _newPasswordController.text,
//           confirmPassword: _confirmPasswordController.text,
//         ),
//       );
//     }
//   }

//   void _resendCode() {
//     setState(() {
//       _remainingSeconds = 60;
//       _startTimer();
//     });
//     context.read<AuthBloc>().add(SendOtpEvent(widget.phone));
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _codeController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     errorController.close();
//     _timer.cancel();
//     super.dispose();
//   }

//   Widget _buildActionButton(String text, VoidCallback onPressed) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! / 7),
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           padding: EdgeInsets.symmetric(
//             vertical: SizeConfig.screenHeight! / 50,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           elevation: 5,
//         ),
//         child: _isLoading
//             ? const CircularProgressIndicator(color: Colors.white)
//             : Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: SizeConfig.screenWidth! / 22,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildPasswordFields() {
//     return Column(
//       children: [
//         const VerticalSpace(2),
//         TextFormField(
//           controller: _newPasswordController,
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'New Password',
//             prefixIcon: Icon(Icons.lock, color: primaryColor),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter new password';
//             }
//             if (value.length < 8) {
//               // تغيير من 6 إلى 8 أحرف
//               return 'Password must be at least 8 characters';
//             }
//             if (!value.contains(RegExp(r'[A-Z]'))) {
//               return 'Password must contain at least one uppercase letter';
//             }
//             if (!value.contains(RegExp(r'[0-9]'))) {
//               return 'Password must contain at least one number';
//             }
//             return null;
//           },
//         ),
//         const VerticalSpace(2),
//         TextFormField(
//           controller: _confirmPasswordController,
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'Confirm Password',
//             prefixIcon: Icon(Icons.lock, color: primaryColor),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           validator: (value) {
//             if (value != _newPasswordController.text) {
//               return 'Passwords do not match';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthError) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//           setState(() => _isLoading = false);
//         }
//         if (state is OtpVerifiedState) {
//           setState(() {
//             _isLoading = false;
//             _isCodeVerified = true;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   HorizontalSpace(1),
//                   Text('Code verified successfully!'),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//         if (state is AuthSuccess) {
//           await Future.delayed(Duration.zero);
//           Navigator.pushNamedAndRemoveUntil(
//             // ignore: use_build_context_synchronously
//             context,
//             'signIn',
//             (route) => false,
//           );
//           // ignore: use_build_context_synchronously
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   HorizontalSpace(1),
//                   Text('Password reset successfully!'),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: primaryColor),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               title: Text(
//                 "Reset Password",
//                 style: TextStyle(
//                   fontSize: SizeConfig.screenWidth! / 18,
//                   color: primaryColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               centerTitle: true,
//             ),
//             body: Stack(
//               children: [
//                 SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.screenWidth! / 20,
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         BuildLogo(),
//                         Text(
//                           _isCodeVerified
//                               ? "Create New Password"
//                               : "Verify Your Code",
//                           style: TextStyle(
//                             fontSize: SizeConfig.screenWidth! / 15,
//                             color: primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const VerticalSpace(1),
//                         Text(
//                           "Verification code sent to ${widget.phone}",
//                           style: TextStyle(
//                             fontSize: SizeConfig.screenWidth! / 28,
//                             color: blockColor,
//                             fontWeight: FontWeight.w300,
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const VerticalSpace(2),
//                         if (!_isCodeVerified) ...[
//                           PinCodeTextField(
//                             appContext: context,
//                             length: 6,
//                             controller: _codeController,
//                             autoFocus: true,
//                             animationType: AnimationType.fade,
//                             pinTheme: PinTheme(
//                               shape: PinCodeFieldShape.box,
//                               borderRadius: BorderRadius.circular(5),
//                               fieldHeight: 50,
//                               fieldWidth: 40,
//                               activeFillColor: Colors.white,
//                               selectedFillColor: Colors.white,
//                               inactiveFillColor: Colors.white,
//                               activeColor: primaryColor,
//                               selectedColor: primaryColor,
//                               inactiveColor: Colors.grey.shade300,
//                             ),
//                             animationDuration: const Duration(
//                               milliseconds: 300,
//                             ),
//                             enableActiveFill: true,
//                             errorAnimationController: errorController,
//                             onCompleted: (v) => _verifyCode(),
//                             onChanged: (value) {},
//                           ),
//                           const VerticalSpace(1),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 '0:${_remainingSeconds.toString().padLeft(2, '0')}',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.screenWidth! / 25,
//                                   fontWeight: FontWeight.bold,
//                                   color: _remainingSeconds < 10
//                                       ? Colors.red
//                                       : primaryColor,
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               TextButton(
//                                 onPressed: _remainingSeconds == 0 && !_isLoading
//                                     ? _resendCode
//                                     : null,
//                                 child: Text(
//                                   "Resend Code",
//                                   style: TextStyle(
//                                     fontSize: SizeConfig.screenWidth! / 28,
//                                     color: _remainingSeconds == 0
//                                         ? primaryColor
//                                         : Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const VerticalSpace(2),
//                           _buildActionButton("Verify Code", _verifyCode),
//                         ] else ...[
//                           _buildPasswordFields(),
//                           const VerticalSpace(3),
//                           _buildActionButton("Reset Password", _resetPassword),
//                         ],
//                         const VerticalSpace(2),
//                         TextButton(
//                           onPressed: _isLoading
//                               ? null
//                               : () => Navigator.popAndPushNamed(
//                                   context,
//                                   "signIn",
//                                 ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.arrow_back),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "Back to login",
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.screenWidth! / 26,
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/build_logo.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';


class SafeTextEditingController extends TextEditingController {
  bool _isDisposed = false;

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    super.dispose();
  }

  @override
  set value(TextEditingValue newValue) {
    if (_isDisposed) return;
    super.value = newValue;
  }

  @override
  set text(String newText) {
    if (_isDisposed) return;
    super.text = newText;
  }
}
class ResetPassword extends StatefulWidget {
  final String phone;

  const ResetPassword({super.key, required this.phone});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late final SafeTextEditingController _codeController;
  late final SafeTextEditingController _newPasswordController;
  late final SafeTextEditingController _confirmPasswordController;

  int _remainingSeconds = 60;
  late Timer _timer;
  bool _isLoading = false;
  bool _isCodeVerified = false;
  late StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    super.initState();
    _codeController = SafeTextEditingController();
    _newPasswordController = SafeTextEditingController();
    _confirmPasswordController = SafeTextEditingController();
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _verifyCode() {
    if (!mounted || _codeController.text.length != 6) return;

    FocusScope.of(context).unfocus();

    if (mounted) {
      setState(() => _isLoading = true);
    }

    context.read<AuthBloc>().add(
      VerifyOtpEvent(
        phoneNumber: widget.phone,
        otp: _codeController.text,
        purpose: 'password_reset',
      ),
    );
  }

  void _resetPassword() {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      FocusScope.of(context).unfocus();

      if (mounted) {
        setState(() => _isLoading = true);
      }

      context.read<AuthBloc>().add(
        ResetPasswordEvent(
          phoneNumber: widget.phone,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  void _resendCode() {
    if (!mounted) return;

    setState(() {
      _remainingSeconds = 60;
      _startTimer();
    });

    context.read<AuthBloc>().add(SendOtpEvent(widget.phone));
  }

  @override
  void dispose() {
    _timer.cancel();
    FocusManager.instance.primaryFocus?.unfocus();
    errorController.close();

    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _codeController.dispose();
    //   _newPasswordController.dispose();
    //   _confirmPasswordController.dispose();
    //   errorController.close();
    // });

    super.dispose();
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! / 7),
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
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
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        const VerticalSpace(2),
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'New Password',
            prefixIcon: Icon(Icons.lock, color: primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter new password';
            //   }
            //   if (value.length < 8) {
            //     return 'Password must be at least 8 characters';
            //   }
            //   if (!value.contains(RegExp(r'[A-Z]'))) {
            //     return 'Password must contain at least one uppercase letter';
            //   }
            //   if (!value.contains(RegExp(r'[0-9]'))) {
            //     return 'Password must contain at least one number';
            //   }
            //   return null;
            // },
          ),
        ),
        const VerticalSpace(2),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock, color: primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (value) {
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is! AuthError,
      listener: (context, state) async {
        if (!mounted) return;

        if (state is AuthError) {
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() => _isLoading = false);
          }
        }

        if (state is OtpVerifiedState && mounted) {
          setState(() {
            _isLoading = false;
            _isCodeVerified = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const HorizontalSpace(1),
                  const Text('Code verified successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const HorizontalSpace(1),
                  const Text('Password reset successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            Navigator.of(
              // ignore: use_build_context_synchronously
              context,
            ).pushNamedAndRemoveUntil('signIn', (route) => false);
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                "Reset Password",
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
                        const BuildLogo(),
                        Text(
                          _isCodeVerified
                              ? "Create New Password"
                              : "Verify Your Code",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth! / 15,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const VerticalSpace(1),
                        Text(
                          "Verification code sent to ${widget.phone}",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth! / 28,
                            color: blockColor,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const VerticalSpace(2),
                        if (!_isCodeVerified) ...[
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: _codeController,
                            autoFocus: true,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              activeColor: primaryColor,
                              selectedColor: primaryColor,
                              inactiveColor: Colors.grey.shade300,
                            ),
                            animationDuration: const Duration(
                              milliseconds: 300,
                            ),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            onCompleted: (v) => _verifyCode(),
                            onChanged: (value) {},
                          ),
                          const VerticalSpace(1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '0:${_remainingSeconds.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! / 25,
                                  fontWeight: FontWeight.bold,
                                  color: _remainingSeconds < 10
                                      ? Colors.red
                                      : primaryColor,
                                ),
                              ),
                              const SizedBox(width: 20),
                              TextButton(
                                onPressed: _remainingSeconds == 0 && !_isLoading
                                    ? _resendCode
                                    : null,
                                child: Text(
                                  "Resend Code",
                                  style: TextStyle(
                                    fontSize: SizeConfig.screenWidth! / 28,
                                    color: _remainingSeconds == 0
                                        ? primaryColor
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpace(2),
                          _buildActionButton("Verify Code", _verifyCode),
                        ] else ...[
                          _buildPasswordFields(),
                          const VerticalSpace(3),
                          _buildActionButton("Reset Password", _resetPassword),
                        ],
                        const VerticalSpace(2),
                        TextButton(
                          onPressed: _isLoading
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
