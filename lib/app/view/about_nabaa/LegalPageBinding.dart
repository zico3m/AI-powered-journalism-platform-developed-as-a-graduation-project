import 'package:get/get.dart';
import 'legal_page_controller.dart';

class LegalPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegalPageController>(() => LegalPageController());
  }
}
