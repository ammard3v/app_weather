import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather/init_getit.dart';
import 'package:weather/view/weather_page.dart';
import 'package:weather/view_models/weather_vm.dart';

void main() async {
  setup();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WeatherVm())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: WeatherPage()),
      ),
    );
  }
}
