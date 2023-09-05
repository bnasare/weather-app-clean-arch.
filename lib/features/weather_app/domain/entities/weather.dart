import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final String country;
  final String mainWeather;
  final num temp;
  final num wind;
  final num humidity;
  final num feels_like;
  final num pressure;

  const Weather(
      {required this.cityName,
      required this.country,
      required this.mainWeather,
      required this.temp,
      required this.wind,
      required this.humidity,
      required this.feels_like,
      required this.pressure});

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

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'mainWeather': mainWeather,
      'temp': temp,
      'wind': wind,
      'humidity': humidity,
      'feels_like': feels_like,
      'pressure': pressure,
    };
  }
}
