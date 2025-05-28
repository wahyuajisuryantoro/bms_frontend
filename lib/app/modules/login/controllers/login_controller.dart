import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool passwordVisible = false.obs;
  
  final RxBool emailError = false.obs;
  final RxBool passwordError = false.obs;
  
  final RxString emailErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;
  
  final storageService = Get.find<StorageService>();
  
  @override
  void onInit() {
    super.onInit();
    // Cek apakah user sudah login
    if (storageService.isLoggedIn()) {
      // Arahkan ke halaman home
      Get.offAllNamed(Routes.HOME);
    }
  }
  
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }
  
  void validateEmail() {
    if (emailController.text.isEmpty) {
      emailError.value = true;
      emailErrorText.value = 'Email tidak boleh kosong';
      return;
    }
    
    if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = true;
      emailErrorText.value = 'Email tidak valid';
      return;
    }
    
    emailError.value = false;
  }
  
  void validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = true;
      passwordErrorText.value = 'Password tidak boleh kosong';
      return;
    }
    
    passwordError.value = false;
  }
  
  bool validateAll() {
    validateEmail();
    validatePassword();
    
    return !emailError.value && !passwordError.value;
  }
  
  void login() async {
    if (!validateAll()) {
      Get.snackbar(
        'Error',
        'Harap perbaiki data yang tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );
      
      isLoading.value = false;
      
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        await storageService.storeToken(responseData['token']);
        await storageService.storeUser(jsonEncode(responseData['user']));
        await storageService.setLoggedIn(true);

        emailController.clear();
        passwordController.clear();

        Get.offAllNamed(Routes.HOME);
        
        Get.snackbar(
          'Berhasil',
          'Login berhasil!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else if (response.statusCode == 403 && responseData['message'].toString().contains('Email belum diverifikasi')) {
        // Handle email belum diverifikasi
        await storageService.storeEmail(emailController.text);
        
        Get.snackbar(
          'Perhatian',
          'Email belum diverifikasi. Silakan cek email Anda.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        
        // Tunggu sebentar lalu arahkan ke halaman verifikasi
        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(Routes.SUKSES_VERIFIKASI_EMAIL);
      } else {
        // Handle error lainnya
        Get.snackbar(
          'Login Gagal',
          responseData['message'] ?? 'Terjadi kesalahan saat login',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
        );
        
        // Reset field password
        if (responseData['message'].toString().contains('Password salah')) {
          passwordController.clear();
          passwordError.value = true;
          passwordErrorText.value = 'Password salah. Silakan coba lagi.';
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  }
  
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
  
  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Fitur lupa password belum tersedia',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
    );
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}