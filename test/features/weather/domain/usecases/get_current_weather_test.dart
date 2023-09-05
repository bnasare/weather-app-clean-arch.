import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/entities/weather.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/repositories/weather_repository.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/usecases/get_current_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeather useCase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();

    useCase = GetCurrentWeather(mockWeatherRepository);
  });

  const tCityName = 'Accra';
  const tWeather = Weather(
    cityName: 'Accra',
    country: 'GH',
    mainWeather: 'Rainy',
    temp: 37.0,
    wind: 57.0,
    humidity: 84,
    feels_like: 94.0,
    pressure: 29,
  );

  test('Data fetched through weather repository', () async {
    when(mockWeatherRepository.getCurrentWeather(tCityName))
        .thenAnswer((_) async => const Right(tWeather));

    final result = await useCase.call(const Params(tCityName));

    expect(result, const Right(tWeather));

    verify(mockWeatherRepository.getCurrentWeather(tCityName)).called(1);

    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
