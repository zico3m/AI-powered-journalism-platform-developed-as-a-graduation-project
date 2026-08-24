import 'package:get/get.dart';

import '../mange/editor_home_controller.dart';

class EditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditorHomeController());
  }
}
