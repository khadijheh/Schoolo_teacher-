import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/core/utils/themes.dart';
import 'package:schoolo_teacher/core/utils/app_router.dart';
import 'package:schoolo_teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schoolo_teacher/features/start_app/presentation/widgets/home_page_body.dart';
import 'package:schoolo_teacher/injection_containe.dart' as di;
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await EasyLocalization.ensureInitialized();
    // print('EasyLocalization initialized successfully');
  } catch (e) {
    //print('Error initializing EasyLocalization: $e');
  }

  await di.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final appState = AppState();
  await appState.loadFromPrefs();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: ChangeNotifierProvider.value(
        value: appState,
        child: MultiBlocProvider(
          providers: [BlocProvider(create: (_) => di.getIt<AuthBloc>())],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  void initState() {
    super.initState();
    _lockOrientation();
  }

  Future<void> _lockOrientation() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      initialRoute: "splash",
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => HomePageBody(
              onToggleTheme: _toggleTheme,
              themeMode: _themeMode,
            ),
          );
        }
        return AppRouter.generateRoute(settings);
      },
      debugShowCheckedModeBanner: false,
      locale: EasyLocalization.of(context)?.locale,
      supportedLocales:
          EasyLocalization.of(context)?.supportedLocales ??
          const [Locale('en')],
      localizationsDelegates: EasyLocalization.of(context)?.delegates,
    );
  }
}
