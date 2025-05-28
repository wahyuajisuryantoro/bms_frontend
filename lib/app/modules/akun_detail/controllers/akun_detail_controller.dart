import 'package:dealer_mobil/app/base_url/base_url.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AkunDetailController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final ImagePicker _picker = ImagePicker();

  // Data pengguna yang dapat diedit
  final userData = <String, dynamic>{}.obs;
  
  // Data wilayah Indonesia
  final provinces = <Map<String, dynamic>>[].obs;
  final regencies = <Map<String, dynamic>>[].obs;
  final districts = <Map<String, dynamic>>[].obs;
  final villages = <Map<String, dynamic>>[].obs;
  
  // Selected IDs untuk dropdown
  final selectedProvinceId = Rxn<String>();
  final selectedRegencyId = Rxn<String>();
  final selectedDistrictId = Rxn<String>();
  final selectedVillageId = Rxn<String>();

  // Status edit mode
  final isEditMode = false.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  // TextEditingControllers untuk form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController noWaController;
  late TextEditingController dusunController;
  late TextEditingController alamatLengkapController;
  late TextEditingController kodePosController;

  // Dropdown value untuk gender
  final genderOptions = ['Laki-laki', 'Perempuan'].obs;
  final selectedGender = 'Laki-laki'.obs;

  // Form key untuk validasi
  final formKey = GlobalKey<FormState>();

  // Selected image file
  final selectedImageFile = Rxn<File>();
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Inisialisasi controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    noWaController = TextEditingController();
    dusunController = TextEditingController();
    alamatLengkapController = TextEditingController();
    kodePosController = TextEditingController();

    // Load initial data
    loadUserProfile();
    loadProvinces();
  }

  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    noWaController.dispose();
    dusunController.dispose();
    alamatLengkapController.dispose();
    kodePosController.dispose();
    super.onClose();
  }

  // Load user profile from API
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      final token = _storageService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
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

          // Update userData
          userData.value = {
            'id': user['id'],
            'name': user['name'] ?? '',
            'email': user['email'] ?? '',
            'email_verified_at': user['email_verified_at'],
            'no_wa': detail['no_wa'] ?? '',
            'dusun': detail['dusun'] ?? '',
            'alamat_lengkap': detail['alamat_lengkap'] ?? '',
            'kode_pos': detail['kode_pos'] ?? '',
            'foto': detail['foto'] ?? '',
            'province_id': detail['province_id'],
            'regency_id': detail['regency_id'],
            'district_id': detail['district_id'],
            'village_id': detail['village_id'],
            'province': detail['province'],
            'regency': detail['regency'],
            'district': detail['district'],
            'village': detail['village'],
          };

          // Update controllers
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          noWaController.text = userData['no_wa'] ?? '';
          dusunController.text = userData['dusun'] ?? '';
          alamatLengkapController.text = userData['alamat_lengkap'] ?? '';
          kodePosController.text = userData['kode_pos'] ?? '';

          // Update selected region IDs
          selectedProvinceId.value = detail['province_id'];
          selectedRegencyId.value = detail['regency_id'];
          selectedDistrictId.value = detail['district_id'];
          selectedVillageId.value = detail['village_id'];

          // Update profile image URL
          if (detail['foto'] != null && detail['foto'].toString().isNotEmpty) {
            profileImageUrl.value = '${BaseUrl.baseUrl}/storage/photos/${detail['foto']}';
          }

          // Load regions if IDs exist
          if (selectedProvinceId.value != null) {
            await loadRegencies(selectedProvinceId.value!);
          }
          if (selectedRegencyId.value != null) {
            await loadDistricts(selectedRegencyId.value!);
          }
          if (selectedDistrictId.value != null) {
            await loadVillages(selectedDistrictId.value!);
          }
        }
      } else if (response.statusCode == 401) {
        await _storageService.clearSession();
        Get.offAllNamed('/login');
      } else {
        throw Exception('Gagal memuat data profil');
      }
    } catch (e) {
      print('Error loading profile: $e');
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

  // Load provinces
  Future<void> loadProvinces() async {
    try {
      final token = _storageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/provinces'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          provinces.value = List<Map<String, dynamic>>.from(responseData['data']);
        }
      }
    } catch (e) {
      print('Error loading provinces: $e');
    }
  }

  // Load regencies by province
  Future<void> loadRegencies(String provinceId) async {
    try {
      regencies.clear();
      districts.clear();
      villages.clear();
      selectedRegencyId.value = null;
      selectedDistrictId.value = null;
      selectedVillageId.value = null;

      final token = _storageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/regencies/$provinceId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          regencies.value = List<Map<String, dynamic>>.from(responseData['data']);
        }
      }
    } catch (e) {
      print('Error loading regencies: $e');
    }
  }

  // Load districts by regency
  Future<void> loadDistricts(String regencyId) async {
    try {
      districts.clear();
      villages.clear();
      selectedDistrictId.value = null;
      selectedVillageId.value = null;

      final token = _storageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/districts/$regencyId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          districts.value = List<Map<String, dynamic>>.from(responseData['data']);
        }
      }
    } catch (e) {
      print('Error loading districts: $e');
    }
  }

  // Load villages by district
  Future<void> loadVillages(String districtId) async {
    try {
      villages.clear();
      selectedVillageId.value = null;

      final token = _storageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${BaseUrl.baseUrl}/villages/$districtId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          villages.value = List<Map<String, dynamic>>.from(responseData['data']);
        }
      }
    } catch (e) {
      print('Error loading villages: $e');
    }
  }

  // Province changed
  void onProvinceChanged(String? provinceId) {
    if (provinceId != null) {
      selectedProvinceId.value = provinceId;
      loadRegencies(provinceId);
    }
  }

  // Regency changed
  void onRegencyChanged(String? regencyId) {
    if (regencyId != null) {
      selectedRegencyId.value = regencyId;
      loadDistricts(regencyId);
    }
  }

  // District changed
  void onDistrictChanged(String? districtId) {
    if (districtId != null) {
      selectedDistrictId.value = districtId;
      loadVillages(districtId);
    }
  }

  // Village changed
  void onVillageChanged(String? villageId) {
    selectedVillageId.value = villageId;
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImageFile.value = File(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    if (isEditMode.value) {
      // Cancel edit mode
      isEditMode.value = false;
      selectedImageFile.value = null;
      
      // Reset form data
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      noWaController.text = userData['no_wa'] ?? '';
      dusunController.text = userData['dusun'] ?? '';
      alamatLengkapController.text = userData['alamat_lengkap'] ?? '';
      kodePosController.text = userData['kode_pos'] ?? '';
      
      selectedProvinceId.value = userData['province_id'];
      selectedRegencyId.value = userData['regency_id'];
      selectedDistrictId.value = userData['district_id'];
      selectedVillageId.value = userData['village_id'];
    } else {
      // Enter edit mode
      isEditMode.value = true;
    }
  }

  // Update user data
  Future<void> updateUserData() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isSaving.value = true;

      final token = _storageService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      // Debug: Print data yang akan dikirim
      print('Sending data:');
      print('name: ${nameController.text}');
      print('province_id: ${selectedProvinceId.value}');
      print('regency_id: ${selectedRegencyId.value}');
      print('district_id: ${selectedDistrictId.value}');
      print('village_id: ${selectedVillageId.value}');
      print('no_wa: ${noWaController.text}');

      // Prepare form data
      Map<String, String> fields = {
        'name': nameController.text.trim(),
      };

      // Only add non-null values
      if (selectedProvinceId.value != null && selectedProvinceId.value!.isNotEmpty) {
        fields['province_id'] = selectedProvinceId.value!;
      }
      if (selectedRegencyId.value != null && selectedRegencyId.value!.isNotEmpty) {
        fields['regency_id'] = selectedRegencyId.value!;
      }
      if (selectedDistrictId.value != null && selectedDistrictId.value!.isNotEmpty) {
        fields['district_id'] = selectedDistrictId.value!;
      }
      if (selectedVillageId.value != null && selectedVillageId.value!.isNotEmpty) {
        fields['village_id'] = selectedVillageId.value!;
      }
      if (dusunController.text.trim().isNotEmpty) {
        fields['dusun'] = dusunController.text.trim();
      }
      if (alamatLengkapController.text.trim().isNotEmpty) {
        fields['alamat_lengkap'] = alamatLengkapController.text.trim();
      }
      if (kodePosController.text.trim().isNotEmpty) {
        fields['kode_pos'] = kodePosController.text.trim();
      }
      if (noWaController.text.trim().isNotEmpty) {
        fields['no_wa'] = noWaController.text.trim();
      }

      // Create multipart request
      final request = http.MultipartRequest(
        'POST', // Change to POST
        Uri.parse('${BaseUrl.baseUrl}/profile-detail-update'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add _method field for PUT (Laravel method spoofing)
      fields['_method'] = 'PUT';

      // Add all fields
      request.fields.addAll(fields);

      // Add image if selected
      if (selectedImageFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            selectedImageFile.value!.path,
          ),
        );
      }

      // Debug: Print request fields
      print('Request fields: ${request.fields}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Debug: Print response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['status'] == true) {
          // Update local data
          await loadUserProfile();
          
          // Exit edit mode
          isEditMode.value = false;
          selectedImageFile.value = null;

          // Show success message
          Get.snackbar(
            'Berhasil',
            responseData['message'] ?? 'Data berhasil diperbarui',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            margin: EdgeInsets.all(20),
            duration: Duration(seconds: 2),
            icon: Icon(
              Remix.check_double_line,
              color: Colors.white,
            ),
          );
        } else {
          throw Exception(responseData['message'] ?? 'Gagal memperbarui data');
        }
      } else if (response.statusCode == 422) {
        // Validation error
        final responseData = jsonDecode(response.body);
        final errors = responseData['errors'] as Map<String, dynamic>?;
        
        if (errors != null && errors.isNotEmpty) {
          // Build error message from all errors
          List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessages.add(value.first.toString());
            } else if (value is String) {
              errorMessages.add(value);
            }
          });
          throw Exception(errorMessages.join('\n'));
        } else {
          throw Exception(responseData['message'] ?? 'Validasi gagal');
        }
      } else if (response.statusCode == 401) {
        await _storageService.clearSession();
        Get.offAllNamed('/login');
      } else {
        throw Exception('Gagal memperbarui data (${response.statusCode})');
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Gagal',
        e.toString().replaceAll('Exception: ', ''),
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
    } finally {
      isSaving.value = false;
    }
  }

  // Validasi nama
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi nomor WA
  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      // Remove all non-digit characters
      final phoneDigits = value.replaceAll(RegExp(r'\D'), '');
      
      if (phoneDigits.length < 10 || phoneDigits.length > 15) {
        return 'Nomor telepon tidak valid';
      }
    }
    return null;
  }

  // Validasi kode pos
  String? validatePostalCode(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^\d{5}$').hasMatch(value)) {
        return 'Kode pos harus 5 digit angka';
      }
    }
    return null;
  }
}