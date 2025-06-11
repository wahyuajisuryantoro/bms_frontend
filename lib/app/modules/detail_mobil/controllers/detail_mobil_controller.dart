import 'dart:async';
import 'dart:convert';
import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/modules/favorit/controllers/favorit_controller.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/helpers/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
  final RxDouble selectedDpAmount = 0.0.obs;

  final RxList<Map<String, dynamic>> tenorOptions =
      <Map<String, dynamic>>[].obs;

  // DP validation info
  final RxMap<String, dynamic> dpValidationInfo = <String, dynamic>{}.obs;
  final RxDouble dpMinimal = 0.0.obs;
  final RxDouble dpMaksimal = 0.0.obs;

  final RxBool isLoggedIn = false.obs;

  final RxBool isFavorite = false.obs;
  final RxBool isLoadingFavorite = false.obs;

  // Text controller for DP input
  final TextEditingController dpController = TextEditingController();

  Map<String, dynamic> get car => carData;

  Timer? dpTimer;

  @override
  void onInit() {
    super.onInit();

    final token = storageService.getToken();
    isLoggedIn.value = token != null;

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final mobilId = Get.arguments['id'];
      fetchDetailMobil(mobilId);

      if (isLoggedIn.value) {
        fetchTenorOptions(mobilId);
        fetchDpValidationInfo(mobilId);
      }
    } else {
      isError.value = true;
      errorMessage.value = 'ID Mobil tidak ditemukan';
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    dpController.dispose();
    super.onClose();
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
      print('Detail Mobil Response: ${response.body}');

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

  void triggerSimulasiKredit() {
    hitungSimulasiKredit();
  }

  String getFormattedPrice() {
    if (carData.containsKey('harga_cash') && carData['harga_cash'] != null) {
      final harga = parseToDouble(carData['harga_cash']);
      return CurrencyFormatter.formatRupiah(harga);
    }
    return 'Hubungi Kami';
  }

  void buyNow() async {
    try {
      String adminNumber = '6282325411811';

      String message = '🚗 *Halo Admin*\n';
      message += 'Saya tertarik dengan mobil:\n\n';
      message += '📋 *Detail Mobil:*\n';

      if (carData.isNotEmpty) {
        message += '- Nama: ${carData['nama_mobil'] ?? 'N/A'}\n';
        message += '- Merk: ${carData['merk'] ?? 'N/A'}\n';
        message += '- Tahun: ${carData['tahun_keluaran'] ?? 'N/A'}\n';
        message += '- Transmisi: ${carData['transmisi'] ?? 'N/A'}\n';
        message += '- Bahan Bakar: ${carData['bahan_bakar'] ?? 'N/A'}\n';
        message += '- Harga: ${getFormattedPrice()}\n\n';
      }

      message += '💰 *Saya ingin mengetahui:*\n';
      message += '- Info lebih detail tentang mobil ini\n';
      message += '- Opsi pembayaran yang tersedia\n';
      message += '- Proses pembelian\n';
      message += 'Mohon informasi lebih lanjut. Terima kasih! 🙏';

      final String whatsappUrl =
          'https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}';
      final Uri uri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'WhatsApp tidak terinstall di perangkat Anda',
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuka WhatsApp: $e',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  }

  void toggleSimulasiExpanded() {
    isSimulasiExpanded.value = !isSimulasiExpanded.value;
    if (isSimulasiExpanded.value && hasilSimulasi.isEmpty) {
      hitungSimulasiKredit();
    }
  }

  Future<void> fetchTenorOptions(dynamic mobilId) async {
    try {
      final token = storageService.getToken();

      if (token == null) {
        return;
      }

      final String endpoint =
          '${BaseUrl.baseUrl}/mobil-detail/$mobilId/tenor-options';

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      print('Tenor Options Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> options = responseData['data']['tenor_options'];
          tenorOptions.value = List<Map<String, dynamic>>.from(options);

          if (tenorOptions.isNotEmpty) {
            selectedTenor.value = tenorOptions[0]['tenor'];
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

  Future<void> fetchDpValidationInfo(dynamic mobilId) async {
    try {
      final token = storageService.getToken();
      if (token == null) {
        return;
      }

      final String endpoint =
          '${BaseUrl.baseUrl}/mobil-detail/$mobilId/dp-validation-info';

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      print('DP Validation Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          dpValidationInfo.value = responseData['data'];

          // Parse dengan helper method
          dpMinimal.value =
              parseToDouble(responseData['data']['dp_minimal_amount']);
          dpMaksimal.value =
              parseToDouble(responseData['data']['dp_maksimal_amount']);

          // Set default DP amount to minimal
          selectedDpAmount.value = dpMinimal.value;
          dpController.text =
              dpMinimal.value.toInt().toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]}.',
                  );
        }
      } else {
        print(
            'Error fetchDpValidationInfo: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetchDpValidationInfo: $e');
    }
  }

  Future<void> hitungSimulasiKredit() async {
    try {
      if (carData.isEmpty || !carData.containsKey('id')) {
        isSimulasiError.value = true;
        simulasiErrorMessage.value = 'Data mobil tidak tersedia';
        return;
      }

      // Clear previous error
      isSimulasiError.value = false;

      // Minimal validation - hanya check basic requirements
      if (selectedTenor.value <= 0) {
        isSimulasiError.value = true;
        simulasiErrorMessage.value = 'Silakan pilih tenor terlebih dahulu';
        return;
      }

      if (selectedDpAmount.value <= 0) {
        isSimulasiError.value = true;
        simulasiErrorMessage.value =
            'Silakan masukkan jumlah DP terlebih dahulu';
        return;
      }

      // HILANGKAN VALIDASI RANGE DP DI FRONTEND
      // Biarkan backend yang handle validasi range
      // Frontend hanya check apakah ada input atau tidak

      isLoadingSimulasi.value = true;

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
        'dp_amount': selectedDpAmount.value,
      };

      print('Simulasi Kredit Payload: $payload');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(payload),
      );

      print('Simulasi Kredit Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          hasilSimulasi.value = responseData['data'];
          isSimulasiError.value = false;
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

        // Handle validation errors from backend dengan friendly message
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          String errorMessage = '';

          if (errors is Map) {
            errors.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                errorMessage += '${value[0]}\n';
              }
            });
          }

          simulasiErrorMessage.value = errorMessage.isNotEmpty
              ? errorMessage.trim()
              : 'Silakan periksa input Anda';
        } else {
          simulasiErrorMessage.value =
              responseData['message'] ?? 'Silakan periksa input Anda';
        }
      } else {
        isSimulasiError.value = true;
        simulasiErrorMessage.value =
            'Terjadi kesalahan pada server. Silakan coba lagi.';
        print(
            'Error hitungSimulasiKredit: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      isSimulasiError.value = true;
      simulasiErrorMessage.value =
          'Terjadi kesalahan jaringan. Silakan coba lagi.';
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

  void changeDpAmount(String value) {
    final cleanValue = value.replaceAll('.', '').replaceAll(',', '');
    final amount = parseToDouble(cleanValue);
    selectedDpAmount.value = amount;
    if (selectedTenor.value > 0 && amount > 0) {
      hitungSimulasiKredit();
    }
  }

  void validateAndUpdateDp() {
    final text = dpController.text.replaceAll('.', '').replaceAll(',', '');
    final amount = parseToDouble(text);

    selectedDpAmount.value = amount;

    if (amount > 0 && selectedTenor.value > 0) {
      hitungSimulasiKredit();
    }
  }

  // Helper method to format DP amount for display
  String getFormattedDpAmount() {
    return CurrencyFormatter.formatRupiah(selectedDpAmount.value);
  }

  // Helper method to get DP percentage
  double getDpPercentage() {
    if (dpValidationInfo.containsKey('harga_otr')) {
      final hargaOtr = parseToDouble(dpValidationInfo['harga_otr']);
      if (hargaOtr > 0) {
        return (selectedDpAmount.value / hargaOtr) * 100;
      }
    }
    return 0.0;
  }

  double parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Remove any currency formatting and parse
      String cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleanValue) ?? 0.0;
    }
    return 0.0;
  }
}
