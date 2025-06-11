import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  static const String _tag = 'LoginController';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isReady = false.obs;
  final RxBool passwordVisible = false.obs;

  final RxBool emailError = false.obs;
  final RxBool passwordError = false.obs;

  final RxString emailErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;

  final storageService = Get.find<StorageService>();

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _debugLog('onInit called');
    _safeInitialize();
  }

  void _safeInitialize() async {
    try {
      _debugLog('Starting initialization');
      await Future.delayed(const Duration(milliseconds: 100));
      if (_isDisposed) {
        _debugLog('Controller disposed during initialization');
        return;
      }
      if (storageService.isLoggedIn()) {
        _debugLog('User already logged in, redirecting to home');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed) {
            Get.offAllNamed(Routes.HOME);
          }
        });
        return;
      }

      _resetForm();

      isReady.value = true;
      _debugLog('Controller initialization completed');
    } catch (e) {
      _debugLog('Error during initialization: $e');
    }
  }

  void _resetForm() {
    if (_isDisposed) return;

    try {
      emailController.clear();
      passwordController.clear();

      emailError.value = false;
      passwordError.value = false;

      emailErrorText.value = '';
      passwordErrorText.value = '';

      passwordVisible.value = false;
      isLoading.value = false;

      _debugLog('Form reset completed');
    } catch (e) {
      _debugLog('Error resetting form: $e');
    }
  }

  void togglePasswordVisibility() {
    if (_isDisposed || !isReady.value) {
      _debugLog(
          'togglePasswordVisibility blocked - Disposed: $_isDisposed, Ready: ${isReady.value}');
      return;
    }
    passwordVisible.value = !passwordVisible.value;
    _debugLog('Password visibility toggled: ${passwordVisible.value}');
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

  void validatePassword() {
    if (_isDisposed || !isReady.value) return;

    if (passwordController.text.isEmpty) {
      passwordError.value = true;
      passwordErrorText.value = 'Password tidak boleh kosong';
      return;
    }

    passwordError.value = false;
  }

  bool validateAll() {
    if (_isDisposed || !isReady.value) return false;

    validateEmail();
    validatePassword();

    return !emailError.value && !passwordError.value;
  }

  void login() async {
  if (_isDisposed || !isReady.value || isLoading.value) {
    _debugLog(
        'Login blocked - Disposed: $_isDisposed, Ready: ${isReady.value}, Loading: ${isLoading.value}');
    return;
  }

  _debugLog('Starting login process');

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

  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  try {
    final response = await http.post(
      Uri.parse('${BaseUrl.baseUrl}/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print(response.body);

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['status'] == true) {
      _debugLog('Login successful');

      // Store token dan user basic info
      await storageService.storeToken(responseData['token']);
      await storageService.storeUser(jsonEncode(responseData['user']));
      await storageService.setLoggedIn(true);

      // ADDED: Get profile detail setelah login berhasil
      await _getProfileDetail();

      _clearFormBeforeNavigation();

      Get.snackbar(
        'Berhasil',
        'Login berhasil!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      isLoading.value = false;

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_isDisposed) {
          Get.offAllNamed(Routes.HOME);
        }
      });
    } else if (response.statusCode == 403 &&
        responseData['message']
            .toString()
            .contains('Email belum diverifikasi')) {
      _debugLog('Email not verified, redirecting to verification page');

      isLoading.value = false;
      await storageService.storeEmail(email);

      Get.snackbar(
        'Perhatian',
        'Email belum diverifikasi. Silakan cek email Anda.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      _clearFormBeforeNavigation();

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!_isDisposed) {
          _debugLog('Navigating to verification page');
          Get.offAllNamed(Routes.SUKSES_VERIFIKASI_EMAIL);
        }
      });
    } else {
      isLoading.value = false;

      Get.snackbar(
        'Login Gagal',
        responseData['message'] ?? 'Terjadi kesalahan saat login',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );

      if (responseData['message'].toString().contains('Password salah') ||
          responseData['message'].toString().contains('password') ||
          responseData['message'].toString().contains('credentials')) {
        if (!_isDisposed) {
          passwordController.clear();
          passwordError.value = true;
          passwordErrorText.value = 'Password salah. Silakan coba lagi.';
        }
      }

      if (responseData['message']
              .toString()
              .contains('Email tidak ditemukan') ||
          responseData['message'].toString().contains('email')) {
        if (!_isDisposed) {
          emailError.value = true;
          emailErrorText.value = 'Email tidak terdaftar.';
        }
      }
    }
  } catch (e) {
    _debugLog('Login error: $e');

    if (!_isDisposed) {
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
}
  Future<void> _getProfileDetail() async {
  try {
    _debugLog('Getting profile detail...');
    
    final token = storageService.getToken();
    if (token == null) {
      _debugLog('No token available for profile detail');
      return;
    }

    final response = await http.get(
      Uri.parse('${BaseUrl.baseUrl}/profile-detail'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    _debugLog('Profile detail response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      
      if (responseData['status'] == true && responseData['data'] != null) {
        final data = responseData['data'];
        final user = data['user'] ?? {};
        final detail = data['detail'] ?? {};

        _debugLog('Profile detail loaded successfully');

        // Save user dan detail ke storage
        await storageService.saveUserData(user, userDetail: detail);
        
        _debugLog('Profile detail saved to storage');
      }
    } else {
      _debugLog('Failed to get profile detail: ${response.statusCode}');
    }
  } catch (e) {
    _debugLog('Error getting profile detail: $e');
  }
}

  void goToRegister() {
    if (_isDisposed || !isReady.value) {
      _debugLog(
          'goToRegister blocked - Disposed: $_isDisposed, Ready: ${isReady.value}');
      return;
    }

    _debugLog('Navigating to register');
    _resetForm();
    Get.toNamed(Routes.REGISTER);
  }

  void forgotPassword() {
    if (_isDisposed || !isReady.value) {
      _debugLog(
          'forgotPassword blocked - Disposed: $_isDisposed, Ready: ${isReady.value}');
      return;
    }

    _debugLog('Forgot password requested');
    Get.snackbar(
      'Info',
      'Fitur lupa password belum tersedia',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
    );
  }

  void _clearFormBeforeNavigation() {
    if (_isDisposed) return;

    try {
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      _debugLog('Error clearing form before navigation: $e');
    }
  }

  void onEmailChanged(String value) {
    if (_isDisposed || !isReady.value) return;

    if (emailError.value) {
      emailError.value = false;
      emailErrorText.value = '';
    }
  }

  void onPasswordChanged(String value) {
    if (_isDisposed || !isReady.value) return;

    if (passwordError.value) {
      passwordError.value = false;
      passwordErrorText.value = '';
    }
  }

  void checkAutoLogin() {
    if (_isDisposed) return;

    if (storageService.isLoggedIn()) {
      _debugLog('Auto login detected');
      Get.offAllNamed(Routes.HOME);
    }
  }

  void logout() async {
    if (_isDisposed) return;

    try {
      _debugLog('Logging out user');
      await storageService.clearSession();
      _resetForm();

      Get.snackbar(
        'Info',
        'Anda telah logout',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.info,
        colorText: Colors.white,
      );
    } catch (e) {
      _debugLog('Error during logout: $e');
    }
  }

  void _debugLog(String message) {
    print('$_tag: $message');
  }

  @override
  void onClose() {
    _debugLog('onClose called');
    _isDisposed = true;

    try {
      emailController.dispose();
      passwordController.dispose();
    } catch (e) {
      _debugLog('Error disposing controllers: $e');
    }

    super.onClose();
  }
}
