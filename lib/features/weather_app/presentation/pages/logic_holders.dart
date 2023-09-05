import 'package:dartz/dartz.dart';
import 'package:weather_app_clean_architecture/core/error/failures.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/entities/weather.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/usecases/get_current_weather.dart';

class WeatherBloc {
  final GetCurrentWeather getCurrentWeather;

  WeatherBloc({required this.getCurrentWeather});

  Future<Either<Failure, Weather>> getWeather(String cityName) async {
    final result = await getCurrentWeather(const Params('cityName'));
    return result!
        .fold((failure) => Left(failure), (weather) => Right(weather));
  }
}
