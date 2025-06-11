import 'package:dealer_mobil/app/base_url/base_url.dart';
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
        child: Obx(() {
          if (controller.userData.isEmpty || controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.refreshUserData();
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

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
          Obx(() {
            final photoUrl = controller.userData['photo_url']?.toString() ?? '';
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: AppResponsive.h(14),
                  width: AppResponsive.h(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.muted,
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
                    image: photoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              print('Error loading photo_url: $exception');
                            },
                          )
                        : null,
                  ),
                  child: photoUrl.isEmpty
                      ? Icon(
                          Remix.user_3_fill,
                          size: AppResponsive.h(7),
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            );
          }),
          SizedBox(height: AppResponsive.h(2)),
          Obx(() {
            final name = controller.userData['name']?.toString() ?? 'User';
            return Text(
              name,
              style: AppText.h4(color: Colors.white).copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          }),
          SizedBox(height: AppResponsive.h(0.5)),
          Obx(() {
            final email = controller.userData['email']?.toString() ?? '';
            return Text(
              email,
              style: AppText.p(color: Colors.white.withOpacity(0.9)),
              textAlign: TextAlign.center,
            );
          }),
          Obx(() {
            final phone = controller.userData['no_wa']?.toString() ?? '';
            if (phone.isNotEmpty) {
              return Column(
                children: [
                  SizedBox(height: AppResponsive.h(0.5)),
                  Text(
                    phone,
                    style:
                        AppText.bodySmall(color: Colors.white.withOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          }),
          Obx(() {
            final dusun = controller.userData['dusun']?.toString() ?? '';
            if (dusun.isNotEmpty) {
              return Column(
                children: [
                  SizedBox(height: AppResponsive.h(0.5)),
                  Text(
                    'Dusun $dusun',
                    style:
                        AppText.bodySmall(color: Colors.white.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          }),
          SizedBox(height: AppResponsive.h(2)),
          Obx(() {
            final createdAt = controller.userData['created_at'];
            final kodePos = controller.userData['kode_pos']?.toString() ?? '';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  Remix.time_line,
                  'Member Sejak',
                  createdAt != null
                      ? _formatMemberSince(createdAt.toString())
                      : 'N/A',
                ),
                Container(
                  height: AppResponsive.h(5),
                  width: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                _buildStatItem(
                  Remix.map_pin_line,
                  'Kode Pos',
                  kodePos.isNotEmpty ? kodePos : 'N/A',
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatMemberSince(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

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
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        Text(
          value,
          style: AppText.bodySmall(color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: AppResponsive.margin(all: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
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
            child: Row(
              children: [
                Icon(
                  Remix.settings_3_line,
                  color: AppColors.primary,
                  size: AppResponsive.getResponsiveSize(20),
                ),
                SizedBox(width: AppResponsive.w(2)),
                Text(
                  'Pengaturan & Preferensi',
                  style: AppText.h5(color: AppColors.dark),
                ),
              ],
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

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required String iconName,
    required String route,
  }) {
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
        padding: AppResponsive.padding(all: 2),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
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

  Widget _buildLogoutButton() {
    return Container(
      margin: AppResponsive.margin(horizontal: 4, vertical: 2),
      child: Obx(() => InkWell(
            onTap: controller.isLoggingOut.value
                ? null
                : () => controller.logout(),
            borderRadius:
                BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: AppResponsive.padding(all: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
                border: Border.all(
                    color: controller.isLoggingOut.value
                        ? AppColors.grey.withOpacity(0.5)
                        : AppColors.danger.withOpacity(0.5),
                    width: 1),
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
                  if (controller.isLoggingOut.value)
                    SizedBox(
                      width: AppResponsive.getResponsiveSize(22),
                      height: AppResponsive.getResponsiveSize(22),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.danger),
                      ),
                    )
                  else
                    Icon(
                      Remix.logout_box_r_line,
                      color: AppColors.danger,
                      size: AppResponsive.getResponsiveSize(22),
                    ),
                  SizedBox(width: AppResponsive.w(2)),
                  Text(
                    controller.isLoggingOut.value ? 'Logging out...' : 'Logout',
                    style: AppText.button(
                        color: controller.isLoggingOut.value
                            ? AppColors.grey
                            : AppColors.danger),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildAppVersion() {
    return Container(
      width: double.infinity,
      padding: AppResponsive.padding(vertical: 3),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'BMS - Bursa Mobil Solo',
            style: AppText.bodySmall(color: AppColors.grey),
          ),
          SizedBox(height: AppResponsive.h(0.5)),
          Obx(() {
            return Text(
              'Versi ${controller.appVersion.value}',
              style: AppText.caption(color: AppColors.grey),
            );
          }),
          SizedBox(height: AppResponsive.h(1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: controller.isUserLoggedIn
                      ? AppColors.success
                      : AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                controller.isUserLoggedIn ? 'Online' : 'Offline',
                style: AppText.caption(color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(4)),
        ],
      ),
    );
  }
}
