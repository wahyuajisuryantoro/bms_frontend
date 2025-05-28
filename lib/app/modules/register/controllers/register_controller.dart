import 'dart:convert';

import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noWaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final RxBool nameError = false.obs;
  final RxBool emailError = false.obs;
  final RxBool noWaError = false.obs;
  final RxBool passwordError = false.obs;
  final RxBool confirmPasswordError = false.obs;
  
  final RxString nameErrorText = ''.obs;
  final RxString emailErrorText = ''.obs;
  final RxString noWaErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;
  final RxString confirmPasswordErrorText = ''.obs;
  
  final RxBool isLoading = false.obs;
  
  final storageService = Get.find<StorageService>();

  void validateName() {
    if (nameController.text.isEmpty) {
      nameError.value = true;
      nameErrorText.value = 'Nama tidak boleh kosong';
      return;
    }
    
    if (nameController.text.length < 3) {
      nameError.value = true;
      nameErrorText.value = 'Nama minimal 3 karakter';
      return;
    }
    
    nameError.value = false;
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

  void validateNoWa() {
    if (noWaController.text.isEmpty) {
      noWaError.value = true;
      noWaErrorText.value = 'Nomor WhatsApp tidak boleh kosong';
      return;
    }
    
    // Pastikan nomor WA dimulai dengan 62
    if (!noWaController.text.startsWith('62')) {
      noWaError.value = true;
      noWaErrorText.value = 'Nomor WhatsApp harus dimulai dengan 62';
      return;
    }
    
    // Pastikan panjang nomor WA minimal 10 digit setelah kode negara
    if (noWaController.text.length < 10) {
      noWaError.value = true;
      noWaErrorText.value = 'Nomor WhatsApp tidak valid';
      return;
    }
    
    noWaError.value = false;
  }

  void validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = true;
      passwordErrorText.value = 'Password tidak boleh kosong';
      return;
    }
    
    if (passwordController.text.length < 8) {
      passwordError.value = true;
      passwordErrorText.value = 'Password minimal 8 karakter';
      return;
    }
    
    passwordError.value = false;
  }

  void validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = true;
      confirmPasswordErrorText.value = 'Konfirmasi password tidak boleh kosong';
      return;
    }
    
    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = true;
      confirmPasswordErrorText.value = 'Password tidak sama';
      return;
    }
    
    confirmPasswordError.value = false;
  }

  bool validateAll() {
    validateName();
    validateEmail();
    validateNoWa();
    validatePassword();
    validateConfirmPassword();
    
    return !nameError.value && 
           !emailError.value && 
           !noWaError.value && 
           !passwordError.value && 
           !confirmPasswordError.value;
  }

  // Fungsi untuk mengecek status pendaftaran email
  Future<bool> checkEmailRegistration() async {
    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/email/check-registration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text}),
      );
      
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['status'] == true) {
        if (responseData['registered'] == true) {
          emailError.value = true;
          emailErrorText.value = 'Email sudah terdaftar';
          return false;
        } else if (responseData['pending'] == true) {
          Get.snackbar(
            'Info',
            'Pendaftaran dengan email ini sudah ada dan menunggu verifikasi. Silakan cek email Anda.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      }
      return true;
    } catch (e) {
      print('Error checking email registration: $e');
      return true; // Biarkan melanjutkan jika ada error
    }
  }

  void register() async {
    if (!validateAll()) {
      Get.snackbar(
        'Error',
        'Harap perbaiki data yang tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Cek apakah email sudah terdaftar
    final emailAvailable = await checkEmailRegistration();
    if (!emailAvailable) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
          'no_wa': noWaController.text,
        }),
      );
      
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      isLoading.value = false;
      
      if (response.statusCode == 201 && responseData['status'] == true) {
        // Simpan email untuk halaman verifikasi
        await storageService.storeEmail(emailController.text);
        
        // Bersihkan form
        nameController.clear();
        emailController.clear();
        noWaController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        
        // Navigasi ke halaman sukses verifikasi
        Get.offNamed(Routes.SUKSES_VERIFIKASI_EMAIL);
      } else {
        // Tampilkan pesan error
        if (responseData.containsKey('errors')) {
          // Handle validasi error dari server
          final Map<String, dynamic> errors = responseData['errors'];
          
          if (errors.containsKey('name')) {
            nameError.value = true;
            nameErrorText.value = errors['name'][0];
          }
          
          if (errors.containsKey('email')) {
            emailError.value = true;
            emailErrorText.value = errors['email'][0];
          }
          
          if (errors.containsKey('password')) {
            passwordError.value = true;
            passwordErrorText.value = errors['password'][0];
          }
          
          if (errors.containsKey('no_wa')) {
            noWaError.value = true;
            noWaErrorText.value = errors['no_wa'][0];
          }
          
          Get.snackbar(
            'Validasi Gagal',
            'Harap perbaiki data yang tidak valid',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Registrasi Gagal',
            responseData['message'] ?? 'Terjadi kesalahan pada server',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
}