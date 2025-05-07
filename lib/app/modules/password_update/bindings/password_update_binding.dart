import 'package:get/get.dart';

import '../controllers/password_update_controller.dart';

class PasswordUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordUpdateController>(
      () => PasswordUpdateController(),
    );
  }
}
