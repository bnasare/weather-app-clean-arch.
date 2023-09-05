import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_clean_architecture/features/weather_app/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel>? getCurrentWeather(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel>? getCurrentWeather(String cityName) async {
    final response = await client.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=ab7b5e3eb8243c1dbf7db9e76f6613f5'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
