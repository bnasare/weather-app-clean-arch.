import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/datasources/weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/models/weather_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WeatherLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        WeatherLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastWeather', () {
    final tWeatherModel =
        WeatherModel.fromJson(json.decode(fixture('response.json')));
    test(
      'should return Weather from Shared preferences when one is in the cache',
      () async {
        when(mockSharedPreferences.getString('CACHED_WEATHER'))
            .thenReturn(fixture('response.json'));
        final result = await dataSource.getLastWeather();
        verify(mockSharedPreferences.getString('CACHED_WEATHER'));
        expect(result, equals(tWeatherModel));
      },
    );

    test(
      'should throw CacheException when there is not a cached value',
      () async {
        when(mockSharedPreferences.getString('CACHED_WEATHER'))
            .thenReturn(null);

        call() async {
          await dataSource.getLastWeather();
        }

        expect(call, throwsA(isA<CacheException>()));
      },
    );

    group('cacheNumberTrivia', () {
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
      test('should call SharedPreferences to cache the data', () async {
        dataSource.cacheWeather(tWeatherModel);
        final expectedJsonString = json.encode(tWeatherModel.toJson());
        verify(mockSharedPreferences.setString(
            'CACHED_WEATHER', expectedJsonString));
      });
    });
  });
}
