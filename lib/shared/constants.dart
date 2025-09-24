import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String forecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  // Get API key from environment variables
  static String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';
}
