import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/presentation/forcast/forcast_screen.dart';
import 'package:weather_app/presentation/forcast/forecast_cubit.dart';
import 'package:weather_app/shared/theme/app_theme.dart';
import 'package:weather_app/shared/theme/theme_cubit.dart';
import 'package:weather_app/presentation/weather/weather_cubit.dart';
import 'package:weather_app/presentation/weather/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        BlocProvider<ForecastCubit>(create: (context) => ForecastCubit()),
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
            routes: {
              WeatherScreen.routeName: (context) => WeatherScreen(),
              ForecastScreen.routeName: (context) => ForecastScreen(),
            },
          );
        },
      ),
    );
  }
}