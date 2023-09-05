import 'package:dartz/dartz.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasources.dart';

class WeatherRepositoryImplementation implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImplementation(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    final isConnected = await networkInfo.isConnected();

    if (isConnected == true) {
      try {
        final remoteWeather =
            await remoteDataSource.getCurrentWeather(cityName);
        if (remoteWeather != null) {
          localDataSource.cacheWeather(remoteWeather);
          return Right(remoteWeather);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localWeather = await localDataSource.getLastWeather();
        if (localWeather != null) {
          return Right(localWeather);
        } else {
          return Left(CacheFailure());
        }
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
