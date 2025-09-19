import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/core/constants.dart';
import 'package:weather_app/core/geo_locator_service.dart';
import 'package:weather_app/features/data/model/weather_model.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  Weather model = Weather();
  double long = 0.0;
  double lat = 0.0;
  // Get current location
  void getLongLat() async {
    emit(WeatherLoading());
    try {
      Position position = await GeoLocatorService.determinePosition();
      long = position.longitude;
      lat = position.latitude;
      await getWeather();
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
  // Get weather by city name
  Future<void> searchCityWeather(String city) async {
    emit(WeatherLoading());
    try {
      final url = Uri.parse(
        '${Constants.baseUrl}?q=$city&appid=${Constants.apiKey}&units=metric',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        model = Weather.fromJson(data);
        log('Success : ${response.body}');
        final formattedTime = formatLocalTime(
          model.dt ?? 0,
          model.timezone ?? 0,
        );
        emit(WeatherSuccess(model, formattedTime));
      } else {
        emit(WeatherError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(WeatherError(getExceptionMessage(e)));
    }
  }
  // Get weather by current location
  Future<void> getWeather() async {
    emit(WeatherLoading());
    try {
      // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
      final url = Uri.parse(
        '${Constants.baseUrl}?lat=$lat&lon=$long&appid=${Constants.apiKey}&units=metric',
      );
      await _fetchWeatherData(url);
    } catch (e) {
      log(e.toString());
      emit(WeatherError(getExceptionMessage(e)));
    }
  }
  // Convert timestamp to local time
  String formatLocalTime(int timestamp, int offset) {
    final utc = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    final local = utc.add(Duration(seconds: offset));
    return DateFormat('hh:mm a').format(local);
  }
  // fetch weather data from API
  Future<void> _fetchWeatherData(Uri url) async {
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      model = Weather.fromJson(data);

      log('Weather data fetched successfully');

      final formattedTime = formatLocalTime(model.dt ?? 0, model.timezone ?? 0);
      emit(WeatherSuccess(model, formattedTime));
    } else {
      throw HttpException('Server error: ${response.statusCode}');
    }
  }
  // Handle different types of exceptions
  String getExceptionMessage(dynamic e) {
    if (e is SocketException) {
      return 'No Internet Connection';
    } else if (e is HttpException) {
      return 'Couldn\'t find the post';
    } else if (e is FormatException) {
      return 'Bad response format';
    } else if (e is TimeoutException) {
      return 'Request timed out, please try again';
    } else {
      return 'Unexpected error occurred';
    }
  }
  // Get weather image based on weather status
  String getWeatherImage(String? weatherStatus) {
    if (weatherStatus == null) return 'assets/sunny.json';

    switch (weatherStatus) {
      case 'Clear':
        return 'assets/sunny.json';
      case 'Rain':
        return 'assets/rainy.json';
      case 'Clouds':
        return 'assets/cloud.json';
      case 'Snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }
}
