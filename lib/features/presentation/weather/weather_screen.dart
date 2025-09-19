import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/features/presentation/settings/theme_cubit.dart';
import 'package:weather_app/features/presentation/weather/weather_cubit.dart';

class WeatherScreen extends StatefulWidget {
  static const routeName = '/weather';
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool showSearch = false;
  void toggleShowSearch() {
    setState(() {
      showSearch = !showSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: showSearch ? 200 : 50,
        leadingWidth: 300,
        title: showSearch
            ? TextField(
                decoration: InputDecoration(
                  hintText: 'Search city',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<WeatherCubit>().searchCityWeather(value);
                    toggleShowSearch();
                  }
                },
              )
            : null,

        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme(
                isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          IconButton(
            onPressed: () {
              toggleShowSearch();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<WeatherCubit>().getLongLat(),
                child: const Text('Get Weather'),
              ),
            );
          }
          if (state is WeatherLoading) {
            return Center(child: Lottie.asset('assets/Loading.json'));
          }
          if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage, style: TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () => context.read<WeatherCubit>().getLongLat(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is WeatherSuccess) {
            return buildWeatherData(context, state, isDarkMode);
          }
          return Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

Widget buildWeatherData(BuildContext context, state, isDarkMode) {
  return Center(
    child: RefreshIndicator(
      onRefresh: () async {
        await context.read<WeatherCubit>().getWeather();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Column(
          children: [
            const Icon(Icons.location_on, size: 50),
            SizedBox(height: 20),
            const Text('My Location', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // country- city
            Text(
              '${state.weather.sys?.country ?? ''} - ${state.weather.name ?? ''}',
              style: TextStyle(
                fontSize: 30,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            Text(
              state.formattedTime,
              style: TextStyle(
                fontSize: 30,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            // weather state image
            Lottie.asset(
              context.read<WeatherCubit>().getWeatherImage(
                state.weather.weather?[0].main,
              ),
            ),
            SizedBox(height: 20),
            // temperature
            Text(
              state.weather.main?.temp != null
                  ? '${state.weather.main!.temp!.toStringAsFixed(1)} °C'
                  : 'Loading...',
              // model.main?.temp != null
              //     ? '${model.main!.temp!.toStringAsFixed(1)} °C'
              //     : 'Loading...',
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Feels like ${state.weather.main?.feelsLike != null ? state.weather.main!.feelsLike!.toStringAsFixed(1) : 'Loading...'} °C',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // weather status
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    state.weather.weather?[0].main ?? 'Loading...',
                    style: const TextStyle(fontSize: 25),
                  ),
                  VerticalDivider(
                    color: Colors.amberAccent,
                    thickness: 2,
                    width: 30,
                  ),
                  Text(
                    state.weather.weather?[0].description ?? 'Loading...',
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //   min/max temp
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 10,
              children: [
                // Humidity
                Text(
                  'Humidity: ${state.weather.main?.humidity?.toString() ?? 'Loading...'} %',
                  style: const TextStyle(fontSize: 20),
                ),

                Text(
                  'Pressure: ${state.weather.main?.pressure?.toString() ?? 'Loading...'} hPa',
                  style: const TextStyle(fontSize: 20),
                ),

                Text(
                  'Min Temp: ${state.weather.main?.tempMin != null ? state.weather.main!.tempMin!.toStringAsFixed(1) : 'Loading...'} °C',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Max Temp: ${state.weather.main?.tempMax != null ? state.weather.main!.tempMax!.toStringAsFixed(1) : 'Loading...'} °C',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
