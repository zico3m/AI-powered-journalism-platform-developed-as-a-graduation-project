// import 'package:get/get.dart';
//
//
// class WeatherController extends GetxController {
//   final WeatherRepository _repo = WeatherRepository();
//
//   var notificationsEnabled = false.obs;
//   var isLoading = false.obs;
//
//   var city = ''.obs;
//   var temperature = ''.obs;
//   var description = ''.obs;
//   var icon = ''.obs;
//
//   /// 🔔 عند تغيير السويتش
//   Future<void> onNotificationToggle(bool value) async {
//     notificationsEnabled.value = value;
//
//     if (!value) return; // لو طفى السويتش لا نفعل شيء
//
//     try {
//       isLoading.value = true;
//
//       final weather = await _repo.getWeatherByLocation();
//
//       city.value = weather['name'];
//       temperature.value =
//           weather['main']['temp'].toString();
//       description.value =
//       weather['weather'][0]['description'];
//       print('Weather city: ${city.value}');
//
//       Get.snackbar(
//         'الطقس حسب موقعك',
//         '$city | $temperature° | $description',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       notificationsEnabled.value = false; // نرجع السويتش OFF
//       Get.snackbar(
//         'خطأ',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
//
// class WeatherRepository {
//   static const String _apiKey = 'API_KEY_HERE';
//   static const String _baseUrl =
//       'https://api.openweathermap.org/data/2.5/weather';
//
//   /// 🔹 جلب الموقع
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('GPS غير مفعل');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('تم رفض إذن الموقع');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('إذن الموقع مرفوض نهائيًا');
//     }
//
//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }
//
//   /// 🔹 جلب الطقس حسب الموقع
//   Future<Map<String, dynamic>> getWeatherByLocation() async {
//     final position = await getCurrentLocation();
//
//     final url = Uri.parse(
//       '$_baseUrl'
//           '?lat=${position.latitude}'
//           '&lon=${position.longitude}'
//           '&appid=$_apiKey'
//           '&units=metric'
//           '&lang=ar',
//     );
//
//     final response = await http.get(url);
//
//     if (response.statusCode != 200) {
//       throw Exception('فشل في جلب بيانات الطقس');
//     }
//
//     return json.decode(response.body);
//   }
// }
//
// Obx(() => _buildSwitchItem(
// iconcolr: isDark
// ? AppColor.background
//     : AppColor.primary,
// icon: Icons.notifications_active_rounded,
// title: 'GPS'.tr,
// value: weatherController.notificationsEnabled.value,
// onChanged: (val) {
// weatherController.onNotificationToggle(val);
// },
// textPrimary: textPrimary,
// )),
//
//
//
// PreferredSizeWidget _buildAppBar(bool isDark) {
// return AppBar(
// elevation: 0,
// backgroundColor:
// isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
// foregroundColor:
// isDark ? AppColor.darkTextPrimary : AppColor.primary,
// centerTitle: true,
//
// title: Obx(() {
// if (weatherController.city.isEmpty) {
// return const Text(
// 'weather',
// style: TextStyle(
// fontFamily: 'Cairo',
// fontWeight: FontWeight.w900,
// fontSize: 20,
// ),
// );
// }
//
// return Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Image.network(
// 'https://openweathermap.org/img/wn/${weatherController.icon.value}@2x.png',
// width: 28,
// height: 28,
// ),
// const SizedBox(width: 6),
// Text(
// '${weatherController.city.value} '
// '${weatherController.temperature.value}°',
// style: const TextStyle(
// fontFamily: 'Cairo',
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// ],
// );
// }),
//
// /// 🔔 Notifications (كما هو — ممتاز)
// leading: IconButton(
// icon: Stack(
// children: [
// Icon(
// Icons.notifications_active,
// color: isDark
// ? AppColor.darkTextPrimary
//     : AppColor.primary,
// ),
// Obx(() {
// final count = notificationsController.unreadCount;
// if (count == 0) return const SizedBox.shrink();
//
// return Positioned(
// right: 0,
// top: 0,
// child: Container(
// width: 16,
// height: 16,
// decoration: const BoxDecoration(
// color: Colors.red,
// shape: BoxShape.circle,
// ),
// child: Center(
// child: Text(
// count.toString(),
// style: const TextStyle(
// fontSize: 9,
// color: Colors.white,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ),
// );
// }),
// ],
// ),
// onPressed: () => Get.to(() => NotificationsView()),
// ),
//
// actions: [
// IconButton(
// icon: Icon(
// Icons.search_rounded,
// color: isDark
// ? AppColor.darkTextPrimary
//     : AppColor.primary,
// ),
// onPressed: () => Get.to(() => SearchView()),
// ),
//
// Obx(() {
// final image = profileController.profileImageUrl.value;
// return GestureDetector(
// onTap: () => Get.to(() => UserProfileView()),
// child: Container(
// width: 40,
// height: 36,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// border: Border.all(
// color: isDark
// ? AppColor.darkTextSecondary
//     : AppColor.primary,
// ),
// ),
// child: CircleAvatar(
// backgroundColor:
// isDark ? AppColor.darkBackground : AppColor.background,
// backgroundImage:
// (image != null && image.isNotEmpty)
// ? NetworkImage(image)
//     : null,
// child: (image == null || image.isEmpty)
// ? Icon(
// Icons.person,
// size: 20,
// color: isDark
// ? AppColor.darkTextSecondary
//     : AppColor.textSecondary,
// )
//     : null,
// ),
// ),
// );
// }),
// ],
// );
// }
