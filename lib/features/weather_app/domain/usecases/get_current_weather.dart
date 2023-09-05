import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_clean_architecture/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather implements UseCase<Weather, Params> {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  @override
  Future<Either<Failure, Weather>?> call(Params params) async {
    return await repository.getCurrentWeather(params.cityName);
  }
}

class Params extends Equatable {
  final String cityName;

  const Params(this.cityName);

  @override
  List<Object?> get props => [cityName];
}
