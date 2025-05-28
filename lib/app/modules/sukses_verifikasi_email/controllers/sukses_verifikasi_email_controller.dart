import 'dart:convert';

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

  @override
  void onInit() {
    super.onInit();
    // Ambil email tersimpan dari storage
    String? storedEmail = storageService.getStoredEmail();
    if (storedEmail != null && storedEmail.isNotEmpty) {
      email.value = storedEmail;
      
      // Mulai polling untuk mengecek status verifikasi
      startPolling();
    } else {
      // Jika tidak ada email yang tersimpan, redirect ke halaman login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
  
  void startPolling() {
    // Cek status verifikasi secara berkala
    checkEmailVerificationStatus();
  }

  void checkEmailVerificationStatus() async {
    // Jika email kosong atau polling tidak aktif, tidak perlu melakukan pengecekan
    if (email.value.isEmpty || !pollingActive.value) return;
    
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
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Jika email sudah diverifikasi dan terdaftar, arahkan ke halaman login
        if (responseData['status'] == true && 
            responseData['registered'] == true &&
            responseData['verified'] == true) {
            
          // Hentikan polling
          pollingActive.value = false;
          
          Get.snackbar(
            'Berhasil',
            'Email Anda telah diverifikasi, silakan login',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          
          // Tunggu 2 detik sebelum pindah halaman
          await Future.delayed(const Duration(seconds: 2));
          goToLogin();
          return;
        }
        
        // Jika tidak ada lagi pendaftaran yang tertunda (mungkin expired)
        if (responseData['status'] == true && 
            responseData['registered'] == false &&
            responseData['pending'] == false) {
            
          Get.snackbar(
            'Perhatian',
            'Pendaftaran Anda mungkin telah kedaluwarsa. Silakan daftar ulang.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          
          // Tunggu 2 detik sebelum pindah halaman
          await Future.delayed(const Duration(seconds: 2));
          goToRegister();
          return;
        }
      }
    } catch (e) {
      // Tangani error dengan tenang, tidak perlu menampilkan kepada pengguna
      print('Error saat memeriksa status verifikasi: $e');
    }
    
    // Cek status kembali setiap 10 detik
    Future.delayed(const Duration(seconds: 10), () {
      if (pollingActive.value) {
        checkEmailVerificationStatus();
      }
    });
  }

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
        // Jika respons menunjukkan pendaftaran perlu diulang
        if (response.statusCode == 404 && responseData['message'].contains('daftar ulang')) {
          Get.dialog(
            AlertDialog(
              title: Text('Pendaftaran Kedaluwarsa'),
              content: Text('Link verifikasi telah kedaluwarsa. Apakah Anda ingin mendaftar ulang?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Tidak'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    goToRegister();
                  },
                  child: Text('Ya'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar(
            'Gagal',
            responseData['message'] ?? 'Gagal mengirim ulang link verifikasi.',
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

  void goToLogin() {
    // Hentikan polling sebelum pindah halaman
    pollingActive.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }
  
  void goToRegister() {
    // Hentikan polling sebelum pindah halaman
    pollingActive.value = false;
    Get.offAllNamed(Routes.REGISTER);
  }
  
  @override
  void onClose() {
    // Hentikan polling saat keluar dari halaman
    pollingActive.value = false;
    super.onClose();
  }
}