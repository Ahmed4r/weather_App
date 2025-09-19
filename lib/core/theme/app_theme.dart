import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    iconTheme: IconThemeData(color: Colors.grey, size: 20),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
      ),
    ),
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.black54),
      toolbarHeight: 100,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
    ),
  );
  ThemeData darkTheme = ThemeData(
    iconTheme: IconThemeData(color: Colors.grey, size: 20),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
      ),
    ),
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    ),
  );
}
