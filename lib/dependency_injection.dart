import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_clean_architecture/features/weather_app/presentation/pages/logic_holders.dart';

import 'core/network/network_info.dart';
import 'features/weather_app/data/datasources/weather_local_datasource.dart';
import 'features/weather_app/data/datasources/weather_remote_datasources.dart';
import 'features/weather_app/data/repositories/weather_repository_impl.dart';
import 'features/weather_app/domain/repositories/weather_repository.dart';
import 'features/weather_app/domain/usecases/get_current_weather.dart';

final sl = GetIt.instance;

Future<void> initSl() async {
  sl.registerFactory(() => GetCurrentWeather(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => WeatherBloc(getCurrentWeather: sl()));
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()));
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });

  sl.registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WeatherLocalDataSource>(() =>
      WeatherLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()));
  sl.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImplementation(
            remoteDataSource: sl<WeatherRemoteDataSource>(),
            localDataSource: sl<WeatherLocalDataSource>(),
            networkInfo: sl<NetworkInfo>(),
          ));

  await sl.allReady();
}
