import 'package:get/get.dart';

import '../controllers/list_mobil_controller.dart';

class ListMobilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListMobilController>(
      () => ListMobilController(),
    );
  }
}
