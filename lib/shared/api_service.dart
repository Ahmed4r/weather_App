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

  // get 4 day forecast
  Future<List<weather_model.Weather>> get4DayForecast(
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
        List<weather_model.Weather> forecast = [];
        String cityName = '';

        // Log city info for debugging
        if (data['city'] != null) {
          cityName = data['city']['name'] ?? '';
          log('City info: $cityName');
        }

        // Check if 'list' exists in the response
        if (data['list'] != null) {
          log('Found ${data['list'].length} forecast items');
          for (var item in data['list']) {
            // Create Weather object from forecast list item
            final forecastItem = forecast_model.ForecastList.fromJson(item);

            // Convert forecast item to Weather model for compatibility
            forecast.add(
              weather_model.Weather(
                coord: null, // Not available in forecast items
                weather: forecastItem.weather
                    ?.map(
                      (w) => weather_model.WeatherModel(
                        id: w.id?.toInt(),
                        main: w.main,
                        description: w.description,
                        icon: w.icon,
                      ),
                    )
                    .toList(),
                main: forecastItem.main != null
                    ? weather_model.Main(
                        temp: forecastItem.main!.temp?.toDouble(),
                        feelsLike: forecastItem.main!.feelsLike?.toDouble(),
                        tempMin: forecastItem.main!.tempMin?.toDouble(),
                        tempMax: forecastItem.main!.tempMax?.toDouble(),
                        pressure: forecastItem.main!.pressure?.toInt(),
                        humidity: forecastItem.main!.humidity?.toInt(),
                      )
                    : null,
                wind: forecastItem.wind != null
                    ? weather_model.Wind(
                        speed: forecastItem.wind!.speed?.toDouble(),
                        deg: forecastItem.wind!.deg?.toInt(),
                      )
                    : null,
                clouds: forecastItem.clouds != null
                    ? weather_model.Clouds(
                        all: forecastItem.clouds!.all?.toInt(),
                      )
                    : null,
                sys: null, // Not available in forecast items
                base: null,
                visibility: forecastItem.visibility?.toInt(),
                dt: forecastItem.dt?.toInt(),
                timezone: null,
                id: null,
                name: cityName, // Add city name here
                cod: null,
              ),
            );
          }
        } else {
          log('No forecast list found in response');
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
