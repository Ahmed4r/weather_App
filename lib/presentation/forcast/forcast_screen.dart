import 'dart:ui';
import 'package:day_night_themed_switcher/day_night_themed_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/forecast_model.dart';
import 'package:weather_app/presentation/forcast/forcaset_state.dart';
import 'package:weather_app/presentation/forcast/forecast_cubit.dart';

import 'package:weather_app/presentation/settings/theme_cubit.dart';

class ForecastScreen extends StatefulWidget {
  static const String routeName = '/forecast';
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearch = false;
  void toggleShowSearch() {
    HapticFeedback.lightImpact();
    setState(() {
      showSearch = !showSearch;
    });
    if (!showSearch) {
      _searchController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: BlocBuilder<ForecastCubit, ForecastState>(
        builder: (context, state) {
          if (state is ForecastLoading) {
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
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            );
          } else if (state is ForecastSuccess) {
            final forecastData = state.forecast;
            return Scaffold(
              body: Container(
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
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: showSearch
                                    ? [
                                        Colors.orange.shade400,
                                        Colors.orange.shade600,
                                      ]
                                    : [
                                        Colors.blue.shade400,
                                        Colors.blue.shade600,
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (showSearch ? Colors.orange : Colors.blue)
                                          .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  toggleShowSearch();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      showSearch
                                          ? Icons.close_rounded
                                          : Icons.search_rounded,
                                      key: ValueKey(showSearch),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DayNightSwitch(
                            duration: Duration(milliseconds: 800),
                            // Initiallyl listen to theme changes
                            initiallyDark: isDarkMode,
                            size: 20,
                            onChange: (dark) =>
                                context.read<ThemeCubit>().toggleTheme(
                                  dark ? ThemeMode.dark : ThemeMode.light,
                                ),
                          ),
                        ],
                      ),
                      if (forecastData.list != null &&
                          forecastData.list!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                forecastData.city?.name != null
                                    ? forecastData.city!.name!
                                    : 'Unknown Location',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: showSearch ? 80 : 0,
                        child: showSearch
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.25),
                                            Colors.white.withOpacity(0.15),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.4),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(-5, -5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _searchController,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    '🌍 Search for a city...',
                                                hintStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15,
                                                    ),
                                                prefixIcon: Container(
                                                  margin: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.location_city_rounded,
                                                    color: Colors.blue.shade600,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              onSubmitted: (value) {
                                                if (value.trim().isNotEmpty) {
                                                  context
                                                      .read<ForecastCubit>()
                                                      .getForecast4DaysForCity(
                                                        value.trim(),
                                                      );
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blue.shade400,
                                                  Colors.blue.shade600,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () {
                                                  HapticFeedback.mediumImpact();
                                                  if (_searchController.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    context
                                                        .read<ForecastCubit>()
                                                        .getForecast4DaysForCity(
                                                          _searchController.text
                                                              .trim(),
                                                        );
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  child: const Icon(
                                                    Icons.search_rounded,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Forecast list
                      Expanded(
                        child: ListView.builder(
                          itemCount: _getDailyForecasts(
                            forecastData.list!,
                          ).length,
                          itemBuilder: (context, index) {
                            final dayData = _getDailyForecasts(
                              forecastData.list!,
                            )[index];
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
              ),
            );
          } else if (state is ForecastError) {
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
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
                      onPressed: () =>
                          context.read<ForecastCubit>().getLongLat(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else {
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
              child: Center(
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
              ),
            );
          }
        },
      ),
    );
  }

  List<ForecastList> _getDailyForecasts(List<ForecastList> forecasts) {
    Map<String, ForecastList> dailyForecasts = {};

    for (var forecast in forecasts) {
      if (forecast.dt != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(
          (forecast.dt! * 1000).toInt(),
        );
        final dateKey = DateFormat('yyyy-MM-dd').format(date);

        // Prefer forecasts around noon (12:00 PM) for better daily representation
        if (!dailyForecasts.containsKey(dateKey)) {
          dailyForecasts[dateKey] = forecast;
        } else {
          // If we already have a forecast for this day, check if current one is closer to noon
          final currentTime = date.hour;
          final existingTime = DateTime.fromMillisecondsSinceEpoch(
            (dailyForecasts[dateKey]!.dt! * 1000).toInt(),
          ).hour;

          // If current forecast is closer to 12 PM, use it instead
          if ((currentTime - 12).abs() < (existingTime - 12).abs()) {
            dailyForecasts[dateKey] = forecast;
          }
        }
      }
    }

    return dailyForecasts.values.toList();
  }

  Widget _buildForecastCard(ForecastList weatherData) {
    final weatherInfo = weatherData.weather?.isNotEmpty == true
        ? weatherData.weather!.first
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
                  DateFormat('EEE').format(
                    weatherData.dt != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                            (weatherData.dt! * 1000).toInt(),
                          )
                        : DateTime.now(),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat('MMM dd').format(
                    weatherData.dt != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                            (weatherData.dt! * 1000).toInt(),
                          )
                        : DateTime.now(),
                  ),
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
                  _getWeatherIcon(weatherInfo?.main.toString() ?? ''),
                  size: 32,
                  color: _getWeatherIconColor(
                    weatherInfo?.main.toString() ?? '',
                  ),
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
                  '${weatherData.main?.tempMax?.round() ?? 0}°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${weatherData.main?.tempMin?.round() ?? 0}°',
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
                if (weatherData.main?.humidity != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.water_drop, size: 16, color: Colors.blue[300]),
                      const SizedBox(width: 4),
                      Text(
                        '${weatherData.main!.humidity}%',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                if (weatherData.wind?.speed != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.air, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${weatherData.wind!.speed?.round()}m/s',
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
