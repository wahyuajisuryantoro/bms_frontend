import 'dart:convert';
import 'dart:async';

import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SuksesVerifikasiEmailController extends GetxController {
  final storageService = Get.find<StorageService>();

  final RxBool isLoading = false.obs;
  final RxString email = ''.obs;
  final RxBool pollingActive = true.obs;
  
  // PENTING: Timer reference untuk proper cleanup
  Timer? _pollingTimer;
  bool _isNavigating = false; // Flag untuk prevent double navigation

  @override
  void onInit() {
    super.onInit();
    print('SuksesVerifikasiEmailController: onInit called');

    String? storedEmail = storageService.getStoredEmail();
    print('SuksesVerifikasiEmailController: Stored email: ${storedEmail ?? 'null'}');
    
    if (storedEmail != null && storedEmail.isNotEmpty) {
      email.value = storedEmail;
      
      // Delay start polling untuk memastikan UI ready
      Future.delayed(const Duration(milliseconds: 500), () {
        if (pollingActive.value && !_isNavigating) {
          startPolling();
        }
      });
    } else {
      print('SuksesVerifikasiEmailController: No email found, redirecting to login');
      _safeNavigateToLogin();
    }
  }

  void startPolling() {
    if (!pollingActive.value || _isNavigating) return;
    print('SuksesVerifikasiEmailController: Starting polling');
    checkEmailVerificationStatus();
  }

  void checkEmailVerificationStatus() async {
    if (email.value.isEmpty || !pollingActive.value || _isNavigating) return;

    print('SuksesVerifikasiEmailController: Checking verification status');

    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/email/check-registration'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.value,
        }),
      );

      // Double check jika sudah navigating
      if (!pollingActive.value || _isNavigating) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('SuksesVerifikasiEmailController: Response: $responseData');

        if (responseData['status'] == true &&
            responseData['registered'] == true &&
            responseData['verified'] == true) {
          
          print('SuksesVerifikasiEmailController: Email verified, navigating to login');
          _stopPollingAndNavigate(() => _safeNavigateToLogin());
          
          Get.snackbar(
            'Berhasil',
            'Email Anda telah diverifikasi, silakan login',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return;
        }

        if (responseData['status'] == true &&
            responseData['registered'] == false &&
            responseData['pending'] == false) {
          
          print('SuksesVerifikasiEmailController: Registration expired, navigating to register');
          _stopPollingAndNavigate(() => _safeNavigateToRegister());
          
          Get.snackbar(
            'Perhatian',
            'Pendaftaran Anda mungkin telah kedaluwarsa. Silakan daftar ulang.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
      }
    } catch (e) {
      print('SuksesVerifikasiEmailController: Error checking verification: $e');
    }

    // Schedule next check jika masih aktif
    if (pollingActive.value && !_isNavigating) {
      _pollingTimer = Timer(const Duration(seconds: 10), () {
        if (pollingActive.value && !_isNavigating) {
          checkEmailVerificationStatus();
        }
      });
    }
  }

  void _stopPollingAndNavigate(VoidCallback navigationCallback) {
    _isNavigating = true;
    pollingActive.value = false;
    _cancelTimer();
    
    // Delay sedikit untuk memastikan snackbar muncul
    Future.delayed(const Duration(seconds: 2), () {
      navigationCallback();
    });
  }

  void _safeNavigateToLogin() {
    if (_isNavigating) return;
    
    print('SuksesVerifikasiEmailController: Safe navigate to login');
    _isNavigating = true;
    _cancelTimer();
    storageService.clearStoredEmail();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.offAllNamed(Routes.LOGIN);
    });
  }

  void _safeNavigateToRegister() {
    if (_isNavigating) return;
    
    print('SuksesVerifikasiEmailController: Safe navigate to register');
    _isNavigating = true;
    _cancelTimer();
    storageService.clearStoredEmail();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.offAllNamed(Routes.REGISTER);
    });
  }

  void _cancelTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    print('SuksesVerifikasiEmailController: Timer cancelled');
  }

  // Public methods untuk UI
  void goToLogin() => _safeNavigateToLogin();
  void goToRegister() => _safeNavigateToRegister();

  void resendVerification() async {
    if (email.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak ditemukan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/email/resend'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.value,
        }),
      );

      isLoading.value = false;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        Get.snackbar(
          'Berhasil',
          'Link verifikasi telah dikirim ulang ke email Anda.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Handle errors...
        Get.snackbar(
          'Gagal',
          responseData['message'] ?? 'Gagal mengirim ulang link verifikasi.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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

  @override
  void onClose() {
    print('SuksesVerifikasiEmailController: onClose called');
    _isNavigating = true;
    pollingActive.value = false;
    _cancelTimer();
    super.onClose();
  }
}