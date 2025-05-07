import 'package:dealer_mobil/app/modules/favorit/controllers/favorit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailMobilController extends GetxController {
  final FavoritController _favoritController = Get.find<FavoritController>();
  // Data merek mobil
  final brands = [
    {'name': 'Toyota', 'image': 'assets/images/toyota.png'},
    {'name': 'Honda', 'image': 'assets/images/honda.png'},
    {'name': 'Nissan', 'image': 'assets/images/nissan.png'},
    {'name': 'Mazda', 'image': 'assets/images/mazda.png'},
  ];

  // Data mobil dari arguments
  late Rx<Map<String, dynamic>> carData = Rx<Map<String, dynamic>>({});

  // Variable untuk menyimpan gambar yang dipilih
  var selectedImage = ''.obs;

  // Daftar gambar untuk galeri
  var galleryImages = <String>[].obs;

  var isFavorite = false.obs;

  // Getter untuk akses carData di view
  Map<String, dynamic> get car => carData.value;

  @override
  void onInit() {
    super.onInit();
    // Ambil data dari arguments
    if (Get.arguments != null) {
      carData.value = Map<String, dynamic>.from(Get.arguments);

      // Inisialisasi daftar gambar
      _initializeGalleryImages();

      // Inisialisasi gambar yang dipilih dengan gambar utama mobil
      if (galleryImages.isNotEmpty) {
        selectedImage.value = galleryImages[0];
      }
      _checkIfFavorite();
    }
    update();
  }

  // Inisialisasi daftar gambar galeri
  void _initializeGalleryImages() {
    if (carData.value.isNotEmpty && carData.value.containsKey('image')) {
      galleryImages.add(carData.value['image'] as String);

      // Tambahkan gambar interior
      galleryImages.add('assets/images/interior_1.jpg');
      galleryImages.add('assets/images/interior_2.jpg');
    }
  }

  // Fungsi untuk mengganti gambar yang dipilih
  void setSelectedImage(String imagePath) {
    if (imagePath.isNotEmpty) {
      selectedImage.value = imagePath;
    }
  }

  void _checkIfFavorite() {
    if (_favoritController.favoriteCars.any((favCar) => 
        favCar['carName'] == carData.value['carName'] && 
        favCar['logoName'] == carData.value['logoName'])) {
      isFavorite.value = true;
    } else {
      isFavorite.value = false;
    }
  }

  void toggleFavorite() {
    if (isFavorite.value) {
      // Hapus dari favorit
      _favoritController.removeFavorite(carData.value);
      isFavorite.value = false;
      Get.snackbar(
        'Favorit',
        '${carData.value['carName']} dihapus dari favorit',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 2),
      );
    } else {
      // Tambahkan ke favorit
      _favoritController.addFavorite(carData.value);
      isFavorite.value = true;
      Get.snackbar(
        'Favorit',
        '${carData.value['carName']} ditambahkan ke favorit',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 2),
      );
    }
  }

  // Fungsi untuk tombol beli
  void buyNow() {
    Get.snackbar(
      'Pembelian',
      'Anda membeli ${car['carName']}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
