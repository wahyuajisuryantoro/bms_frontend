import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();

  final favoriteCars = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    getAllDataFavorite();
  }

  Future<void> getAllDataFavorite() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final token = storageService.getToken();

      if (token == null) {
        isError.value = true;
        errorMessage.value = 'Token tidak tersedia';
        return;
      }

      final String endpoint = '${BaseUrl.baseUrl}/favorites/all';

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> dataList = responseData['data'];
          favoriteCars.assignAll(
              dataList.map((item) => Map<String, dynamic>.from(item)).toList());
        } else {
          isError.value = true;
          errorMessage.value =
              responseData['message'] ?? 'Gagal mengambil data favorit';
        }
      } else if (response.statusCode == 401) {
        isError.value = true;
        errorMessage.value = 'Sesi telah berakhir, silakan login kembali';
      } else {
        isError.value = true;
        errorMessage.value = 'Terjadi kesalahan server';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
      print('Error getAllDataFavorite: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(Map<String, dynamic> favoriteData) async {
    try {
      final token = storageService.getToken();

      if (token == null) {
        Get.snackbar('Error', 'Token tidak tersedia');
        return;
      }

      final favoriteId = favoriteData['favorite_id'];
      final String endpoint = '${BaseUrl.baseUrl}/favorites/remove/$favoriteId';

      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          favoriteCars.removeWhere((car) => car['favorite_id'] == favoriteId);

          Get.snackbar(
            'Berhasil',
            'Favorit berhasil dihapus',
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
              'Error', responseData['message'] ?? 'Gagal menghapus favorit');
        }
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan server');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      print('Error removeFavorite: $e');
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      final token = storageService.getToken();

      if (token == null) {
        Get.snackbar('Error', 'Token tidak tersedia');
        return;
      }

      final String endpoint = '${BaseUrl.baseUrl}/favorites/clear';

      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          favoriteCars.clear();

          Get.snackbar(
            'Berhasil',
            'Semua favorit berhasil dihapus',
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar('Error',
              responseData['message'] ?? 'Gagal menghapus semua favorit');
        }
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan server');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      print('Error clearAllFavorites: $e');
    }
  }

  Future<void> refreshFavorites() async {
    await getAllDataFavorite();
  }

  int get favoriteCount => favoriteCars.length;

  bool isCarFavorite(int mobilId) {
    return favoriteCars.any((car) => car['mobil_id'] == mobilId);
  }

  void addToLocalFavorites(Map<String, dynamic> favoriteData) {
    final existingIndex = favoriteCars
        .indexWhere((car) => car['mobil_id'] == favoriteData['mobil_id']);

    if (existingIndex == -1) {
      favoriteCars.insert(0, favoriteData);
    } else {
      favoriteCars[existingIndex] = favoriteData;
    }

    print('Added to local favorites. Total: ${favoriteCount}');
  }

  void removeFromLocalFavorites(int mobilId) {
    final removedCount = favoriteCars.length;
    favoriteCars.removeWhere((car) => car['mobil_id'] == mobilId);

    final newCount = favoriteCars.length;
    if (removedCount != newCount) {
      print('Removed from local favorites. Total: ${favoriteCount}');
    }
  }

  Future<void> refreshBadgeCount() async {
    try {
      final token = storageService.getToken();
      if (token == null) return;

      final String endpoint = '${BaseUrl.baseUrl}/favorites/all';

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> dataList = responseData['data'];
          final currentCount = favoriteCars.length;
          final apiCount = dataList.length;

          if (currentCount != apiCount) {
            print(
                'Badge count mismatch. Local: $currentCount, API: $apiCount. Syncing...');
            favoriteCars.assignAll(dataList
                .map((item) => Map<String, dynamic>.from(item))
                .toList());
          }
        }
      }
    } catch (e) {
      print('Error refreshBadgeCount: $e');
    }
  }
}
