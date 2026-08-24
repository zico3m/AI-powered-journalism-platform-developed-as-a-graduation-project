import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/TTS/WeatherController.dart';

class WeatherDetailsView extends StatefulWidget {
  const WeatherDetailsView({super.key});

  @override
  State<WeatherDetailsView> createState() =>
      _WeatherDetailsViewState();
}

class _WeatherDetailsViewState
    extends State<WeatherDetailsView> {

  final WeatherController controller =
  Get.find<WeatherController>();

  double cloudPosition = -200;
  late Timer timer;

  bool get isNight {
    final hour = DateTime.now().hour;
    return hour >= 18 || hour <= 5;
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
        const Duration(milliseconds: 50), (_) {
      setState(() {
        cloudPosition += 1.5;
        if (cloudPosition > 400) {
          cloudPosition = -200;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<Color> _getGradient() {
    if (isNight) {
      return [
        const Color(0xFF0F2027),
        const Color(0xFF203A43),
        const Color(0xFF2C5364),
      ];
    } else {
      return [
        const Color(0xFF4A90E2),
        const Color(0xFF1F3A5F),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
                color: Colors.white),
          );
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _getGradient(),
            ),
          ),
          child: Stack(
            children: [

              /// ☁️ سحب متحركة
              Positioned(
                top: 120,
                left: cloudPosition,
                child: const Icon(
                  Icons.cloud,
                  size: 120,
                  color: Colors.white24,
                ),
              ),

              Positioned(
                top: 200,
                left: cloudPosition - 150,
                child: const Icon(
                  Icons.cloud,
                  size: 90,
                  color: Colors.white30,
                ),
              ),

              /// ☀️ أو 🌙
              Positioned(
                top: 80,
                right: 40,
                child: Icon(
                  isNight
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  size: 80,
                  color: isNight
                      ? Colors.white70
                      : Colors.yellowAccent,
                ),
              ),

              SafeArea(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [

                    Text(
                      controller.city.value,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      controller.description.value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      '${controller.temperature.value}°',
                      style: const TextStyle(
                        fontSize: 90,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      margin:
                      const EdgeInsets.symmetric(
                          horizontal: 30),
                      padding:
                      const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.1),
                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,
                        children: [
                          _buildStat(
                            "Humidity",
                            controller
                                .humidity.value,
                            Icons.water_drop,
                          ),
                          _buildStat(
                            "Wind",
                            controller
                                .windSpeed.value,
                            Icons.air,
                          ),
                          _buildStat(
                            "Visibility",
                            controller
                                .visibility.value,
                            Icons.visibility,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(
      String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              color: Colors.white60,
              fontSize: 12),
        ),
      ],
    );
  }
}
