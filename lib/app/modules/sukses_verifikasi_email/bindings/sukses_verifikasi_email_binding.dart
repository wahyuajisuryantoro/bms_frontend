import 'package:get/get.dart';

import '../controllers/sukses_verifikasi_email_controller.dart';

class SuksesVerifikasiEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuksesVerifikasiEmailController>(
      () => SuksesVerifikasiEmailController(),
    );
  }
}
