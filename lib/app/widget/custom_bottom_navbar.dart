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
      
  // Mendapatkan FavoritController dengan safe approach
  FavoritController? get _favoritController {
    try {
      return Get.find<FavoritController>();
    } catch (e) {
      // Jika controller belum diinisialisasi, buat instance baru dengan permanent: true
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
      decoration: const BoxDecoration(
        color: AppColors.primary,
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
            // Item favorit dengan badge yang reactive
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
              padding: EdgeInsets.all(AppResponsive.w(2.0)),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
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
  
  // Khusus untuk nav item favorit dengan badge yang reactive
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
                  padding: EdgeInsets.all(AppResponsive.w(2.0)),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: AppResponsive.w(5.5),
                  ),
                )
              : Icon(
                  icon,
                  size: AppResponsive.w(5.5),
                  color: Colors.grey,
                ),
                
          // Badge count yang reactive - menggunakan Obx untuk auto-update
          Obx(() {
            final controller = _favoritController;
            if (controller == null || controller.favoriteCount == 0) {
              return SizedBox.shrink();
            }
            
            return Positioned(
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
                    controller.favoriteCount > 9 
                        ? '9+' 
                        : controller.favoriteCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.getResponsiveSize(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      label: label,
    );
  }
}