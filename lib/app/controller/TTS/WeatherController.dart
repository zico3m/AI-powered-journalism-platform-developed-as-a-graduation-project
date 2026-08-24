import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/data/services/weatrher/WeatherService.dart';

class WeatherController extends GetxController {
  final WeatherRepository _repo = WeatherRepository();

  var notificationsEnabled = false.obs;
  var isLoading = false.obs;

  var humidity = ''.obs;
  var windSpeed = ''.obs;
  var visibility = ''.obs;

  var city = ''.obs;
  var temperature = ''.obs;
  var description = ''.obs;
  var icon = ''.obs;

  Future<void> onNotificationToggle(bool value) async {
    if (isLoading.value) return;

    notificationsEnabled.value = value;
    if (!value) return;

    try {
      isLoading.value = true;

      // 🔥 جلب بيانات الطقس مرة واحدة فقط
      final weather = await _repo.getWeatherByLocation();

      if (weather == null || weather.isEmpty) {
        throw Exception("لم يتم استلام بيانات الطقس");
      }

      final main = weather['main'] ?? {};
      final wind = weather['wind'] ?? {};
      final weatherList = weather['weather'] as List? ?? [];
      final weatherData =
      weatherList.isNotEmpty ? weatherList[0] : {};

      city.value = weather['name'] ?? "Unknown";

      humidity.value = '${main['humidity'] ?? 0}%';
      windSpeed.value = '${wind['speed'] ?? 0} km/h';
      visibility.value =
      '${((weather['visibility'] ?? 0) / 1000).round()} km';
      final position = await _repo.getCurrentLocation();

      city.value = await _repo.getBigCityName(
        position.latitude,
        position.longitude,
      );


      temperature.value =
          ((main['temp'] ?? 0) as num)
              .round()
              .toString();

      description.value =
          weatherData['description'] ?? '';

      icon.value =
          weatherData['icon'] ?? '';

      Get.snackbar(
        'Weather Updated',
        'Weather in ${city.value}: ${temperature.value}°C',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.yellow,
      );

    } catch (e) {
      notificationsEnabled.value = false;

      Get.snackbar(
        'Location Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }



}
