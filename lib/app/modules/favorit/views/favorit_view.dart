import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:dealer_mobil/app/widget/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/favorit_controller.dart';

class FavoritView extends GetView<FavoritController> {
  const FavoritView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Mobil Favorit',
          style: AppText.h5(color: AppColors.dark),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(() => controller.favoriteCars.isEmpty
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    // Konfirmasi hapus semua
                    Get.dialog(
                      AlertDialog(
                        title: Text(
                          'Hapus Semua Favorit',
                          style: AppText.h5(color: AppColors.dark),
                        ),
                        content: Text(
                          'Apakah Anda yakin ingin menghapus semua mobil favorit?',
                          style: AppText.p(color: AppColors.dark),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Batal',
                              style: AppText.button(color: AppColors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.favoriteCars.clear();
                              controller.saveFavorites();
                              Get.back();
                              Get.snackbar(
                                'Favorit',
                                'Semua favorit berhasil dihapus',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.all(20),
                                duration: Duration(seconds: 2),
                              );
                            },
                            child: Text(
                              'Hapus',
                              style: AppText.button(color: AppColors.danger),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Remix.delete_bin_line,
                    color: AppColors.dark,
                  ),
                )),
        ],
      ),
      body: Obx(
        () => controller.favoriteCars.isEmpty
            ? _buildEmptyState()
            : _buildFavoritList(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Remix.heart_3_line,
            size: AppResponsive.getResponsiveSize(80),
            color: AppColors.muted,
          ),
          SizedBox(height: AppResponsive.h(2)),
          Text(
            'Belum ada mobil favorit',
            style: AppText.h5(color: AppColors.dark),
          ),
          SizedBox(height: AppResponsive.h(1)),
          Text(
            'Tambahkan mobil ke favorit untuk melihatnya di sini',
            style: AppText.p(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppResponsive.h(3)),
          ElevatedButton(
            onPressed: () => Get.toNamed('/list-mobil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: AppResponsive.padding(horizontal: 5, vertical: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppResponsive.getResponsiveSize(10),
                ),
              ),
            ),
            child: Text(
              'Lihat Daftar Mobil',
              style: AppText.button(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritList() {
    return ListView.builder(
      padding: AppResponsive.padding(all: 4),
      itemCount: controller.favoriteCars.length,
      itemBuilder: (context, index) {
        final car = controller.favoriteCars[index];
        return _buildFavoritItem(car, index);
      },
    );
  }

  Widget _buildFavoritItem(Map<String, dynamic> car, int index) {
    return Container(
      margin: AppResponsive.margin(bottom: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/detail-mobil', arguments: car),
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Mobil
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppResponsive.getResponsiveSize(15)),
                    topRight: Radius.circular(AppResponsive.getResponsiveSize(15)),
                  ),
                  child: Image.asset(
                    car['image'] as String,
                    height: AppResponsive.h(20),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: AppResponsive.h(20),
                        color: AppColors.muted,
                        child: Center(
                          child: Icon(
                            Remix.image_line,
                            size: AppResponsive.getResponsiveSize(40),
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Tombol Hapus Favorit
                Positioned(
                  top: AppResponsive.h(1),
                  right: AppResponsive.w(2),
                  child: GestureDetector(
                    onTap: () {
                      // Konfirmasi hapus
                      Get.dialog(
                        AlertDialog(
                          title: Text(
                            'Hapus dari Favorit',
                            style: AppText.h5(color: AppColors.dark),
                          ),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus ${car['carName']} dari favorit?',
                            style: AppText.p(color: AppColors.dark),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'Batal',
                                style: AppText.button(color: AppColors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.removeFavorite(car);
                                Get.back();
                                Get.snackbar(
                                  'Favorit',
                                  '${car['carName']} dihapus dari favorit',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.all(20),
                                  duration: Duration(seconds: 2),
                                );
                              },
                              child: Text(
                                'Hapus',
                                style: AppText.button(color: AppColors.danger),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: AppResponsive.padding(all: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Remix.heart_3_fill,
                        color: AppColors.danger,
                        size: AppResponsive.getResponsiveSize(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Informasi Mobil
            Padding(
              padding: AppResponsive.padding(all: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          car['carName'] as String,
                          style: AppText.h5(color: AppColors.dark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        car['year'] as String,
                        style: AppText.bodyMedium(color: AppColors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.h(0.5)),
                  Text(
                    'Rp${car['price']}',
                    style: AppText.h5thin(color: AppColors.primary),
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Remix.dashboard_3_line,
                        label: car['transmission'] as String,
                      ),
                      SizedBox(width: AppResponsive.w(2)),
                      _buildInfoChip(
                        icon: Remix.gas_station_line,
                        label: car['fuelType'] as String,
                      ),
                      SizedBox(width: AppResponsive.w(2)),
                      _buildInfoChip(
                        icon: Remix.user_3_line,
                        label: car['seats'] as String,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppResponsive.getResponsiveSize(16),
            color: AppColors.primary,
          ),
          SizedBox(width: AppResponsive.w(1)),
          Text(
            label,
            style: AppText.caption(color: AppColors.dark),
          ),
        ],
      ),
    );
  }
}