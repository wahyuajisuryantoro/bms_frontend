import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:dealer_mobil/app/widget/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/akun_controller.dart';

class AkunView extends GetView<AkunController> {
  const AkunView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              _buildMenuSection(),
              _buildLogoutButton(),
              _buildAppVersion(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
  
  // Widget untuk header profil
  Widget _buildProfileHeader() {
    return Container(
      padding: AppResponsive.padding(all: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.getResponsiveSize(30)),
          bottomRight: Radius.circular(AppResponsive.getResponsiveSize(30)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: AppResponsive.h(2)),
          // Foto profil dan badge premium
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: AppResponsive.h(14),
                width: AppResponsive.h(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppResponsive.h(14)),
                  child: Image.asset(
                    controller.userData['profileImage'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.muted,
                        child: Icon(
                          Remix.user_3_fill,
                          size: AppResponsive.h(7),
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Premium badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.3),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Remix.vip_crown_fill,
                        color: Colors.black,
                        size: AppResponsive.getResponsiveSize(16),
                      ),
                      SizedBox(width: AppResponsive.w(1)),
                      Text(
                        'PREMIUM',
                        style: AppText.caption(color: Colors.black).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(2)),
          // Nama pengguna
          Text(
            controller.userData['name'] as String,
            style: AppText.h4(color: Colors.white).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppResponsive.h(0.5)),
          // Email
          Text(
            controller.userData['email'] as String,
            style: AppText.p(color: Colors.white.withOpacity(0.9)),
          ),
          SizedBox(height: AppResponsive.h(2)),
          // Status dan statistik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                Remix.time_line,
                'Member Sejak',
                controller.userData['memberSince'] as String,
              ),
              Container(
                height: AppResponsive.h(5),
                width: 1,
                color: Colors.white.withOpacity(0.5),
              ),
              _buildStatItem(
                Remix.login_box_line,
                'Login Terakhir',
                controller.userData['lastLogin'] as String,
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(4)),
        ],
      ),
    );
  }
  
  // Widget untuk item statistik
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: AppResponsive.getResponsiveSize(20),
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        Text(
          label,
          style: AppText.caption(color: Colors.white.withOpacity(0.9)),
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        Text(
          value,
          style: AppText.bodySmall(color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  // Widget untuk bagian menu
  Widget _buildMenuSection() {
    return Container(
      margin: AppResponsive.margin(all: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppResponsive.padding(horizontal: 4, vertical: 3),
            child: Text(
              'Pengaturan & Preferensi',
              style: AppText.h5(color: AppColors.dark),
            ),
          ),
          Divider(height: 1, color: AppColors.muted),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.profileMenus.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.muted,
              indent: AppResponsive.w(16),
              endIndent: AppResponsive.w(4),
            ),
            itemBuilder: (context, index) {
              final menu = controller.profileMenus[index];
              return _buildMenuItem(
                title: menu['title'] as String,
                subtitle: menu['subtitle'] as String,
                iconName: menu['icon'] as String,
                route: menu['route'] as String,
              );
            },
          ),
        ],
      ),
    );
  }
  
  // Widget untuk item menu
  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required String iconName,
    required String route,
  }) {
    // Konversi string nama icon ke IconData
    IconData getIconFromString(String iconName) {
      switch (iconName) {
        case 'user_3_line':
          return Remix.user_3_line;
        case 'lock_password_line':
          return Remix.lock_password_line;
        case 'heart_3_line':
          return Remix.heart_3_line;
        case 'customer_service_2_line':
          return Remix.customer_service_2_line;
        case 'information_line':
          return Remix.information_line;
        case 'shield_check_line':
          return Remix.shield_check_line;
        default:
          return Remix.settings_line;
      }
    }
    
    return ListTile(
      onTap: () => controller.navigateToMenu(route),
      contentPadding: AppResponsive.padding(horizontal: 4, vertical: 0.5),
      leading: Container(
        padding: AppResponsive.padding(all: 2.5),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
        ),
        child: Icon(
          getIconFromString(iconName),
          color: AppColors.primary,
          size: AppResponsive.getResponsiveSize(22),
        ),
      ),
      title: Text(
        title,
        style: AppText.bodyLarge(color: AppColors.dark),
      ),
      subtitle: Text(
        subtitle,
        style: AppText.caption(color: AppColors.grey),
      ),
      trailing: Icon(
        Remix.arrow_right_s_line,
        color: AppColors.grey,
        size: AppResponsive.getResponsiveSize(22),
      ),
    );
  }
  
  // Widget untuk tombol logout
  Widget _buildLogoutButton() {
    return Container(
      margin: AppResponsive.margin(horizontal: 4, vertical: 2),
      child: InkWell(
        onTap: () => controller.logout(),
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
        child: Container(
          padding: AppResponsive.padding(all: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
            border: Border.all(color: AppColors.danger.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Remix.logout_box_r_line,
                color: AppColors.danger,
                size: AppResponsive.getResponsiveSize(22),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Logout',
                style: AppText.button(color: AppColors.danger),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Widget untuk versi aplikasi
  Widget _buildAppVersion() {
    return Container(
      width: double.infinity,
      padding: AppResponsive.padding(vertical: 3),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'BMS - Better Mobility Solution',
            style: AppText.bodySmall(color: AppColors.grey),
          ),
          SizedBox(height: AppResponsive.h(0.5)),
          Text(
            'Versi ${controller.appVersion}',
            style: AppText.caption(color: AppColors.grey),
          ),
          SizedBox(height: AppResponsive.h(4)),
        ],
      ),
    );
  }
}