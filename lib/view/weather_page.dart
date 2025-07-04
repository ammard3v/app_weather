import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/init_getit.dart';
import 'package:weather/service/weather_service.dart';
import 'package:weather/utils/utils.dart';
import 'package:weather/view_models/weather_vm.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _getPlaceName = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeather();
    });
  }

  void _loadWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('cityName');

    final weatherVM = Provider.of<WeatherVm>(context, listen: false);

    if (city == null || city == 'Unknown location') {
      String currentCity = await locater<WeatherService>().getCurrentCity();
      await weatherVM.fetchWeather(currentCity);
    } else {
      await weatherVM.fetchWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherVM = Provider.of<WeatherVm>(context, listen: true);
    final weatherData = weatherVM.weatherModel;

    void getCurrentStatus() async {
      final prefs = await SharedPreferences.getInstance();
      final city = prefs.getString('cityName');

      if (city == null || city == 'Unknown location') {
        String cityName = await locater<WeatherService>().getCurrentCity();
        weatherVM.fetchWeather(cityName);
      } else {
        weatherVM.fetchWeather(city);
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD), Color(0xFF1E3A8A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _getPlaceName,
                          decoration: InputDecoration(
                            hintText: 'Enter city name...',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF4A90E2),
                              size: 24,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Utils.buildActionButton(
                              text: 'Search',
                              icon: Icons.search,
                              onTap: () {
                                String city = _getPlaceName.text.trim();
                                if (city.isNotEmpty) {
                                  weatherVM.fetchWeather(city);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Utils.buildActionButton(
                              text: 'Your Location',
                              icon: Icons.location_on,
                              onTap: getCurrentStatus,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child:
                      weatherVM.isloading
                          ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 3,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Loading weather data...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Utils.buildWeatherDisplay(weatherData),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
