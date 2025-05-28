import 'package:dealer_mobil/app/modules/favorit/controllers/favorit_controller.dart';
import 'package:dealer_mobil/app/service/storage_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  final storageService = Get.put(StorageService(), permanent: true);
  Get.put(FavoritController(), permanent: true);
  final initialRoute = storageService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
