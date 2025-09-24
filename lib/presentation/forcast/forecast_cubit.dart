import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/presentation/forcast/forcaset_state.dart';
import 'package:weather_app/shared/api_service.dart';
import 'package:weather_app/shared/geo_locator_service.dart';

class ForecastCubit extends Cubit<ForecastState> {
  ForecastCubit() : super(ForecastInitial());
  double long = 0.0;
  double lat = 0.0;
  String cityName = '';
  ApiService apiService = ApiService();
  // Get current location
  void getLongLat() async {
    emit(ForecastLoading());
    try {
      Position position = await GeoLocatorService.determinePosition();
      long = position.longitude;
      lat = position.latitude;

      // Debug: Log the coordinates
      log('Location coordinates: lat=$lat, lon=$long');

      // Validate coordinates
      if (lat == 0.0 && long == 0.0) {
        emit(
          ForecastError(
            'Unable to get valid location coordinates. Please enable location services and try again.',
          ),
        );
        return;
      }

      return get4DayForecast();
    } catch (e) {
      log('Location error: $e');
      emit(ForecastError('Location Error: $e'));
    }
  }

  // Add necessary properties and methods for forecast functionality
  // For example, fetching 4-day forecast data
  void get4DayForecast() async {
    emit(ForecastLoading());
    try {
      // Debug: Log API request details
      log('Making forecast API request with lat=$lat, lon=$long');

      final data = await apiService.get4DayForecast(
        lat,
        long,
      ); // Fixed: lat first, then long

      // Get city name from first forecast item if available
      String cityName = data.isNotEmpty
          ? (data.first.name ?? 'Unknown')
          : 'Unknown';

      emit(ForecastSuccess(cityName, data));
    } catch (e) {
      log('Forecast method error: $e');
      emit(ForecastError('Forecast Error: $e'));
    }
  }
}
