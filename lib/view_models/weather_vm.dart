import 'package:flutter/material.dart';
import 'package:weather/init_getit.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/service/weather_service.dart';

class WeatherVm extends ChangeNotifier {
  bool _isloading = false;
  WeatherModel? _weatherModel;

  bool get isloading => _isloading;
  WeatherModel? get weatherModel => _weatherModel;

  Future<void> fetchWeather(String cityName) async {
    _isloading = true;
    notifyListeners();
    try {
      final weather = await locater<WeatherService>().getWeather(cityName);
      _weatherModel = weather;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
