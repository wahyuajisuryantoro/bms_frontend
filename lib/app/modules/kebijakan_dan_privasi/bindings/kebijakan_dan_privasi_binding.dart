import 'package:get/get.dart';

import '../controllers/kebijakan_dan_privasi_controller.dart';

class KebijakanDanPrivasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KebijakanDanPrivasiController>(
      () => KebijakanDanPrivasiController(),
    );
  }
}
