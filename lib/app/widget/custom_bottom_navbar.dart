import 'package:dealer_mobil/app/modules/favorit/controllers/favorit_controller.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:dealer_mobil/app/widget/custom_bottom_navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({super.key});

  final BottomNavigationBarController navigationController =
      Get.put(BottomNavigationBarController());
      
  // Menghindari error "FavoritController not found" dengan pendekatan yang lebih aman
  FavoritController? get _favoritController {
    try {
      return Get.find<FavoritController>();
    } catch (e) {
      // Jika controller belum diinisialisasi, buat instance baru
      return Get.put(FavoritController(), permanent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationController.updateIndexBasedOnRoute(Get.currentRoute);
    });

    return Container(
      height: AppResponsive.h(8),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteOld,
      ),
      child: Obx(
        () => BottomNavigationBar(
          currentIndex: navigationController.currentIndex.value,
          onTap: (index) {
            navigationController.changePage(index);
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          selectedLabelStyle: AppText.small(color: AppColors.secondary),
          unselectedLabelStyle: AppText.small(color: Colors.grey),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          items: [
            _buildNavItem(
              context,
              icon: Remix.home_2_line,
              label: "",
              index: 0,
            ),
            _buildNavItem(
              context,
              icon: Remix.car_line,
              label: "",
              index: 1,
            ),
            // Untuk icon favorit, gunakan Obx agar bisa menampilkan badge
            _buildFavNavItem(
              context,
              icon: Remix.heart_3_line,
              label: "",
              index: 2,
            ),
            _buildNavItem(
              context,
              icon: Remix.user_2_line,
              label: "",
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = navigationController.currentIndex.value == index;

    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
              padding: EdgeInsets.all(AppResponsive.w(2.5)),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.warning,
                size: AppResponsive.w(5.5),
              ),
            )
          : Icon(
              icon,
              size: AppResponsive.w(5.5),
              color: Colors.grey,
            ),
      label: label,
    );
  }
  
  // Khusus untuk nav item favorit dengan badge
  BottomNavigationBarItem _buildFavNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = navigationController.currentIndex.value == index;

    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          isSelected
              ? Container(
                  padding: EdgeInsets.all(AppResponsive.w(2.5)),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.warning,
                    size: AppResponsive.w(5.5),
                  ),
                )
              : Icon(
                  icon,
                  size: AppResponsive.w(5.5),
                  color: Colors.grey,
                ),
                
          // Badge count - dengan pengecekan null-safety
          if (_favoritController != null && _favoritController!.favoriteCount > 0)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: EdgeInsets.all(AppResponsive.w(1)),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: AppResponsive.w(4),
                  minHeight: AppResponsive.w(4),
                ),
                child: Center(
                  child: Text(
                    _favoritController!.favoriteCount > 9 
                        ? '9+' 
                        : _favoritController!.favoriteCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.getResponsiveSize(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}