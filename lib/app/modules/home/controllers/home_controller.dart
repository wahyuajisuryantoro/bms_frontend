import 'package:get/get.dart';

class HomeController extends GetxController {
  // List of brand data
  final brands = [
    {'name': 'Toyota', 'image': 'assets/images/toyota.png'},
    {'name': 'Honda', 'image': 'assets/images/honda.png'},
    {'name': 'Nissan', 'image': 'assets/images/nissan.png'},
     {'name': 'Mazda', 'image': 'assets/images/mazda.png'},
  ].obs;

  // Transmission options
  final transmissions = [
    {'name': 'Automatic', 'isSelected': true},
    {'name': 'Electric', 'isSelected': false},
    {'name': 'Manual', 'isSelected': false},
    {'name': 'CV', 'isSelected': false},
  ].obs;

  // Car listings
  final carListings = [
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
  ].obs;

  // Current location
  final location = 'Bali, Indonesia'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data here if needed
  }

  @override
  void onReady() {
    super.onReady();
    // Called after onInit when the widget is rendered on screen
  }

  @override
  void onClose() {
    super.onClose();
    // Called when the controller is removed from memory
  }

  // Method to select transmission
  void selectTransmission(int index) {
    // First set all to false
    for (var i = 0; i < transmissions.length; i++) {
      transmissions[i]['isSelected'] = false;
    }
    // Then set selected one to true
    transmissions[index]['isSelected'] = true;
    transmissions.refresh();
  }
}
