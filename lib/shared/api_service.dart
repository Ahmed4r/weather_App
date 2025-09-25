import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart' as weather_model;
import 'package:weather_app/model/forecast_model.dart' as forecast_model;
import 'package:weather_app/shared/constants.dart';

class ApiService {
  Future<weather_model.Weather> searchCityWeather(String city) async {
    try {
      final url = Uri.parse(
        '${Constants.baseUrl}?q=$city&appid=${Constants.apiKey}&units=metric',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weather_model.Weather model = weather_model.Weather.fromJson(data);
        log('Success : ${response.body}');
        return model;
      } else {
        throw Exception(
          'Failed to load weather data: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  //  get current location weather
  Future<weather_model.Weather> getCurrentLocationWeather(
    double lat,
    double long,
  ) async {
    try {
      final url = Uri.parse(
        '${Constants.baseUrl}?lat=$lat&lon=$long&appid=${Constants.apiKey}&units=metric',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weather_model.Weather model = weather_model.Weather.fromJson(data);
        log('Success : ${response.body}');
        return model;
      } else {
        throw Exception(
          'Failed to load weather data: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  // get 5 days forecast
  Future<forecast_model.ForecastModel> get5DayForecast(
    double lat,
    double long,
  ) async {
    try {
      // Use forecast API endpoint instead of current weather endpoint
      final url = Uri.parse(
        '${Constants.forecastUrl}?lat=$lat&lon=$long&appid=${Constants.apiKey}&units=metric',
      );

      log('Forecast API URL: $url');

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      log('Forecast API Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        forecast_model.ForecastModel forecast =
            forecast_model.ForecastModel.fromJson(data);
        String cityName = '';

        // Log city info for debugging
        if (data['city'] != null) {
          cityName = data['city']['name'] ?? '';
          log('City info: $cityName');
        }

        return forecast;
      } else {
        throw Exception(
          'Failed to load weather data: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  // get forecast by city name
  Future<forecast_model.ForecastModel> searchCityForecast5Days(
    String city,
  ) async {
    try {
      final url = Uri.parse(
        '${Constants.forecastUrl}?q=$city&appid=${Constants.apiKey}&units=metric',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      log('Forecast API Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        forecast_model.ForecastModel forecast =
            forecast_model.ForecastModel.fromJson(data);
        String cityName = '';

        // Log city info for debugging
        if (data['city'] != null) {
          cityName = data['city']['name'] ?? '';
          log('City info: $cityName');
        }

        return forecast;
      } else {
        throw Exception(
          'Failed to load weather data: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }
}
