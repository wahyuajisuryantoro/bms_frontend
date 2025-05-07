
import 'package:get/get.dart';

class ListMobilController extends GetxController {
  // Observable list untuk daftar mobil original (tidak berubah)
  final brands = [
    {'name': 'Toyota', 'image': 'assets/images/toyota.png'},
    {'name': 'Honda', 'image': 'assets/images/honda.png'},
    {'name': 'Nissan', 'image': 'assets/images/nissan.png'},
    {'name': 'Mazda', 'image': 'assets/images/mazda.png'},
  ].obs;

  // Daftar mobil original
  final List<Map<String, dynamic>> _originalCarList = [
    {
      'id': '1',
      'image': 'assets/images/ryzen.jpg',
      'logoName': 'Toyota',
      'carName': 'Toyota Ryzen',
      'price': '210000000',
      'horsePower': '586 hp',
      'transmission': 'Automatic',
      'seats': '4 Seats',
      'bodyType': 'Sedan',
      'engineCapacity': '2.0L',
      'color': 'Merah',
      'fuelType': 'Bensin',
      'year': '2022',
      'description':
          'Mobil sporty dengan performa tinggi dari Toyota, dirancang untuk pengalaman berkendara yang luar biasa.',
    },
    {
      'id': '2',
      'image': 'assets/images/veloz.png',
      'logoName': 'Toyota',
      'carName': 'Avanza Veloz',
      'price': '376000000',
      'horsePower': '450 hp',
      'transmission': 'Automatic',
      'seats': '7 Seats',
      'bodyType': 'MPV',
      'engineCapacity': '1.5L',
      'color': 'Putih',
      'fuelType': 'Bensin',
      'year': '2023',
      'description':
          'MPV keluarga yang nyaman dengan kapasitas penumpang lebih banyak dan fitur modern.',
    },
    {
      'id': '3',
      'image': 'assets/images/mazda_m2.png',
      'logoName': 'Mazda',
      'carName': 'Mazda M2',
      'price': '198900000',
      'horsePower': '520 hp',
      'transmission': 'Automatic',
      'seats': '5 Seats',
      'bodyType': 'Sedan',
      'engineCapacity': '2.0L',
      'color': 'Hitam',
      'fuelType': 'Bensin',
      'year': '2022',
      'description':
          'Sedan sporty dengan desain elegan dan teknologi canggih dari Mazda.',
    },
  ];

  // Observable list untuk daftar mobil yang dapat berubah sesuai filter
  final RxList<Map<String, dynamic>> carListings =
      RxList<Map<String, dynamic>>();

  // Filter mobil berdasarkan nama atau merek
  final RxString searchQuery = ''.obs;

  // Filter parameter
  final Rx<Map<String, dynamic>> activeFilters = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi carListings dengan data original
    carListings.assignAll(_originalCarList);
  }

  // Metode untuk melakukan pencarian
  void searchCars(String query) {
    searchQuery.value = query.toLowerCase();
    applyAllFilters();
  }

  // Getter untuk list mobil yang difilter berdasarkan pencarian
  List<Map<String, dynamic>> get filteredCarListings {
    return carListings;
  }

  // Reset semua filter
  void resetFilters() {
    activeFilters.value = {};
    searchQuery.value = '';
    carListings.clear();
    carListings.addAll(_originalCarList);
  }

  void applyAllFilters() {
    // Mulai dengan list original
    List<Map<String, dynamic>> filteredList = [..._originalCarList];

    // Terapkan filter pencarian
    if (searchQuery.value.isNotEmpty) {
      filteredList = filteredList.where((car) {
        final carName = (car['carName'] as String).toLowerCase();
        final logoName = (car['logoName'] as String).toLowerCase();
        return carName.contains(searchQuery.value) ||
            logoName.contains(searchQuery.value);
      }).toList();
    }

    // Jika ada filter aktif, terapkan
    if (activeFilters.value.isNotEmpty) {
      filteredList = _applyFilters(filteredList, activeFilters.value);
    }

    // Update observable list dengan cara yang benar
    carListings.clear();
    carListings.addAll(filteredList);
  }

  // Method untuk menerapkan filter (bersih dari pencarian)
  void applyCarFilter(Map<String, dynamic> filterParams) {
    // Simpan filter yang aktif
    activeFilters.value = Map<String, dynamic>.from(filterParams);

    // Terapkan semua filter
    applyAllFilters();
  }

  List<Map<String, dynamic>> _applyFilters(
      List<Map<String, dynamic>> list, Map<String, dynamic> filters) {
    return list.where((car) {
      // Filter berdasarkan brand/merk
      if (filters['brand'] != null && car['logoName'] != filters['brand']) {
        return false;
      }

      // Filter berdasarkan transmisi
      if (filters['transmission'] != null &&
          car['transmission'] != filters['transmission']) {
        return false;
      }

      // Filter berdasarkan rentang harga - dengan pemeriksaan lebih baik
      if (filters['priceRange'] != null) {
        final double carPrice = double.tryParse(car['price']) ?? 0.0;
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
          print('Error memproses filter harga: $e');
        }
      }

      // Filter lainnya (tidak berubah)
      if (filters['bodyType'] != null && car['bodyType'] != filters['bodyType'])
        return false;
      if (filters['engineCapacity'] != null &&
          car['engineCapacity'] != filters['engineCapacity']) return false;
      if (filters['color'] != null && car['color'] != filters['color'])
        return false;
      if (filters['fuelType'] != null && car['fuelType'] != filters['fuelType'])
        return false;
      if (filters['year'] != null && car['year'] != filters['year'])
        return false;

      return true;
    }).toList();
      }

  // Metode untuk mengurutkan mobil
  void sortCarsByPrice({bool ascending = true}) {
    List<Map<String, dynamic>> sortedList = [...carListings];
    sortedList.sort((a, b) {
      final priceA = double.tryParse(a['price']) ?? 0.0;
      final priceB = double.tryParse(b['price']) ?? 0.0;
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });
    carListings.assignAll(sortedList);
  }

  @override
  void onClose() {
    // Pembersihan sumber daya jika diperlukan
    super.onClose();
  }
}
