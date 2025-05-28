import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/modules/favorit/controllers/favorit_controller.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/helpers/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailMobilController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();

  final RxMap<String, dynamic> carData = <String, dynamic>{}.obs;

  var selectedImage = ''.obs;

  var galleryImages = <String>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isSimulasiExpanded = false.obs;
  final RxBool isLoadingSimulasi = false.obs;
  final RxBool isSimulasiError = false.obs;
  final RxString simulasiErrorMessage = ''.obs;
  final RxMap<String, dynamic> hasilSimulasi = <String, dynamic>{}.obs;

  final RxInt selectedTenor = 36.obs;
  final RxDouble selectedDp = 20.0.obs;

  final RxList<Map<String, dynamic>> tenorOptions =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> dpOptions = <Map<String, dynamic>>[].obs;

  final RxBool isLoggedIn = false.obs;

  final RxBool isFavorite = false.obs;
  final RxBool isLoadingFavorite = false.obs;

  Map<String, dynamic> get car => carData;

  @override
  void onInit() {
    super.onInit();

    final token = storageService.getToken();
    isLoggedIn.value = token != null;

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final mobilId = Get.arguments['id'];
      fetchDetailMobil(mobilId);

      if (isLoggedIn.value) {
        fetchTenorOptions();
        fetchDpOptions();
      }
    } else {
      isError.value = true;
      errorMessage.value = 'ID Mobil tidak ditemukan';
      isLoading.value = false;
    }
  }

  Future<void> fetchDetailMobil(dynamic mobilId) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final token = storageService.getToken();

      final String endpoint = '${BaseUrl.baseUrl}/mobil-detail/$mobilId';

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
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          carData.value = responseData['data'];
          if (responseData['data'].containsKey('is_favorited')) {
            isFavorite.value = responseData['data']['is_favorited'] == 1;
          }

          _initializeGalleryImages();

          if (galleryImages.isNotEmpty) {
            selectedImage.value = galleryImages[0];
          }
        } else {
          isError.value = true;
          errorMessage.value =
              responseData['message'] ?? 'Gagal memuat data mobil';
        }
      } else if (response.statusCode == 401) {
        isError.value = true;
        errorMessage.value = 'Anda perlu login untuk mengakses data ini';
      } else if (response.statusCode == 404) {
        isError.value = true;
        errorMessage.value = 'Mobil tidak ditemukan';
      } else {
        isError.value = true;
        errorMessage.value = 'Terjadi kesalahan: ${response.statusCode}';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> toggleFavorite() async {
    if (!isLoggedIn.value) {
      Get.snackbar(
          'Perlu Login', 'Anda harus login untuk menambahkan ke favorit');
      return;
    }

    if (carData.isEmpty || !carData.containsKey('id')) {
      Get.snackbar('Error', 'Data mobil tidak tersedia');
      return;
    }

    try {
      isLoadingFavorite.value = true;

      final token = storageService.getToken();
      if (token == null) return;

      final String endpoint =
          '${BaseUrl.baseUrl}/mobil-detail/${carData['id']}/toggle-favorite';

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          // Update status favorit berdasarkan response
          final newStatus = responseData['data']['is_favorited'];
          isFavorite.value = newStatus == 1;

          // Update data mobil
          carData['is_favorited'] = newStatus;
          carData['favorite_id'] = responseData['data']['id'];

          // **TAMBAHAN: Update FavoritController untuk badge**
          try {
            final favoritController = Get.find<FavoritController>();
            if (newStatus == 1) {
              // Tambah ke list favorit untuk update badge count
              favoritController.addToLocalFavorites({
                'favorite_id': responseData['data']['id'],
                'mobil_id': carData['id'],
                'nama_mobil': carData['nama_mobil'],
                'merk': carData['merk'],
                'harga_cash': carData['harga_cash'],
                'thumbnail_foto': carData['thumbnail_foto'],
                'tahun_keluaran': carData['tahun_keluaran'],
                'transmisi': carData['transmisi'],
                'bahan_bakar': carData['bahan_bakar'],
                'is_favorited': 1,
              });
            } else {
              favoritController.removeFromLocalFavorites(carData['id']);
            }
          } catch (e) {
            print('FavoritController not found: $e');
            final favoritController =
                Get.put(FavoritController(), permanent: true);
            favoritController.getAllDataFavorite();
          }

          // Show success message
          Get.snackbar(
            isFavorite.value ? 'Ditambahkan!' : 'Dihapus!',
            responseData['message'],
            backgroundColor:
                isFavorite.value ? AppColors.success : AppColors.danger,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoadingFavorite.value = false;
    }
  }

  void _initializeGalleryImages() {
    galleryImages.clear();

    if (carData.containsKey('thumbnail_foto') &&
        carData['thumbnail_foto'] != null) {
      galleryImages.add(carData['thumbnail_foto']);
    }
    if (carData.containsKey('foto_detail') && carData['foto_detail'] is List) {
      final List<dynamic> fotoDetails = carData['foto_detail'];
      for (var foto in fotoDetails) {
        if (foto is Map<String, dynamic> &&
            foto.containsKey('foto_path') &&
            foto['foto_path'] != null) {
          galleryImages.add(foto['foto_path']);
        }
      }
    }
  }

  void setSelectedImage(String imagePath) {
    if (imagePath.isNotEmpty) {
      selectedImage.value = imagePath;
    }
  }

  String getFormattedPrice() {
    if (carData.containsKey('harga_cash') && carData['harga_cash'] != null) {
      final dynamic hargaRaw = carData['harga_cash'];
      final num harga =
          hargaRaw is String ? num.tryParse(hargaRaw) ?? 0 : (hargaRaw as num);
      return CurrencyFormatter.formatRupiah(harga);
    }
    return 'Hubungi Kami';
  }

  void buyNow() {
    Get.snackbar(
      'Hubungi Penjual',
      'Fitur ini akan terhubung ke WhatsApp penjual',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      duration: Duration(seconds: 2),
    );
  }

  void toggleSimulasiExpanded() {
    isSimulasiExpanded.value = !isSimulasiExpanded.value;
    if (isSimulasiExpanded.value && hasilSimulasi.isEmpty) {
      hitungSimulasiKredit();
    }
  }

  Future<void> fetchTenorOptions() async {
    try {
      final token = storageService.getToken();

      if (token == null) {
        return;
      }

      final String endpoint = '${BaseUrl.baseUrl}/mobil-detail/tenor-options';

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> options = responseData['data'];
          tenorOptions.value = List<Map<String, dynamic>>.from(options);

          if (tenorOptions.isNotEmpty) {
            selectedTenor.value = 36;
          }
        }
      } else {
        print(
            'Error fetchTenorOptions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetchTenorOptions: $e');
    }
  }

  Future<void> fetchDpOptions() async {
    try {
      final token = storageService.getToken();
      if (token == null) {
        return;
      }
      final String endpoint = '${BaseUrl.baseUrl}/mobil-detail/dp-options';

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> options = responseData['data'];
          dpOptions.value = List<Map<String, dynamic>>.from(options);

          if (dpOptions.isNotEmpty) {
            selectedDp.value = 20.0;
          }
        }
      } else {
        print(
            'Error fetchDpOptions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetchDpOptions: $e');
    }
  }

  Future<void> hitungSimulasiKredit() async {
    try {
      if (carData.isEmpty || !carData.containsKey('id')) {
        isSimulasiError.value = true;
        simulasiErrorMessage.value = 'Data mobil tidak tersedia';
        return;
      }

      isLoadingSimulasi.value = true;
      isSimulasiError.value = false;

      final token = storageService.getToken();

      if (token == null) {
        isSimulasiError.value = true;
        simulasiErrorMessage.value = 'Token tidak tersedia';
        isLoadingSimulasi.value = false;
        return;
      }

      final String endpoint =
          '${BaseUrl.baseUrl}/mobil-detail/${carData['id']}/simulasi-kredit';

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final Map<String, dynamic> payload = {
        'tenor': selectedTenor.value,
        'dp_percentage': selectedDp.value,
      };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          hasilSimulasi.value = responseData['data'];
        } else {
          isSimulasiError.value = true;
          simulasiErrorMessage.value =
              responseData['message'] ?? 'Gagal menghitung simulasi kredit';
        }
      } else if (response.statusCode == 401) {
        isSimulasiError.value = true;
        simulasiErrorMessage.value =
            'Anda harus login untuk menggunakan fitur ini';
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        isSimulasiError.value = true;
        simulasiErrorMessage.value =
            'Validasi gagal: ${responseData['errors']}';
      } else {
        isSimulasiError.value = true;
        simulasiErrorMessage.value =
            'Terjadi kesalahan: ${response.statusCode}';
        print(
            'Error hitungSimulasiKredit: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      isSimulasiError.value = true;
      simulasiErrorMessage.value = 'Terjadi kesalahan: $e';
      print('Error hitungSimulasiKredit: $e');
    } finally {
      isLoadingSimulasi.value = false;
      update();
    }
  }

  void changeTenor(int tenor) {
    selectedTenor.value = tenor;
    hitungSimulasiKredit();
  }

  void changeDp(double dp) {
    selectedDp.value = dp;
    hitungSimulasiKredit();
  }
}
