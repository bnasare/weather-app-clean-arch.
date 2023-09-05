import 'package:flutter/material.dart';
import 'package:weather_app_clean_architecture/features/weather_app/presentation/pages/weather_screen.dart';

import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initSl();
  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeatherScreen(cityName: 'Accra');
  }
}
