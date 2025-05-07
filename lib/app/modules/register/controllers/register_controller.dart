import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isLoading = false.obs;

  final RxBool nameError = false.obs;
  final RxBool emailError = false.obs;
  final RxBool passwordError = false.obs;
  final RxBool confirmPasswordError = false.obs;

  final RxString nameErrorText = ''.obs;
  final RxString emailErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;
  final RxString confirmPasswordErrorText = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool validateInputs() {
    bool isValid = true;

    nameError.value = false;
    emailError.value = false;
    passwordError.value = false;
    confirmPasswordError.value = false;

    if (nameController.text.isEmpty) {
      nameError.value = true;
      nameErrorText.value = 'Nama wajib diisi';
      isValid = false;
    }

    if (emailController.text.isEmpty) {
      emailError.value = true;
      emailErrorText.value = 'Email wajib diisi';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = true;
      emailErrorText.value = 'Format email tidak valid';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = true;
      passwordErrorText.value = 'Kata sandi wajib diisi';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = true;
      passwordErrorText.value = 'Kata sandi minimal 6 karakter';
      isValid = false;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = true;
      confirmPasswordErrorText.value = 'Konfirmasi kata sandi wajib diisi';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = true;
      confirmPasswordErrorText.value = 'Kata sandi tidak cocok';
      isValid = false;
    }

    return isValid;
  }

  void register() async {
    if (!validateInputs()) {
      Get.snackbar(
        'Gagal',
        'Mohon periksa kembali data yang diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      Get.snackbar(
        'Berhasil',
        'Pendaftaran berhasil, silahkan masuk',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal mendaftar: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
