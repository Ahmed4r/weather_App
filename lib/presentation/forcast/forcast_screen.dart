import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/presentation/forcast/forcaset_state.dart';
import 'package:weather_app/presentation/forcast/forecast_cubit.dart';
import 'package:weather_app/model/weather_model.dart';

class ForecastScreen extends StatelessWidget {
  static const String routeName = '/forecast';
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: BlocBuilder<ForecastCubit, ForecastState>(
        builder: (context, state) {
          if (state is ForecastLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (state is ForecastSuccess) {
            final forecastData = state.forecast;

            // Group forecast data by day (since API returns 3-hour intervals)
            final dailyForecasts = _groupForecastsByDay(forecastData);

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade300.withOpacity(0.3),
                    Colors.blue.shade100.withOpacity(0.1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header with current location info
                    SizedBox(height: 100),
                    if (forecastData.isNotEmpty &&
                        forecastData.first.name != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              forecastData.first.name ?? 'Unknown Location',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                 

                    // Forecast list
                    Expanded(
                      child: ListView.builder(
                        itemCount: dailyForecasts.length,
                        itemBuilder: (context, index) {
                          final dayData = dailyForecasts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildForecastCard(dayData),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ForecastError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading forecast',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<ForecastCubit>().getLongLat(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_queue, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text('Weather Forecast', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  const Text('Get your 5-day weather forecast'),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => context.read<ForecastCubit>().getLongLat(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Load Forecast',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Group forecast data by day
  List<DayForecast> _groupForecastsByDay(List<Weather> forecasts) {
    final Map<String, List<Weather>> groupedData = {};

    for (final forecast in forecasts) {
      if (forecast.dt != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(forecast.dt! * 1000);
        final dateKey = DateFormat('yyyy-MM-dd').format(date);

        if (!groupedData.containsKey(dateKey)) {
          groupedData[dateKey] = [];
        }
        groupedData[dateKey]!.add(forecast);
      }
    }

    return groupedData.entries.map((entry) {
      final dayForecasts = entry.value;
      // Use the midday forecast as representative, or first available
      final mainForecast = dayForecasts.firstWhere((f) {
        final hour = DateTime.fromMillisecondsSinceEpoch(f.dt! * 1000).hour;
        return hour >= 12 && hour <= 15; // Around noon
      }, orElse: () => dayForecasts.first);

      // Calculate min/max temps for the day
      final temps = dayForecasts
          .map((f) => f.main?.temp ?? 0.0)
          .where((temp) => temp > 0)
          .toList();

      final minTemp = temps.isNotEmpty
          ? temps.reduce((a, b) => a < b ? a : b)
          : 0.0;
      final maxTemp = temps.isNotEmpty
          ? temps.reduce((a, b) => a > b ? a : b)
          : 0.0;

      return DayForecast(
        date: DateTime.fromMillisecondsSinceEpoch(mainForecast.dt! * 1000),
        weather: mainForecast,
        minTemp: minTemp,
        maxTemp: maxTemp,
      );
    }).toList();
  }

  Widget _buildForecastCard(DayForecast dayData) {
    final weather = dayData.weather;
    final weatherInfo = weather.weather?.isNotEmpty == true
        ? weather.weather!.first
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date and day
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE').format(dayData.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat('MMM dd').format(dayData.date),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          // Weather icon and description
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Icon(
                  _getWeatherIcon(weatherInfo?.main ?? ''),
                  size: 32,
                  color: _getWeatherIconColor(weatherInfo?.main ?? ''),
                ),
                const SizedBox(height: 4),
                Text(
                  weatherInfo?.description?.toUpperCase() ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Temperature range
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${dayData.maxTemp.round()}°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${dayData.minTemp.round()}°',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Additional info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (weather.main?.humidity != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.water_drop, size: 16, color: Colors.blue[300]),
                      const SizedBox(width: 4),
                      Text(
                        '${weather.main!.humidity}%',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                if (weather.wind?.speed != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.air, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${weather.wind!.speed?.round()}m/s',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _getWeatherIconColor(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.grey;
      case 'rain':
      case 'drizzle':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.purple;
      case 'snow':
        return Colors.lightBlue;
      case 'mist':
      case 'fog':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }
}

// Helper class to group daily forecast data
class DayForecast {
  final DateTime date;
  final Weather weather;
  final double minTemp;
  final double maxTemp;

  DayForecast({
    required this.date,
    required this.weather,
    required this.minTemp,
    required this.maxTemp,
  });
}
