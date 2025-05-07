import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/app_text.dart';

class AkunController extends GetxController {
  // Data dummy untuk profil pengguna
  final userData = {
    'name': 'Clarisa Anastasia Wijaya',
    'email': 'clarisa.w@gmail.com',
    'phone': '+62 812 3456 7890',
    'profileImage': 'assets/images/profile.jpg',
    'memberSince': 'Mei 2022',
    'lastLogin': 'Hari ini, 08:45 WIB',
    'totalFavorites': 12,
    'totalTransactions': 5,
  }.obs;
  
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
  
  // Fungsi untuk logout
  // Fungsi logout dengan dialog custom yang lebih menarik
void logout() {
  // Tampilkan dialog konfirmasi logout
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: AppResponsive.padding(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
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
                    borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
                    child: Container(
                      padding: AppResponsive.padding(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
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
                    onTap: () {
                      // Proses logout
                      Get.back();
                      Get.snackbar(
                        'Logout',
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
                      
                      // Navigasi ke halaman login (untuk demo)
                      // Get.offAllNamed('/login');
                    },
                    borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
                    child: Container(
                      padding: AppResponsive.padding(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Logout',
                        style: AppText.button(color: Colors.white),
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
  
  // Navigasi ke menu yang dipilih
  void navigateToMenu(String route) {
    Get.toNamed(route);
  }
}