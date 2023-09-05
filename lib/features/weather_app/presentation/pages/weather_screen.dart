import 'package:flutter/material.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/entities/weather.dart';
import 'package:weather_app_clean_architecture/features/weather_app/domain/usecases/get_current_weather.dart';

import '../../../../dependency_injection.dart';
import '../../domain/repositories/weather_repository.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;

  const WeatherScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityNameController = TextEditingController();
  late GetCurrentWeather getCurrentWeather;

  @override
  void initState() {
    super.initState();

    final weatherRepository = sl<WeatherRepository>();

    getCurrentWeather = GetCurrentWeather(weatherRepository);
  }

  @override
  void dispose() {
    cityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cityNameController,
                        decoration:
                            const InputDecoration(labelText: 'Enter City Name'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final cityName = cityNameController.text;
                        final params = Params(cityName);
                        final weatherEither = await getCurrentWeather(params);

                        setState(() {
                          _weatherDataSnapshot = weatherEither?.fold(
                            (failure) => AsyncSnapshot.withError(
                                ConnectionState.done, failure),
                            (weather) => AsyncSnapshot.withData(
                                ConnectionState.done, weather),
                          );
                        });
                      },
                      child: const Text('Get Weather'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FutureBuilder<Weather?>(
                future: Future.value(_weatherDataSnapshot?.data),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final weather = snapshot.data!;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWeatherDetailColumn(
                                'City:', weather.cityName),
                            _buildWeatherDetailColumn(
                                'Country:', weather.country),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWeatherDetailColumn(
                                'Main Weather: ', weather.mainWeather),
                            _buildWeatherDetailColumn('Temperature: ',
                                '${(weather.temp - 273.0).toStringAsFixed(1)}°C'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWeatherDetailColumn(
                                'Wind Speed: ', '${weather.wind}m/s'),
                            _buildWeatherDetailColumn(
                                'Humidity: ', '${weather.humidity}%'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWeatherDetailColumn('Feels Like: ',
                                '${(weather.feels_like - 273.0).toStringAsFixed(1)}°C'),
                            _buildWeatherDetailColumn(
                                'Pressure: ', '${weather.pressure}hPa'),
                          ],
                        )
                      ],
                    );
                  } else {
                    return const Text(
                        'Enter a city name and click "Get Weather"');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailColumn(String label, String value) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  AsyncSnapshot<Weather>? _weatherDataSnapshot;
}
