import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/app_text.dart';

class AkunController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Loading state untuk logout
  final isLoggingOut = false.obs;

  // Data pengguna yang akan dimuat dari storage
  final userData = <String, dynamic>{}.obs;

  // Daftar menu profil
  final profileMenus = [
    {
      'title': 'Detail Akun',
      'icon': 'user_3_line',
      'route': Routes.AKUN_DETAIL,
      'subtitle': 'Lihat dan edit profil Anda'
    },
    {
      'title': 'Update Password',
      'icon': 'lock_password_line',
      'route': Routes.PASSWORD_UPDATE,
      'subtitle': 'Ubah kata sandi Anda'
    },
    {
      'title': 'Favorit',
      'icon': 'heart_3_line',
      'route': Routes.FAVORIT,
      'subtitle': 'Mobil favorit Anda'
    },
    {
      'title': 'Informasi Seller & Admin',
      'icon': 'customer_service_2_line',
      'route': Routes.INFORMASI,
      'subtitle': 'Hubungi kami untuk bantuan'
    },
    {
      'title': 'Tentang BMS',
      'icon': 'information_line',
      'route': Routes.TENTANG,
      'subtitle': 'Informasi tentang perusahaan'
    },
    {
      'title': 'Kebijakan & Privasi',
      'icon': 'shield_check_line',
      'route': Routes.KEBIJAKAN_DAN_PRIVASI,
      'subtitle': 'Ketentuan penggunaan aplikasi'
    },
  ].obs;

  // Versi aplikasi
  final appVersion = "1.0.2 (2025)".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Load data user dari storage
  void loadUserData() {
    final user = _storageService.getUserData();
    if (user != null) {
      userData.value = user;
    } else {
      // Jika tidak ada data user, redirect ke login
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Refresh user data
  void refreshUserData() {
    loadUserData();
  }

  // Fungsi logout dengan dialog custom yang lebih menarik
  void logout() {
    // Tampilkan dialog konfirmasi logout
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: AppResponsive.padding(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon peringatan
              Container(
                padding: AppResponsive.padding(all: 3),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Remix.logout_circle_r_line,
                  color: AppColors.danger,
                  size: AppResponsive.getResponsiveSize(40),
                ),
              ),
              SizedBox(height: AppResponsive.h(2)),

              // Judul dialog
              Text(
                'Logout',
                style: AppText.h5(color: AppColors.dark),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(1)),

              // Konten dialog
              Text(
                'Apakah Anda yakin ingin keluar dari akun ini?',
                style: AppText.p(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(3)),

              // Tombol aksi
              Row(
                children: [
                  // Tombol Batal
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(
                          AppResponsive.getResponsiveSize(12)),
                      child: Container(
                        padding: AppResponsive.padding(vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(12)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Batal',
                          style: AppText.button(color: AppColors.dark),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.w(3)),

                  // Tombol Logout
                  Expanded(
                    child: InkWell(
                      onTap: () => performLogout(),
                      borderRadius: BorderRadius.circular(
                          AppResponsive.getResponsiveSize(12)),
                      child: Container(
                        padding: AppResponsive.padding(vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(12)),
                        ),
                        alignment: Alignment.center,
                        child: Obx(
                          () => isLoggingOut.value
                              ? SizedBox(
                                  width: AppResponsive.getResponsiveSize(20),
                                  height: AppResponsive.getResponsiveSize(20),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Logout',
                                  style: AppText.button(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Fungsi untuk melakukan proses logout
  Future<void> performLogout() async {
    try {
      isLoggingOut.value = true;

      // Simulasi delay untuk UX yang lebih baik
      await Future.delayed(Duration(milliseconds: 500));

      // Hapus semua data dari storage
      await _storageService.logout();

      // Tutup dialog
      Get.back();

      // Tampilkan snackbar sukses
      Get.snackbar(
        'Logout Berhasil',
        'Anda telah berhasil keluar dari akun',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.black,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 2),
        icon: Icon(
          Remix.check_double_line,
          color: Colors.black,
        ),
      );

      // Navigasi ke halaman login dan hapus semua rute sebelumnya
      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      isLoggingOut.value = false;

      // Tampilkan error snackbar
      Get.snackbar(
        'Error',
        'Gagal melakukan logout. Silakan coba lagi.',
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
    }
  }

  // Fungsi untuk logout paksa (tanpa dialog konfirmasi)
  Future<void> forceLogout({String? reason}) async {
    try {
      // Hapus semua data dari storage
      await _storageService.logout();

      // Tampilkan snackbar dengan alasan logout
      Get.snackbar(
        'Logout',
        reason ?? 'Sesi Anda telah berakhir',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
        colorText: Colors.black,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 3),
        icon: Icon(
          Remix.information_line,
          color: Colors.black,
        ),
      );

      // Navigasi ke halaman login
      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      print('Error during force logout: $error');
      // Tetap redirect ke login meskipun ada error
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Fungsi untuk logout dengan API call (jika diperlukan)
  Future<void> logoutWithApi() async {
    try {
      isLoggingOut.value = true;

      // TODO: Implementasi API call untuk logout
      // final response = await ApiService.logout();

      // Hapus data dari storage setelah API berhasil
      await _storageService.logout();

      Get.back();

      Get.snackbar(
        'Logout Berhasil',
        'Anda telah berhasil keluar dari akun',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.black,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 2),
        icon: Icon(
          Remix.check_double_line,
          color: Colors.black,
        ),
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      isLoggingOut.value = false;

      Get.snackbar(
        'Error',
        'Gagal melakukan logout. Silakan coba lagi.',
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
    }
  }

  // Navigasi ke menu yang dipilih
  void navigateToMenu(String route) {
    Get.toNamed(route);
  }

  // Check apakah user masih login
  bool get isUserLoggedIn => _storageService.isLoggedIn();

  // Get user name untuk display
  String get userName => userData.value['name'] ?? 'User';

  // Get user email untuk display
  String get userEmail => userData.value['email'] ?? '';

  // Get user phone untuk display
  String get userPhone => userData.value['phone'] ?? '';
}
