import 'package:equatable/equatable.dart';
import 'package:weather_app/model/weather_model.dart';

class ForecastState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastSuccess extends ForecastState {
  final String cityName;
  final List<Weather> forecast;
  ForecastSuccess(this.cityName, this.forecast);
  @override
  List<Object?> get props => [cityName, forecast];
}

class ForecastError extends ForecastState {
  final String message;
  ForecastError(this.message);
  @override
  List<Object?> get props => [message];
}
