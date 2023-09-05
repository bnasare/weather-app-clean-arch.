import 'package:weather_app_clean_architecture/features/weather_app/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.country,
    required super.mainWeather,
    required super.temp,
    required super.wind,
    required super.humidity,
    required super.feels_like,
    required super.pressure,
  });
  @override
  List<Object?> get props => [
        cityName,
        country,
        mainWeather,
        temp,
        wind,
        humidity,
        feels_like,
        pressure
      ];

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      mainWeather: (json['weather'][0]['main'] as String?) ?? '',
      temp: (json['main']['temp'] as double?) ?? 0.0,
      wind: (json['wind']['speed'] as double?) ?? 0.0,
      humidity: (json['main']['humidity'] as int?) ?? 0,
      feels_like: (json['main']['feels_like'] as double?) ?? 0.0,
      pressure: (json['main']['pressure'] as int?) ?? 0,
    );
  }
}
