import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/datasources/weather_remote_datasources.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/models/weather_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getCurrentWeather:', () {
    const tCityName = 'Accra';
    final tWeatherModel =
        WeatherModel.fromJson(json.decode(fixture('response.json')));

    test(
        'should perform a GET request on a URL with city name being the endpoint',
        () async {
      when(mockHttpClient.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$tCityName&appid=ab7b5e3eb8243c1dbf7db9e76f6613f5'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('response.json'), 200),
      );

      await dataSource.getCurrentWeather(tCityName);

      verify(mockHttpClient.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$tCityName&appid=ab7b5e3eb8243c1dbf7db9e76f6613f5'),
        headers: anyNamed('headers'),
      ));
    });

    test('should return weather if successful', () async {
      when(mockHttpClient.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$tCityName&appid=ab7b5e3eb8243c1dbf7db9e76f6613f5'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('response.json'), 200),
      );

      final result = await dataSource.getCurrentWeather(tCityName);

      expect(result, equals(tWeatherModel));
    });

    test('should throw an exception if the response status code is not 200',
        () {
      when(mockHttpClient.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$tCityName&appid=ab7b5e3eb8243c1dbf7db9e76f6613f5'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('Error', 404),
      );

      expect(() => dataSource.getCurrentWeather(tCityName), throwsException);
    });
  });
}
