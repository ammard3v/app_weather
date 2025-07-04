import 'package:get_it/get_it.dart';
import 'package:weather/service/weather_service.dart';

final locater = GetIt.instance;

void setup() {
  locater.registerLazySingleton<WeatherService>(() => WeatherService());
}
