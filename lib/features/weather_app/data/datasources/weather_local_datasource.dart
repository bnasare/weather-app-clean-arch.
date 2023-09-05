import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel>? getLastWeather();
  Future<void>? cacheWeather(WeatherModel triviaToCache);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<WeatherModel>? getLastWeather() {
    final jsonString = sharedPreferences.getString('CACHED_WEATHER');
    if (jsonString != null) {
      return Future.value(WeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) async {
    sharedPreferences.setString(
        'CACHED_WEATHER', json.encode(weatherToCache.toJson()));
  }
}
