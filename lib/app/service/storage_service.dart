import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final GetStorage _box = GetStorage();

  static const String keyUser = 'user_data';
  static const String keyToken = 'auth_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyEmail = 'user_email'; // Untuk menyimpan email verifikasi
  
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // User data management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(keyUser, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final String? userData = _box.read(keyUser);
    if (userData == null) return null;
    return jsonDecode(userData) as Map<String, dynamic>;
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

  // Complete session management
  Future<void> saveSession({
    required Map<String, dynamic> userData,
    required String token,
  }) async {
    await saveUserData(userData);
    await storeToken(token);
    await setLoggedIn(true);
  }

  Future<void> clearSession() async {
    await _box.remove(keyUser);
    await _box.remove(keyToken);
    await _box.remove(keyIsLoggedIn);
    // We don't clear the email here to allow for verification after logout
  }

  // Complete logout that clears everything
  Future<void> logout() async {
    await _box.erase(); // This clears all data, including email
  }

  // Store user with token
  Future<void> storeUser(String userJson) async {
    await _box.write(keyUser, userJson);
  }
}