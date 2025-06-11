import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final storageService = Get.find<StorageService>();

  // User info
  final RxString userName = ''.obs;
  final brands = <Map<String, dynamic>>[].obs;
  final transmissions = <Map<String, dynamic>>[].obs;
  final carListings = <Map<String, dynamic>>[].obs;

  final isLoadingBrands = false.obs;
  final isLoadingTransmissions = false.obs;
  final isLoadingCars = false.obs;
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  final filteredCarListings = <Map<String, dynamic>>[].obs;

  final selectedBrandId = RxnInt();
  final isExpandedBrands = false.obs;
  final maxBrandsToShow = 4;

  final selectedTransmissionId = RxnInt();

  DateTime? lastBackPressTime;
  final RxBool isInitialLoad = true.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
    isInitialLoad.value = false;
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await storageService.forceRefreshCarData();
      isRefreshing.value = true;
    }

    // Load brands
    await _loadBrandsWithCache(forceRefresh: forceRefresh);
    
    // Load transmissions
    await _loadTransmissionsWithCache(forceRefresh: forceRefresh);
    
    // Load car listings
    await _loadCarListingsWithCache(forceRefresh: forceRefresh);

    isRefreshing.value = false;
  }

  Future<void> _loadBrandsWithCache({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedBrands = storageService.getCachedBrands();
      if (cachedBrands != null) {
        brands.value = cachedBrands;
        return;
      }
    }
    await fetchMerkMobil();
  }

  Future<void> _loadTransmissionsWithCache({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedTransmissions = storageService.getCachedTransmissions();
      if (cachedTransmissions != null) {
        transmissions.value = cachedTransmissions;
        return;
      }
    }

    await fetchTransmisi();
  }
  Future<void> _loadCarListingsWithCache({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedCarListings = storageService.getCachedCarListings();
      if (cachedCarListings != null) {
        carListings.value = cachedCarListings;
        return;
      }
    }

    await fetchMobilDashboard();
  }
  Future<void> refreshData() async {
    await loadData(forceRefresh: true);
    
    Get.snackbar(
      'Berhasil',
      'Data telah diperbarui',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }
  void getUserData() {
    try {
      String? name = storageService.getName();

      if (name != null && name.isNotEmpty) {
        userName.value = name;
      } else {
        var userData = storageService.getUserData();
        if (userData != null && userData.containsKey('name')) {
          userName.value = userData['name'] as String;
        } else {
          userName.value = 'Pengguna';
        }
      }
    } catch (e) {
      userName.value = 'Pengguna';
    }
  }

  Future<void> fetchMerkMobil() async {
    try {
      isLoadingBrands.value = true;
      String? token = storageService.getToken();
      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/merk-mobil'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true &&
            responseData.containsKey('data')) {
          brands.clear();
          List<dynamic> merkList = responseData['data'];

          final brandsList = merkList.map((merk) {
            return {
              'name': merk['nama_merk'],
              'image': merk['foto_merk'] ?? 'assets/images/car_placeholder.png',
              'id': merk['id']
            };
          }).toList();

          brands.value = brandsList;
          
          // Simpan ke cache
          await storageService.saveBrands(brandsList);
        }
      }
    } catch (e) {
      print('Error fetching brands: $e');
    } finally {
      isLoadingBrands.value = false;
    }
  }

  Future<void> fetchTransmisi() async {
    try {
      isLoadingTransmissions.value = true;
      String? token = storageService.getToken();
      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/transmisi'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          transmissions.clear();
          List<dynamic> list = responseData['data'];
          bool isFirst = true;

          final transmissionsList = list.map((item) {
            bool selected = isFirst;
            if (isFirst) isFirst = false;

            return {
              'name': item['jenis_transmisi'],
              'id': item['id'],
              'isSelected': selected
            };
          }).toList();

          transmissions.value = transmissionsList;
          
          // Simpan ke cache
          await storageService.saveTransmissions(transmissionsList);
        }
      }
    } catch (e) {
      print('Error fetching transmissions: $e');
    } finally {
      isLoadingTransmissions.value = false;
    }
  }

  Future<void> fetchMobilDashboard() async {
    try {
      isLoadingCars.value = true;
      String? token = storageService.getToken();
      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/mobil-dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          carListings.clear();
          List<Map<String, dynamic>> processedCars = [];
          for (var car in responseData['data']) {
            Map<String, dynamic> carMap = Map<String, dynamic>.from(car);
            if (!carMap.containsKey('merk_id') || carMap['merk_id'] == null) {
              String merkName = carMap['merk'] ?? '';
              for (var brand in brands) {
                if (brand['name'] == merkName) {
                  carMap['merk_id'] = brand['id'];
                  break;
                }
              }
            }
            if (!carMap.containsKey('transmisi_id') ||
                carMap['transmisi_id'] == null) {
              String transmisiName = carMap['transmisi'] ?? '';
              for (var transmission in transmissions) {
                if (transmission['name'] == transmisiName) {
                  carMap['transmisi_id'] = transmission['id'];
                  break;
                }
              }
            }

            processedCars.add(carMap);
          }
          carListings.value = processedCars;
          await storageService.saveCarListings(processedCars);
          print('Processed Car Listings: ${carListings.length}');
          if (carListings.isNotEmpty) {
            print('Sample car: ${carListings[0]}');
          }
        }
      }
    } catch (e) {
      print('Error fetching mobil: $e');
    } finally {
      isLoadingCars.value = false;
    }
  }

  bool shouldAutoRefresh() {
    return !storageService.isCarListingsCacheValid() ||
           !storageService.isBrandsCacheValid() ||
           !storageService.isTransmissionsCacheValid();
  }

  // Method yang dipanggil ketika user kembali ke halaman home
  void onHomePageResumed() {
    if (shouldAutoRefresh()) {
      print('Cache expired, refreshing data...');
      loadData(forceRefresh: true);
    }
  }

  // Method untuk logout
  void logout() async {
    try {
      await storageService.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  String getBrandNameById(int brandId) {
    final brand = brands.firstWhere(
      (b) => b['id'] == brandId,
      orElse: () => {'name': 'Unknown'},
    );
    return brand['name'] as String;
  }

  String getTransmissionNameById(int transmissionId) {
    final transmission = transmissions.firstWhere(
      (t) => t['id'] == transmissionId,
      orElse: () => {'name': 'Unknown'},
    );
    return transmission['name'] as String;
  }

  void handleDoubleBackToExit() {
    final now = DateTime.now();

    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
      lastBackPressTime = now;
      Get.snackbar(
        'Info',
        'Tekan sekali lagi untuk keluar',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } else {
      exitApp();
    }
  }

  void exitApp() async {
    final userData = storageService.getUserData();
    final token = storageService.getToken();
    if (userData != null && token != null) {
      await storageService.saveSession(userData: userData, token: token);
    }
    await SystemChannels.platform
        .invokeMethod('SystemNavigator.pop', {'animated': true});
  }
}