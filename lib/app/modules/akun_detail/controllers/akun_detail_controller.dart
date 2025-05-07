import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';

class AkunDetailController extends GetxController {
  // Data pengguna yang dapat diedit
  final userData = {
    'name': 'Alexander Wijaya',
    'email': 'alexander.w@gmail.com',
    'phone': '+62 812 3456 7890',
    'gender': 'Laki-laki',
    'birthDate': '15 Maret 1990',
    'address': 'Jl. Kemang Raya No. 28, Jakarta Selatan',
    'city': 'Jakarta Selatan',
    'province': 'DKI Jakarta',
    'postalCode': '12730',
    'profileImage': 'assets/images/profile.jpg',
  }.obs;

  // Status edit mode
  final isEditMode = false.obs;

  // TextEditingControllers untuk form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController provinceController;
  late TextEditingController postalCodeController;

  // Dropdown value untuk gender
  final genderOptions = ['Laki-laki', 'Perempuan'].obs;
  final selectedGender = 'Laki-laki'.obs;

  // Form key untuk validasi
  final formKey = GlobalKey<FormState>();

  // Status loading saat menyimpan data
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Inisialisasi controllers dengan data pengguna
    nameController = TextEditingController(text: userData['name']);
    emailController = TextEditingController(text: userData['email']);
    phoneController = TextEditingController(text: userData['phone']);
    addressController = TextEditingController(text: userData['address']);
    cityController = TextEditingController(text: userData['city']);
    provinceController = TextEditingController(text: userData['province']);
    postalCodeController = TextEditingController(text: userData['postalCode']);

    // Set gender awal
    selectedGender.value = userData['gender'] ?? 'Laki-laki';
  }

  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }

  // Toggle edit mode
  void toggleEditMode() {
    if (isEditMode.value) {
      // Jika sedang dalam edit mode, kembali ke view mode
      isEditMode.value = false;
      
      // Reset controllers ke data asli jika membatalkan edit
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      phoneController.text = userData['phone'] ?? '';
      addressController.text = userData['address'] ?? '';
      cityController.text = userData['city'] ?? '';
      provinceController.text = userData['province'] ?? '';
      postalCodeController.text = userData['postalCode'] ?? '';
    } else {
      // Jika dalam view mode, masuk ke edit mode
      isEditMode.value = true;

      // Reset controllers ke data terbaru
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      phoneController.text = userData['phone'] ?? '';
      addressController.text = userData['address'] ?? '';
      cityController.text = userData['city'] ?? '';
      provinceController.text = userData['province'] ?? '';
      postalCodeController.text = userData['postalCode'] ?? '';
      selectedGender.value = userData['gender'] ?? 'Laki-laki';
    }
  }

  // Update data pengguna
  Future<void> updateUserData() async {
    if (formKey.currentState!.validate()) {
      try {
        isSaving.value = true;

        // Simulasi delay untuk API call
        await Future.delayed(Duration(seconds: 1));
        
    

        // Keluar dari edit mode
        isEditMode.value = false;

        // Show success snackbar
        Get.snackbar(
          'Berhasil',
          'Data akun berhasil diperbarui',
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
      } catch (e) {
        // Show error snackbar
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
          margin: EdgeInsets.all(20),
          duration: Duration(seconds: 2),
          icon: Icon(
            Remix.error_warning_line,
            color: Colors.white,
          ),
        );
      } finally {
        isSaving.value = false;
      }
    }
  }

  // Batalkan perubahan
  void cancelEdit() {
    // Reset controllers ke data asli
    nameController.text = userData['name'] ?? '';
    emailController.text = userData['email'] ?? '';
    phoneController.text = userData['phone'] ?? '';
    addressController.text = userData['address'] ?? '';
    cityController.text = userData['city'] ?? '';
    provinceController.text = userData['province'] ?? '';
    postalCodeController.text = userData['postalCode'] ?? '';
    
    // Keluar dari mode edit
    isEditMode.value = false;
  }

  // Validasi nama
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  // Validasi email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi telepon
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    return null;
  }
}