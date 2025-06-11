import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/app_text.dart';

class AkunController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final isLoggingOut = false.obs;
  final isLoading = false.obs;

  final userData = <String, dynamic>{}.obs;

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

  final appVersion = "1.0.2 (2025)".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final token = _storageService.getToken();
      if (token == null) {
        Get.offAllNamed(Routes.LOGIN);
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

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          final user = data['user'] ?? {};
          final detail = data['detail'] ?? {};

          userData.value = {
            'id': user['id'],
            'name': user['name'] ?? '',
            'email': user['email'] ?? '',
            'role': user['role'] ?? '',
            'created_at': user['created_at'],
            'no_wa': detail['no_wa'] ?? '',
            'dusun': detail['dusun'] ?? '',
            'alamat_lengkap': detail['alamat_lengkap'] ?? '',
            'kode_pos': detail['kode_pos'] ?? '',
            'foto': detail['foto'] ?? '',
            'photo_url': detail['photo_url'] ?? '',
            'province_id': detail['province_id'],
            'regency_id': detail['regency_id'],
            'district_id': detail['district_id'],
            'village_id': detail['village_id'],
            'province': detail['province'],
            'regency': detail['regency'],
            'district': detail['district'],
            'village': detail['village'],
          };

          print('UserData loaded: ${userData.value}');
        }
      } else if (response.statusCode == 401) {
        await _storageService.clearSession();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        throw Exception('Gagal memuat data profil');
      }
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data profil: ${e.toString()}',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    userData.value = {};
    await loadUserData();
  }

  String get userName => userData['name'] ?? 'User';
  String get userEmail => userData['email'] ?? '';
  String get userPhone => userData['no_wa'] ?? '';
  String get userDusun => userData['dusun'] ?? '';
  String get userKodePos => userData['kode_pos'] ?? '';
  String get userPhotoUrl => userData['photo_url'] ?? '';

  bool get isUserDataEmpty => userData.isEmpty;
  bool get hasUserData => userData.isNotEmpty;

  void updateUserData(String key, dynamic value) {
    final currentData = Map<String, dynamic>.from(userData.value);
    currentData[key] = value;
    userData.value = currentData;
  }

  void updateMultipleUserData(Map<String, dynamic> updates) {
    final currentData = Map<String, dynamic>.from(userData.value);
    currentData.addAll(updates);
    userData.value = currentData;
  }

  void logout() {
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
              Text(
                'Logout',
                style: AppText.h5(color: AppColors.dark),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(1)),
              Text(
                'Apakah Anda yakin ingin keluar dari akun ini?',
                style: AppText.p(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(3)),
              Row(
                children: [
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

  Future<void> performLogout() async {
    try {
      isLoggingOut.value = true;
      await Future.delayed(Duration(milliseconds: 500));
      userData.value = {};

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

  void navigateToMenu(String route) {
    Get.toNamed(route);
  }

  bool get isUserLoggedIn => _storageService.isLoggedIn();
}
