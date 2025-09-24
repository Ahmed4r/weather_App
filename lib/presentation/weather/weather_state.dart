part of 'weather_cubit.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}

final class WeatherLoading extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherSuccess extends WeatherState {
  final Weather weather;
  final String formattedTime;
  const WeatherSuccess(this.weather, this.formattedTime);

  @override
  // TODO: implement props
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String errorMessage;
  const WeatherError(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
