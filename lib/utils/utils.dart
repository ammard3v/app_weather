import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/init_getit.dart';
import 'package:weather/service/weather_service.dart';

class Utils {
  static Widget buildWeatherInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static Widget buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child:
              isLoading
                  ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  static Widget buildWeatherDisplay(dynamic weatherData) {
    if (weatherData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_outlined,
              size: 80,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Search for a city to see weather',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 170,
            width: 200,
            child: Lottie.asset(
              locater<WeatherService>().weatherAnimation(
                weatherData?.weather?.isNotEmpty == true
                    ? weatherData?.weather![0].main ?? 'Clear'
                    : 'Clear',
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  weatherData?.name?.toString() ?? 'Unknown Location',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  weatherData?.weather?.isNotEmpty == true
                      ? weatherData?.weather![0].description?.toUpperCase() ??
                          'CLEAR SKY'
                      : 'CLEAR SKY',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '${weatherData?.main?.temp?.toStringAsFixed(0) ?? '0'}°',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Celsius',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Utils.buildWeatherInfoItem(
                      icon: Icons.thermostat,
                      label: 'Feels like',
                      value:
                          '${weatherData?.main?.feelsLike?.toStringAsFixed(0) ?? '0'}°C',
                    ),
                    Utils.buildWeatherInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value:
                          '${weatherData?.main?.humidity?.toString() ?? '0'}%',
                    ),
                    Utils.buildWeatherInfoItem(
                      icon: Icons.air,
                      label: 'Wind',
                      value:
                          '${weatherData?.wind?.speed?.toStringAsFixed(1) ?? '0'} m/s',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
