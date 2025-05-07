import 'package:get/get.dart';

import '../controllers/akun_detail_controller.dart';

class AkunDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunDetailController>(
      () => AkunDetailController(),
    );
  }
}
