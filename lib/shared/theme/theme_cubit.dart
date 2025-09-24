// theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system); // Initial theme is system default
  bool get isDarkMode => state == ThemeMode.dark;
  void toggleTheme(ThemeMode themeMode) {
    emit(themeMode);
    saveTheme();
  } // Update theme

  saveTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isDarkMode', isDarkMode);
  }

  loadTheme() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final isDark = pref.getBool('isDarkMode') ?? false;
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      // Handle error - maybe emit default theme
      emit(ThemeMode.system);
    }
  }
}
