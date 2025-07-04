import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/constant/app_url.dart';
import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final apiKey = dotenv.env['API_KEY'];

  String weatherAnimation(String condition) {
    debugPrint(condition);
    switch (condition) {
      case 'Clouds':
        return 'assets/cloudy.json';

      case 'Thunderstorm':
      case 'Tornado':
        return 'assets/thunder.json';

      case 'Rain':
      case 'Drizzle':
      case 'Squall':
        return 'assets/rainy.json';

      case 'Haze':
      case 'Smoke':
      case 'Mist':
      case 'Clear':
        return 'assets/sunny.json';

      default:
        return 'assets/default.json';
    }
  }

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}?q=$cityName&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    var cityName = await SharedPreferences.getInstance();
    cityName.setString('cityName', placemarks.first.locality.toString());
    final result = cityName.getString('cityName');
    return result ?? 'Unknown location';
  }
}
