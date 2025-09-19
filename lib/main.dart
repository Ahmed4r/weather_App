import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/presentation/settings/theme_cubit.dart';
import 'package:weather_app/features/presentation/weather/weather_cubit.dart';
import 'package:weather_app/features/presentation/weather/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    ErrorHandler.handleFlutterError(details);
  };
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  WeatherApp({super.key});

  final AppTheme appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) {
            final cubit = ThemeCubit();
            cubit.loadTheme();
            return cubit;
          },
        ),
        BlocProvider<WeatherCubit>(create: (context) => WeatherCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: appTheme.lightTheme,
            darkTheme: appTheme.darkTheme,
            themeMode: themeState,
            initialRoute: WeatherScreen.routeName,
            routes: {WeatherScreen.routeName: (context) => WeatherScreen()},
          );
        },
      ),
    );
  }
}

class ErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      log('Flutter Error: ${details.exception}');
      log('Stack trace: ${details.stack}');
    }
    // In production, send to crash analytics
  }
}
