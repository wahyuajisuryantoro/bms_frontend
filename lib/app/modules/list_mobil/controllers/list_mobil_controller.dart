import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ListMobilController extends GetxController {
  final storageService = Get.find<StorageService>();

  final RxBool isSearchFocused = false.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList carListings = [].obs;
  final RxList filteredCarListings = [].obs;

  final RxList brands = [].obs;
  final RxList transmisions = [].obs;
  final RxList tipeBodis = [].obs;
  final RxList warnas = [].obs;
  final RxList bahanBakars = [].obs;
  final RxList years = [].obs;
  final RxList kapasitasMesins = [].obs;
  final RxList metodePembayarans = [].obs;

  final Rx<Map<String, dynamic>> activeFilters = Rx<Map<String, dynamic>>({});
  final RxString searchQuery = ''.obs;

  // Flag untuk track apakah ini adalah fresh load
  final RxBool isInitialLoad = true.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['filter'] != null) {
      activeFilters.value = Map<String, dynamic>.from(Get.arguments['filter']);
    }
    loadData();
    checkAndOpenSearch();

    ever(searchQuery, (_) {
      applyAllFilters();
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Set flag bahwa initial load sudah selesai
    isInitialLoad.value = false;
  }

  // Method utama untuk load data dengan smart caching
  Future<void> loadData({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await storageService.forceRefreshListMobil();
      isRefreshing.value = true;
    }

    // Coba ambil dari cache dulu jika tidak force refresh
    if (!forceRefresh) {
      final cachedData = storageService.getCachedListMobilData();
      if (cachedData != null) {
        _loadFromCache(cachedData);
        isRefreshing.value = false;
        return; // Gunakan data cache, tidak perlu fetch
      }
    }

    // Jika cache tidak ada atau expired, fetch dari API
    await fetchMobil();
    isRefreshing.value = false;
  }

  // Load data dari cache
  void _loadFromCache(Map<String, dynamic> cachedData) {
    try {
      // Load car listings
      carListings.value = cachedData['carListings'] ?? [];
      
      // Load filter options
      final filterOptions = cachedData['filterOptions'] ?? {};
      brands.value = filterOptions['brands'] ?? [];
      transmisions.value = filterOptions['transmisi'] ?? [];
      tipeBodis.value = filterOptions['tipe_bodi'] ?? [];
      warnas.value = filterOptions['warna'] ?? [];
      bahanBakars.value = filterOptions['bahan_bakar'] ?? [];
      years.value = filterOptions['tahun_keluaran'] ?? [];
      kapasitasMesins.value = filterOptions['kapasitas_mesin'] ?? [];
      metodePembayarans.value = filterOptions['metode_pembayaran'] ?? [];

      // Set loading ke false
      isLoading.value = false;
      isError.value = false;

      // Apply filters
      applyAllFilters();
      
      print('Data loaded from cache - Cars: ${carListings.length}');
    } catch (e) {
      print('Error loading from cache: $e');
      // Jika error, fetch dari API
      fetchMobil();
    }
  }

  // Method untuk refresh manual
  Future<void> refreshData() async {
    await loadData(forceRefresh: true);
    
    Get.snackbar(
      'Berhasil',
      'Data mobil telah diperbarui',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }

  void checkAndOpenSearch() {
    if (Get.arguments != null && Get.arguments['openSearch'] == true) {
      Future.delayed(Duration(milliseconds: 300), () {
        isSearchFocused.value = true;
        searchFocusNode.requestFocus();
      });
    }
  }

  Future<void> fetchMobil() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final token = storageService.getToken();

      final String endpoint = '${BaseUrl.baseUrl}/mobil-all';

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          carListings.value = responseData['data'];

          applyAllFilters();

          // Process filter options
          Map<String, dynamic> filterOptions = {};
          if (responseData.containsKey('filter_options')) {
            filterOptions = responseData['filter_options'];
            brands.value = filterOptions['brands'] ?? [];
            transmisions.value = filterOptions['transmisi'] ?? [];
            tipeBodis.value = filterOptions['tipe_bodi'] ?? [];
            warnas.value = filterOptions['warna'] ?? [];
            bahanBakars.value = filterOptions['bahan_bakar'] ?? [];
            years.value = filterOptions['tahun_keluaran'] ?? [];
            kapasitasMesins.value = filterOptions['kapasitas_mesin'] ?? [];
            metodePembayarans.value = filterOptions['metode_pembayaran'] ?? [];
          }
          await storageService.saveListMobilData(
            carListings: responseData['data'],
            filterOptions: filterOptions,
          );

          print('Data fetched and cached - Cars: ${carListings.length}');
        } else {
          isError.value = true;
          errorMessage.value =
              responseData['message'] ?? 'Gagal memuat data mobil';
        }
      } else if (response.statusCode == 401) {
        isError.value = true;
        errorMessage.value = 'Anda perlu login untuk mengakses data ini';
      } else {
        isError.value = true;
        errorMessage.value = 'Terjadi kesalahan: ${response.statusCode}';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  bool shouldAutoRefresh() {
    return !storageService.isListMobilDataCacheValid();
  }

  void onListMobilPageResumed() {
    if (shouldAutoRefresh()) {
      print('List Mobil cache expired, refreshing data...');
      loadData(forceRefresh: true);
    }
  }

  void resetFilters() {
    activeFilters.value = {};
    searchQuery.value = '';
    searchController.clear();
    applyAllFilters();
  }

  void searchCars(String query) {
    searchQuery.value = query.toLowerCase();
  }

  void applyAllFilters() {
    if (carListings.isEmpty) {
      filteredCarListings.clear();
      return;
    }

    List filteredList = List.from(carListings);

    if (searchQuery.value.isNotEmpty) {
      filteredList = filteredList.where((car) {
        final String namaMobil =
            (car['nama_mobil'] ?? '').toString().toLowerCase();
        final String merk = (car['merk'] ?? '').toString().toLowerCase();
        return namaMobil.contains(searchQuery.value) ||
            merk.contains(searchQuery.value);
      }).toList();
    }

    if (activeFilters.value.isNotEmpty) {
      filteredList = _applyFilters(filteredList, activeFilters.value);
    }

    filteredCarListings.value = filteredList;
  }

  void applyCarFilter(Map<String, dynamic> filterParams) {
    activeFilters.value = Map<String, dynamic>.from(filterParams);
    applyAllFilters();
  }

  List _applyFilters(List list, Map<String, dynamic> filters) {
    return list.where((car) {
      if (filters['brand'] != null && car['merk'] != filters['brand']) {
        return false;
      }

      if (filters['merk_id'] != null &&
          car['merk_id'].toString() != filters['merk_id'].toString()) {
        return false;
      }

      if (filters['transmission'] != null &&
          car['transmisi'] != filters['transmission']) {
        return false;
      }

      if (filters['transmisi_id'] != null &&
          car['transmisi_id'].toString() !=
              filters['transmisi_id'].toString()) {
        return false;
      }

      if (filters['bodyType'] != null &&
          car['tipe_bodi'] != filters['bodyType']) {
        return false;
      }

      if (filters['tipe_bodi_id'] != null &&
          car['tipe_bodi_id'].toString() !=
              filters['tipe_bodi_id'].toString()) {
        return false;
      }

      if (filters['fuelType'] != null &&
          car['bahan_bakar'] != filters['fuelType']) {
        return false;
      }

      if (filters['bahan_bakar_id'] != null &&
          car['bahan_bakar_id'].toString() !=
              filters['bahan_bakar_id'].toString()) {
        return false;
      }

      if (filters['engineCapacity'] != null) {
        final String filterCapacity =
            filters['engineCapacity'].toString().replaceAll(' cc', '');
        final String carCapacity =
            car['kapasitas_mesin'].toString().replaceAll(' cc', '');

        if (filterCapacity != carCapacity) {
          return false;
        }
      }

      if (filters['kapasitas_mesin_id'] != null &&
          car['kapasitas_mesin_id'].toString() !=
              filters['kapasitas_mesin_id'].toString()) {
        return false;
      }

      if (filters['year'] != null &&
          car['tahun_keluaran'].toString() != filters['year']) {
        return false;
      }

      if (filters['color'] != null) {
        final List carColors = car['warna'] ?? [];
        if (!carColors.contains(filters['color'])) {
          return false;
        }
      }

      if (filters['priceRange'] != null) {
        final double carPrice = double.tryParse(car['harga'].toString()) ?? 0.0;
        final String priceRange = filters['priceRange'];

        try {
          if (priceRange == '< 20.000.000') {
            if (carPrice >= 20000000) return false;
          } else if (priceRange == '30.000.000 - 50.000.000') {
            if (carPrice < 30000000 || carPrice > 50000000) return false;
          } else if (priceRange == '100.000.000 - 300.000.000') {
            if (carPrice < 100000000 || carPrice > 300000000) return false;
          } else if (priceRange == '> 500.000.000') {
            if (carPrice <= 500000000) return false;
          }
        } catch (e) {
          print('Error processing price filter: $e');
        }
      }

      return true;
    }).toList();
  }

  void sortCarsByPrice({bool ascending = true}) {
    List sortedList = List.from(filteredCarListings);
    sortedList.sort((a, b) {
      final priceA = double.tryParse(a['harga'].toString()) ?? 0.0;
      final priceB = double.tryParse(b['harga'].toString()) ?? 0.0;
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });
    filteredCarListings.value = sortedList;
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}