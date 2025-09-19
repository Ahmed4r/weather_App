import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Get API key from environment variables
  static String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  // Get base URL from environment (fallback to hardcoded)
  static String get weatherBaseUrl => dotenv.env['WEATHER_BASE_URL'] ?? baseUrl;
}
