import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/core/error/failures.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/datasources/weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/datasources/weather_remote_datasources.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/models/weather_model.dart';
import 'package:weather_app_clean_architecture/features/weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/entities/weather.dart';

class MockRemoteDataSource extends Mock implements WeatherRemoteDataSource {}

class MockLocalDataSource extends Mock implements WeatherLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late WeatherRepositoryImplementation repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getCurrentWeather', () {
    const tCityName = 'Accra';
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
    const Weather tWeather = tWeatherModel;

    void runTestOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
        });

        body();
      });
    }

    void runTestOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
        });

        body();
      });
    }

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      await repository.getCurrentWeather(tCityName);
      verify(mockNetworkInfo.isConnected());
    });

    runTestOnline(() {
      test(
        'should return remote data when call to remote datasource is successful',
        () async {
          when(mockRemoteDataSource.getCurrentWeather('Accra'))
              .thenAnswer((_) async => tWeatherModel);

          final result = await repository.getCurrentWeather(tCityName);

          verify(mockRemoteDataSource.getCurrentWeather(tCityName));
          expect(result, equals(const Right(tWeather))); // Updated assertion
        },
      );

      test(
        'should cache data locally when call to remote datasource is successful',
        () async {
          when(mockRemoteDataSource.getCurrentWeather('Accra'))
              .thenAnswer((_) async => tWeatherModel);

          await repository.getCurrentWeather(tCityName);

          verify(mockRemoteDataSource.getCurrentWeather(tCityName));
          verify(mockLocalDataSource.cacheWeather(tWeatherModel));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastWeather())
              .thenAnswer((_) async => tWeatherModel);

          final result = await repository.getCurrentWeather(tCityName);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastWeather());
          expect(result, equals(const Right(tWeather)));
        },
      );

      test(
        'should return cache failure when no cached data is present',
        () async {
          when(mockLocalDataSource.getLastWeather())
              .thenThrow(CacheException());

          final result = await repository.getCurrentWeather(tCityName);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastWeather());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
