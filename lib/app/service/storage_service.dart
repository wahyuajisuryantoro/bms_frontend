import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final GetStorage _box = GetStorage();

  static const String keyUser = 'user_data';
  static const String keyUserDetail = 'user_detail_data';
  static const String keyToken = 'auth_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyEmail = 'user_email';
  
  // Car data cache keys (Home)
  static const String keyCarListings = 'car_listings';
  static const String keyBrands = 'brands_data';
  static const String keyTransmissions = 'transmissions_data';
  static const String keyCarDataTimestamp = 'car_data_timestamp';
  static const String keyBrandsTimestamp = 'brands_timestamp';
  static const String keyTransmissionsTimestamp = 'transmissions_timestamp';
  
  // List Mobil cache keys
  static const String keyAllCarListings = 'all_car_listings';
  static const String keyFilterOptions = 'filter_options';
  static const String keyAllCarTimestamp = 'all_car_timestamp';
  static const String keyFilterOptionsTimestamp = 'filter_options_timestamp';
  
  // Cache duration (dalam menit)
  static const int cacheExpirationMinutes = 30; // Data expire setelah 30 menit
  
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // UPDATED: User data management - bisa simpan gabungan user + detail
  Future<void> saveUserData(Map<String, dynamic> userData, {Map<String, dynamic>? userDetail}) async {
    Map<String, dynamic> combinedData = {...userData};
    
    // Gabungkan dengan detail jika ada
    if (userDetail != null) {
      combinedData.addAll(userDetail);
    }
    
    await _box.write(keyUser, jsonEncode(combinedData));
  }

  Map<String, dynamic>? getUserData() {
    final String? userData = _box.read(keyUser);
    if (userData == null) return null;
    return jsonDecode(userData) as Map<String, dynamic>;
  }

  // ADDED: User detail management
  Future<void> saveUserDetail(Map<String, dynamic> userDetail) async {
    await _box.write(keyUserDetail, jsonEncode(userDetail));
  }

  Map<String, dynamic>? getUserDetail() {
    final String? userDetail = _box.read(keyUserDetail);
    if (userDetail == null) return null;
    return jsonDecode(userDetail) as Map<String, dynamic>;
  }

  int? getUserId() {
    final userData = getUserData();
    return userData != null ? userData['id'] as int? : null;
  }

  String? getName() {
    final userData = getUserData();
    return userData != null ? userData['name'] as String? : null;
  }

  String? getEmail() {
    final userData = getUserData();
    return userData != null ? userData['email'] as String? : null;
  }

  // Email storage for verification process
  Future<void> storeEmail(String email) async {
    await _box.write(keyEmail, email);
  }

  String? getStoredEmail() {
    return _box.read(keyEmail);
  }

  Future<void> clearStoredEmail() async {
    await _box.remove(keyEmail);
  }

  // Token management
  Future<void> storeToken(String token) async {
    await _box.write(keyToken, token);
  }

  String? getToken() {
    return _box.read(keyToken);
  }

  Future<void> clearToken() async {
    await _box.remove(keyToken);
  }

  // Login status
  Future<void> setLoggedIn(bool status) async {
    await _box.write(keyIsLoggedIn, status);
  }

  bool isLoggedIn() {
    return _box.read(keyIsLoggedIn) ?? false;
  }

  // UPDATED: Complete session management - support userDetail
  Future<void> saveSession({
    required Map<String, dynamic> userData,
    Map<String, dynamic>? userDetail,
    required String token,
  }) async {
    await saveUserData(userData, userDetail: userDetail);
    await storeToken(token);
    await setLoggedIn(true);
  }

  Future<void> clearSession() async {
    await _box.remove(keyUser);
    await _box.remove(keyUserDetail);
    await _box.remove(keyToken);
    await _box.remove(keyIsLoggedIn);
  }

  // Complete logout that clears everything
  Future<void> logout() async {
    await _box.erase();
  }

  // KEPT: Store user with token (untuk backward compatibility)
  Future<void> storeUser(String userJson) async {
    await _box.write(keyUser, userJson);
  }

  // ==================== HELPER METHODS ====================
  
  // Helper method untuk mengecek apakah cache sudah expired
  bool _isCacheExpired(String timestampKey) {
    final timestamp = _box.read(timestampKey);
    if (timestamp == null) return true;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime).inMinutes;
    
    return difference >= cacheExpirationMinutes;
  }

  // Helper method untuk menyimpan timestamp
  Future<void> _saveTimestamp(String timestampKey) async {
    await _box.write(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // ==================== HOME CAR DATA CACHING METHODS ====================
  
  // Car listings cache management (Home)
  Future<void> saveCarListings(List<Map<String, dynamic>> carListings) async {
    await _box.write(keyCarListings, jsonEncode(carListings));
    await _saveTimestamp(keyCarDataTimestamp);
  }

  List<Map<String, dynamic>>? getCachedCarListings() {
    if (_isCacheExpired(keyCarDataTimestamp)) {
      return null; // Cache expired
    }
    
    final String? carData = _box.read(keyCarListings);
    if (carData == null) return null;
    
    final List<dynamic> decoded = jsonDecode(carData);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  bool isCarListingsCacheValid() {
    return !_isCacheExpired(keyCarDataTimestamp);
  }

  // Brands cache management
  Future<void> saveBrands(List<Map<String, dynamic>> brands) async {
    await _box.write(keyBrands, jsonEncode(brands));
    await _saveTimestamp(keyBrandsTimestamp);
  }

  List<Map<String, dynamic>>? getCachedBrands() {
    if (_isCacheExpired(keyBrandsTimestamp)) {
      return null; // Cache expired
    }
    
    final String? brandsData = _box.read(keyBrands);
    if (brandsData == null) return null;
    
    final List<dynamic> decoded = jsonDecode(brandsData);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  bool isBrandsCacheValid() {
    return !_isCacheExpired(keyBrandsTimestamp);
  }

  // Transmissions cache management
  Future<void> saveTransmissions(List<Map<String, dynamic>> transmissions) async {
    await _box.write(keyTransmissions, jsonEncode(transmissions));
    await _saveTimestamp(keyTransmissionsTimestamp);
  }

  List<Map<String, dynamic>>? getCachedTransmissions() {
    if (_isCacheExpired(keyTransmissionsTimestamp)) {
      return null; // Cache expired
    }
    
    final String? transmissionsData = _box.read(keyTransmissions);
    if (transmissionsData == null) return null;
    
    final List<dynamic> decoded = jsonDecode(transmissionsData);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  bool isTransmissionsCacheValid() {
    return !_isCacheExpired(keyTransmissionsTimestamp);
  }

  // ==================== LIST MOBIL CACHING METHODS ====================
  
  // All car listings cache management (List Mobil)
  Future<void> saveAllCarListings(List<dynamic> allCarListings) async {
    await _box.write(keyAllCarListings, jsonEncode(allCarListings));
    await _saveTimestamp(keyAllCarTimestamp);
  }

  List<dynamic>? getCachedAllCarListings() {
    if (_isCacheExpired(keyAllCarTimestamp)) {
      return null; // Cache expired
    }
    
    final String? carData = _box.read(keyAllCarListings);
    if (carData == null) return null;
    
    return jsonDecode(carData) as List<dynamic>;
  }

  bool isAllCarListingsCacheValid() {
    return !_isCacheExpired(keyAllCarTimestamp);
  }

  // Filter options cache management
  Future<void> saveFilterOptions(Map<String, dynamic> filterOptions) async {
    await _box.write(keyFilterOptions, jsonEncode(filterOptions));
    await _saveTimestamp(keyFilterOptionsTimestamp);
  }

  Map<String, dynamic>? getCachedFilterOptions() {
    if (_isCacheExpired(keyFilterOptionsTimestamp)) {
      return null; // Cache expired
    }
    
    final String? filterData = _box.read(keyFilterOptions);
    if (filterData == null) return null;
    
    return jsonDecode(filterData) as Map<String, dynamic>;
  }

  bool isFilterOptionsCacheValid() {
    return !_isCacheExpired(keyFilterOptionsTimestamp);
  }

  // Save complete list mobil data (cars + filter options)
  Future<void> saveListMobilData({
    required List<dynamic> carListings,
    required Map<String, dynamic> filterOptions,
  }) async {
    await saveAllCarListings(carListings);
    await saveFilterOptions(filterOptions);
  }

  // Get complete list mobil data
  Map<String, dynamic>? getCachedListMobilData() {
    final cachedCars = getCachedAllCarListings();
    final cachedFilters = getCachedFilterOptions();
    
    if (cachedCars != null && cachedFilters != null) {
      return {
        'carListings': cachedCars,
        'filterOptions': cachedFilters,
      };
    }
    
    return null;
  }

  bool isListMobilDataCacheValid() {
    return isAllCarListingsCacheValid() && isFilterOptionsCacheValid();
  }

  // ==================== CACHE MANAGEMENT ====================

  // Clear all car data cache (Home)
  Future<void> clearCarDataCache() async {
    await _box.remove(keyCarListings);
    await _box.remove(keyBrands);
    await _box.remove(keyTransmissions);
    await _box.remove(keyCarDataTimestamp);
    await _box.remove(keyBrandsTimestamp);
    await _box.remove(keyTransmissionsTimestamp);
  }

  // Clear list mobil cache
  Future<void> clearListMobilCache() async {
    await _box.remove(keyAllCarListings);
    await _box.remove(keyFilterOptions);
    await _box.remove(keyAllCarTimestamp);
    await _box.remove(keyFilterOptionsTimestamp);
  }

  // Clear all caches
  Future<void> clearAllCaches() async {
    await clearCarDataCache();
    await clearListMobilCache();
  }

  // Force refresh - clear cache untuk memaksa fetch data baru
  Future<void> forceRefreshCarData() async {
    await clearCarDataCache();
  }

  Future<void> forceRefreshListMobil() async {
    await clearListMobilCache();
  }

  Future<void> forceRefreshAllData() async {
    await clearAllCaches();
  }

  // Get cache age in minutes untuk debugging/info
  int? getCacheAgeMinutes(String timestampKey) {
    final timestamp = _box.read(timestampKey);
    if (timestamp == null) return null;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime).inMinutes;
  }

  // Get all cache status for debugging
  Map<String, bool> getAllCacheStatus() {
    return {
      'carListings': isCarListingsCacheValid(),
      'brands': isBrandsCacheValid(),
      'transmissions': isTransmissionsCacheValid(),
      'allCarListings': isAllCarListingsCacheValid(),
      'filterOptions': isFilterOptionsCacheValid(),
    };
  }
}