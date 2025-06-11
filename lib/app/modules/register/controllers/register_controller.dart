import 'dart:convert';

import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  static const String _tag = 'RegisterController';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noWaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
  final RxBool isReady = false.obs;

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final storageService = Get.find<StorageService>();

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _debugLog('onInit called');
    _safeInitialize();
    _setupTextFieldListeners();
  }

  void _setupTextFieldListeners() {
    // Listener untuk format otomatis nomor WhatsApp
    noWaController.addListener(() {
      _formatWhatsAppNumber();
    });
  }

  void _formatWhatsAppNumber() {
    if (_isDisposed || !isReady.value) return;

    String currentText = noWaController.text;

    // Jika user mengetik 0 di awal, ganti dengan 62
    if (currentText.startsWith('0') && currentText.length == 1) {
      noWaController.text = '62';
      noWaController.selection = TextSelection.fromPosition(
        TextPosition(offset: noWaController.text.length),
      );
    }
    // Jika user mengetik 08, ganti dengan 628
    else if (currentText.startsWith('08')) {
      String newText = '628' + currentText.substring(2);
      noWaController.text = newText;
      noWaController.selection = TextSelection.fromPosition(
        TextPosition(offset: noWaController.text.length),
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void _safeInitialize() async {
    try {
      _debugLog('Starting initialization');

      // Tunggu frame berikutnya untuk memastikan UI ready
      await Future.delayed(const Duration(milliseconds: 100));

      if (_isDisposed) {
        _debugLog('Controller disposed during initialization');
        return;
      }

      // Reset form ke state awal
      _resetForm();

      // Set ready state
      isReady.value = true;
      _debugLog('Controller initialization completed');
    } catch (e) {
      _debugLog('Error during initialization: $e');
    }
  }

  void _resetForm() {
    if (_isDisposed) return;

    try {
      // Clear all controllers
      nameController.clear();
      emailController.clear();
      noWaController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Reset all error states
      nameError.value = false;
      emailError.value = false;
      noWaError.value = false;
      passwordError.value = false;
      confirmPasswordError.value = false;

      // Clear error texts
      nameErrorText.value = '';
      emailErrorText.value = '';
      noWaErrorText.value = '';
      passwordErrorText.value = '';
      confirmPasswordErrorText.value = '';

      // Reset loading state
      isLoading.value = false;

      _debugLog('Form reset completed');
    } catch (e) {
      _debugLog('Error resetting form: $e');
    }
  }

  void validateName() {
    if (_isDisposed || !isReady.value) return;

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
    if (_isDisposed || !isReady.value) return;

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
    if (_isDisposed || !isReady.value) return;

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
    if (_isDisposed || !isReady.value) return;

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
    if (_isDisposed || !isReady.value) return;

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
    if (_isDisposed || !isReady.value) return false;

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
    if (_isDisposed || !isReady.value) return false;

    try {
      _debugLog('Checking email registration for: ${emailController.text}');

      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/email/check-registration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text}),
      );

      if (_isDisposed) {
        _debugLog('Controller disposed during email check');
        return false;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      _debugLog('Email check response: $responseData');

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
      _debugLog('Error checking email registration: $e');
      return true; // Biarkan melanjutkan jika ada error
    }
  }

  void register() async {
    if (_isDisposed || !isReady.value || isLoading.value) {
      _debugLog(
          'Register blocked - Disposed: $_isDisposed, Ready: ${isReady.value}, Loading: ${isLoading.value}');
      return;
    }

    _debugLog('Starting registration process');

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
      _debugLog('Email not available, stopping registration');
      return;
    }

    if (_isDisposed) {
      _debugLog('Controller disposed during email check');
      return;
    }

    isLoading.value = true;

    // Store values sebelum async operations untuk menghindari controller disposal issues
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final noWa = noWaController.text.trim();

    _debugLog('Attempting registration for email: $email');

    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'no_wa': noWa,
        }),
      );
      print(response.body);
      if (_isDisposed) {
        _debugLog('Controller disposed during HTTP request');
        return;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      isLoading.value = false;

      if (response.statusCode == 201 && responseData['status'] == true) {
        await storageService.storeEmail(email);

        _clearFormBeforeNavigation();

        Get.snackbar(
          'Berhasil',
          'Registrasi berhasil! Silakan cek email untuk verifikasi.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_isDisposed) {
            _debugLog('Navigating to verification page');
            Get.offAllNamed(Routes.SUKSES_VERIFIKASI_EMAIL);
          }
        });
      } else {
        if (responseData.containsKey('errors')) {
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
      _debugLog('Registration error: $e');

      if (!_isDisposed) {
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

  void _clearFormBeforeNavigation() {
    if (_isDisposed) return;

    try {
      nameController.clear();
      emailController.clear();
      noWaController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } catch (e) {}
  }

  void goToLogin() {
    if (_isDisposed || !isReady.value) {
      return;
    }
    _resetForm();
    Get.back();
  }

  void _debugLog(String message) {
    print('$_tag: $message');
  }

  @override
  void onClose() {
    _debugLog('onClose called');
    _isDisposed = true;

    try {
      nameController.dispose();
      emailController.dispose();
      noWaController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    } catch (e) {
      _debugLog('Error disposing controllers: $e');
    }

    super.onClose();
  }
}
