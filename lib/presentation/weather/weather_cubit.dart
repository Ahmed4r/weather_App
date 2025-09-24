import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/shared/api_service.dart';
import 'package:weather_app/shared/geo_locator_service.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  Weather model = Weather();
  double long = 0.0;
  double lat = 0.0;
  ApiService apiService = ApiService();
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
      Weather weather = await apiService.searchCityWeather(city);
      final formattedTime = formatLocalTime(
        weather.dt ?? 0,
        weather.timezone ?? 0,
      );
      emit(WeatherSuccess(weather, formattedTime));
    } catch (e) {
      emit(WeatherError(getExceptionMessage(e)));
    }
  }

  // Get weather by current location
  Future<void> getWeather() async {
    emit(WeatherLoading());
    try {
      Weather weather = await apiService.getCurrentLocationWeather(lat, long);
      final formattedTime = formatLocalTime(
        weather.dt ?? 0,
        weather.timezone ?? 0,
      );
      emit(WeatherSuccess(weather, formattedTime));
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
