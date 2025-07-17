import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/strings.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/action_button.dart';
import 'package:schoolo_teacher/core/widgets/custom_text_field.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;
  late final FocusNode _codeFocusNode;
  bool _codeSent = false;
  bool _isSending = false;
  int _remainingSeconds = 60;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  String currentText = "";
  late StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
    _codeFocusNode = FocusNode();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0 && _codeSent) {
        setState(() => _remainingSeconds--);
      }
    });

    _animationController.forward();
    errorController = StreamController<ErrorAnimationType>();
  }

  void _startTimer() {
    setState(() => _remainingSeconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  void sendVerificationCode() {
    if (_isSending) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _codeSent = true;
        _isSending = true;
        _remainingSeconds = 60;
        _animationController.reset();
        _animationController.forward();
      });

      FocusScope.of(context).requestFocus(_codeFocusNode);

      context.read<AuthBloc>().add(SendOtpEvent(_phoneController.text));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "${Strings.appStrings['codeSent']} ${_phoneController.text}",
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () => _isSending = false);
    }
  }

  void verifyCodeAndSignUp() {
    if (!_codeSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء طلب كود التحقق أولاً")),
      );
      return;
    }

    if (currentText.length != 6) {
      errorController.add(ErrorAnimationType.shake);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يجب أن يتكون الكود من 6 أرقام")),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      VerifyOtpEvent(
        phoneNumber: _phoneController.text,
        otp: currentText,
        purpose: "phone_verification",
      ),
    );
  }

  void _resendCode() {
    if (_remainingSeconds > 0) return;

    _timer.cancel();
    _startTimer();
    context.read<AuthBloc>().add(SendOtpEvent(_phoneController.text));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    _timer.cancel();

    _animationController.dispose();
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth! / 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VerticalSpace(10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "images/logo.jpg",
                      height: SizeConfig.screenHeight! / 3,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const VerticalSpace(2),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _codeSent
                          ? Strings.appStrings['verificationTitle']!
                          : Strings.appStrings['signUpTitle']!,
                      key: ValueKey<bool>(_codeSent),
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! / 15,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const VerticalSpace(1.5),

                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: 1.0,
                    child: Text(
                      _codeSent
                          ? "${Strings.appStrings['verificationDesc']} ${_phoneController.text}"
                          : Strings.appStrings['signUpDesc']!,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! / 29,
                        color: blockColor,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const VerticalSpace(2),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          child: child,
                        ),
                      );
                    },
                    child: _codeSent
                        ? Column(
                            key: const ValueKey('codeInput'),
                            children: [
                              PinCodeTextField(
                                appContext: context,
                                length: 6,
                                controller: _codeController,
                                focusNode: _codeFocusNode,
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
                                onCompleted: (v) => verifyCodeAndSignUp(),
                                onChanged: (value) {
                                  setState(() => currentText = value);
                                },
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
                                    onPressed: _remainingSeconds == 0
                                        ? _resendCode
                                        : null,
                                    child: Text(
                                      Strings.appStrings['resendCode']!,
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
                            ],
                          )
                        : CustomTextField(
                            controller: _phoneController,
                            prefixIcon: Icons.phone_android,
                            label: 'Phone Number',
                            prefixText: ' ',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              }
                              if (value.length <= 9) {
                                return "Please enter a valid phone number (9 digits)";
                              }
                              return null;
                            },
                          ),
                  ),

                  const VerticalSpace(2),
                  ActionButton(
                    isCodeSent: _codeSent,
                    onPressed: () {
                      if (_codeSent) {
                        verifyCodeAndSignUp();
                      } else {
                        sendVerificationCode();
                      }
                    },
                    isLoading: _isSending,
                    errorController: errorController,
                    scaleAnimation: scaleAnimation,
                  ),
                  const VerticalSpace(3),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${Strings.appStrings['haveAccount']} ",
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth! / 30,
                          color: blockColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, "signIn"),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          Strings.appStrings['signIn']!,
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth! / 28,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
