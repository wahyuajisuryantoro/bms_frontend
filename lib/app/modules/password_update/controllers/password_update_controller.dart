import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordUpdateController extends GetxController {
  // Form key untuk validasi
  final formKey = GlobalKey<FormState>();

  // Storage service
  final StorageService _storageService = Get.find<StorageService>();

  // Controller untuk field password
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  // Visibility toggle untuk password
  final oldPasswordVisible = false.obs;
  final newPasswordVisible = false.obs;
  final confirmPasswordVisible = false.obs;

  // Loading state
  final isLoading = false.obs;

  // Error message
  final errorMessage = ''.obs;

  // Reactive values untuk kekuatan password
  final passwordText = ''.obs;
  final passwordStrength = 0.0.obs;
  final passwordStrengthLabel = 'Lemah'.obs;
  final passwordStrengthColor = AppColors.danger.obs;

  // Reactive values untuk kriteria password
  final hasMinLengthValue = false.obs;
  final hasUpperAndLowerCaseValue = false.obs;
  final hasDigitsValue = false.obs;
  final hasSpecialCharsValue = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Inisialisasi controller
    oldPasswordController = TextEditingController(text: '');
    newPasswordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');

    // Listen untuk perubahan di newPasswordController secara real-time
    newPasswordController.addListener(() {
      final password = newPasswordController.text;
      passwordText.value = password;

      // Update kriteria password secara reaktif
      hasMinLengthValue.value = hasMinLength(password);
      hasUpperAndLowerCaseValue.value = hasUpperAndLowerCase(password);
      hasDigitsValue.value = hasDigits(password);
      hasSpecialCharsValue.value = hasSpecialChars(password);

      // Update kekuatan password
      _updatePasswordStrength();
    });
  }

  @override
  void onClose() {
    // Remove listener
    newPasswordController.removeListener(() {});

    // Dispose controller
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Update kekuatan password saat password berubah
  void _updatePasswordStrength() {
    final password = passwordText.value;

    // Hitung kekuatan password
    final strength = getPasswordStrength(password);
    passwordStrength.value = strength;

    // Update label dan warna
    passwordStrengthLabel.value = _getStrengthLabel(strength);
    passwordStrengthColor.value = _getStrengthColor(strength);
  }

  // Toggle visibility password
  void toggleOldPasswordVisibility() {
    oldPasswordVisible.value = !oldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  // Validasi password lama
  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password lama tidak boleh kosong';
    }

    // Minimal 6 karakter
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  // Validasi password baru
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password baru tidak boleh kosong';
    }

    // Minimal 8 karakter
    if (value.length < 8) {
      return 'Password baru minimal 8 karakter';
    }

    // Harus berbeda dengan password lama
    if (value == oldPasswordController.text) {
      return 'Password baru tidak boleh sama dengan password lama';
    }

    // Harus mengandung huruf besar, huruf kecil, dan angka
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));

    if (!hasUppercase || !hasLowercase || !hasDigits) {
      return 'Password harus mengandung huruf besar, huruf kecil, dan angka';
    }

    return null;
  }

  // Validasi konfirmasi password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    // Harus sama dengan password baru
    if (value != newPasswordController.text) {
      return 'Konfirmasi password tidak cocok dengan password baru';
    }

    return null;
  }

  // Update password - Integrate with Laravel API
  Future<void> updatePassword() async {
    // Reset error message
    errorMessage.value = '';

    // Validate form
    if (formKey.currentState!.validate()) {
      try {
        // Set loading state
        isLoading.value = true;

        // Get token from storage
        final token = _storageService.getToken();
        if (token == null) {
          throw Exception('Token tidak ditemukan. Silakan login kembali.');
        }

        // Prepare request body
        final Map<String, dynamic> requestBody = {
          'current_password': oldPasswordController.text,
          'new_password': newPasswordController.text,
          'new_password_confirmation': confirmPasswordController.text,
        };

        // Make API request
        final response = await http.put(
          Uri.parse('${BaseUrl.baseUrl}/update-password'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(requestBody),
        );

        // Parse response
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          // Success
          Get.snackbar(
            'Berhasil',
            responseData['message'] ?? 'Password berhasil diperbarui',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            margin: EdgeInsets.all(20),
            duration: Duration(seconds: 3),
            icon: Icon(
              Remix.check_double_line,
              color: Colors.white,
            ),
          );

          // Clear form
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();

          // Reset password strength dan kriteria
          passwordText.value = '';
          passwordStrength.value = 0.0;
          passwordStrengthLabel.value = 'Lemah';
          passwordStrengthColor.value = AppColors.danger;
          hasMinLengthValue.value = false;
          hasUpperAndLowerCaseValue.value = false;
          hasDigitsValue.value = false;
          hasSpecialCharsValue.value = false;

          // Navigate back after a delay
          Future.delayed(Duration(seconds: 2), () {
            Get.back();
          });
        } else if (response.statusCode == 400) {
          // Bad request - wrong password or same password
          errorMessage.value =
              responseData['message'] ?? 'Password lama tidak sesuai';
        } else if (response.statusCode == 422) {
          // Validation errors
          if (responseData['errors'] != null) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final errorMessages = <String>[];

            errors.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                errorMessages.add(value.first.toString());
              }
            });

            errorMessage.value = errorMessages.isNotEmpty
                ? errorMessages.first
                : responseData['message'] ?? 'Validasi gagal';
          } else {
            errorMessage.value = responseData['message'] ?? 'Validasi gagal';
          }
        } else if (response.statusCode == 401) {
          // Unauthorized - token expired
          errorMessage.value = 'Sesi telah berakhir. Silakan login kembali.';

          // Clear session and redirect to login
          await _storageService.clearSession();
          Get.offAllNamed('/login');
        } else {
          // Other errors
          errorMessage.value =
              responseData['message'] ?? 'Terjadi kesalahan pada server';
        }
      } catch (e) {
        // Error handling
        print('Error updating password: $e');

        if (e.toString().contains('SocketException')) {
          errorMessage.value =
              'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage.value = 'Request timeout. Silakan coba lagi.';
        } else {
          errorMessage.value = e.toString().replaceAll('Exception: ', '');
        }

        // Error snackbar
        Get.snackbar(
          'Gagal',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
          margin: EdgeInsets.all(20),
          duration: Duration(seconds: 3),
          icon: Icon(
            Remix.error_warning_line,
            color: Colors.white,
          ),
        );
      } finally {
        // Reset loading state
        isLoading.value = false;
      }
    }
  }

  // Fungsi untuk membatalkan dan kembali
  void cancel() {
    Get.back();
  }

  // Mendapatkan kekuatan password
  double getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Kriteria untuk kekuatan password - menggunakan nilai reactive
    if (hasMinLengthValue.value) strength += 0.25;
    if (hasUpperAndLowerCaseValue.value) strength += 0.25;
    if (hasDigitsValue.value) strength += 0.25;
    if (hasSpecialCharsValue.value) strength += 0.25;

    return strength;
  }

  // Helper untuk mendapatkan warna indikator kekuatan password
  Color _getStrengthColor(double strength) {
    if (strength <= 0.25) return AppColors.danger;
    if (strength <= 0.5) return AppColors.warning;
    if (strength <= 0.75) return AppColors.info;
    return AppColors.success;
  }

  // Helper untuk mendapatkan label kekuatan password
  String _getStrengthLabel(double strength) {
    if (strength <= 0.25) return 'Lemah';
    if (strength <= 0.5) return 'Sedang';
    if (strength <= 0.75) return 'Kuat';
    return 'Sangat Kuat';
  }

  // Method public untuk akses dari view
  Color getPasswordStrengthColor(double strength) {
    return _getStrengthColor(strength);
  }

  String getPasswordStrengthLabel(double strength) {
    return _getStrengthLabel(strength);
  }

  // Cek validasi kriteria password
  bool hasMinLength(String password) {
    return password.length >= 8;
  }

  bool hasUpperAndLowerCase(String password) {
    return password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]'));
  }

  bool hasDigits(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  bool hasSpecialChars(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}
