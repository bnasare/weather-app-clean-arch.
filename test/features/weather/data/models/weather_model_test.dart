import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/models/weather_model.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/entities/weather.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const tWeatherModel = WeatherModel(
    cityName: 'Accra',
    country: 'GH',
    mainWeather: 'Rainy',
    temp: 37.0,
    wind: 57.0,
    humidity: 84,
    feels_like: 94.0,
    pressure: 29,
  );

  test(
    'should be a subclass of Weather entity',
    () {
      expect(
        tWeatherModel,
        isA<Weather>(),
      );
    },
  );

  group('fromJson', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('response.json'));
      final result = WeatherModel.fromJson(jsonMap);
      expect(result, tWeatherModel);
    });
  });
}
