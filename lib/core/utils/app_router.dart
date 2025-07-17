// app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/complete_profile_view.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/forget_password.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/sign_in_view.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/sign_up_view.dart';
import 'package:schoolo_teacher/features/auth/presentation/widgets/new_password_body.dart';
import 'package:schoolo_teacher/features/profile/presentation/page/profile_page.dart';
import 'package:schoolo_teacher/features/start_app/presentation/pages/home_page_view.dart';
import 'package:schoolo_teacher/features/splashe/presentation/pages/on_boarding.dart';
import 'package:schoolo_teacher/features/splashe/presentation/pages/splash_view.dart';
import 'package:schoolo_teacher/injection_containe.dart' as di;

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'splash':
        return MaterialPageRoute(builder: (_) => SplashView());
      case 'onboarding':
        return MaterialPageRoute(builder: (_) => OnBoarding());

      case 'signIn':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.getIt<AuthBloc>(),
            child: const SignInView(),
          ),
        );
      case 'signUp':
        return MaterialPageRoute(builder: (_) => SignUpView());

      case 'newPassword':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => NewPasswordBody(
            phone: args['phone'] ?? '',
            isForgotPassword: true,
          ),
        );
      case 'newPasswordSignUp':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => NewPasswordBody(
            phone: args['phone'] ?? '',
            isForgotPassword: false,
          ),
        );
      case 'profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case 'forgetPassword':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<AuthBloc>(navigatorKey.currentContext!),
            child: const ForgetPassword(),
          ),
        );
      // case 'newPassword':
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   return MaterialPageRoute(
      //     builder: (_) => NewPasswordBody(
      //       phone: args?['phone'] ?? '',
      //       isForgotPassword: args?['isForgotPassword'] ?? true,
      //     ),
      //   );
      case 'completeProfile':
        final phone = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CompleteProfileView(phoneNumber: phone ?? ''),
        );
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePageView());
     
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Page is not Found '))),
        );
    }
  }
}
