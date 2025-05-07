import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoritController extends GetxController {
  // List untuk menyimpan mobil favorit
  final favoriteCars = <Map<String, dynamic>>[].obs;
  
  // GetStorage untuk menyimpan data secara lokal
  final box = GetStorage();
  
  // Key untuk menyimpan data di GetStorage
  final String storageKey = 'favorite_cars';

  @override
  void onInit() {
    super.onInit();
    // Load data favorit yang tersimpan
    loadFavorites();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  
  // Fungsi untuk memuat favorit dari storage
  void loadFavorites() {
    try {
      final List<dynamic> storedFavorites = box.read(storageKey) ?? [];
      
      // Konversi data dari storage menjadi format yang benar
      favoriteCars.assignAll(
        storedFavorites
            .map((item) => Map<String, dynamic>.from(item))
            .toList()
      );
    } catch (e) {
      print('Error saat loading favorit: $e');
    }
  }
  
  // Fungsi untuk menyimpan favorit ke storage
  void saveFavorites() {
    box.write(storageKey, favoriteCars.toList());
  }
  
  // Fungsi untuk menambahkan mobil ke favorit
  void addFavorite(Map<String, dynamic> carData) {
    // Cek apakah mobil sudah ada di favorit
    if (!favoriteCars.any((car) => 
        car['carName'] == carData['carName'] && 
        car['logoName'] == carData['logoName'])) {
      
      // Tambahkan mobil ke daftar favorit
      favoriteCars.add(Map<String, dynamic>.from(carData));
      
      // Simpan perubahan ke storage
      saveFavorites();
      
      // Update badge count
      update();
    }
  }
  
  // Fungsi untuk menghapus mobil dari favorit
  void removeFavorite(Map<String, dynamic> carData) {
    // Hapus mobil dari daftar favorit
    favoriteCars.removeWhere((car) => 
        car['carName'] == carData['carName'] && 
        car['logoName'] == carData['logoName']);
    
    // Simpan perubahan ke storage
    saveFavorites();
    
    // Update badge count
    update();
  }
  
  // Fungsi untuk mengecek apakah mobil tertentu ada di favorit
  bool isCarFavorite(Map<String, dynamic> carData) {
    return favoriteCars.any((car) => 
        car['carName'] == carData['carName'] && 
        car['logoName'] == carData['logoName']);
  }
  
  // Getter untuk jumlah favorit (untuk badge di bottom nav)
  int get favoriteCount => favoriteCars.length;
}