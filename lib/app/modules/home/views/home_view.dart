import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/widget/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Remix.map_pin_2_line,
                            color: AppColors.primary, size: 20),
                        SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: AppText.small(color: AppColors.grey),
                            ),
                            Text(
                              'Bali, Indonesia',
                              style: AppText.pSmall(color: AppColors.dark),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Selamat Datang',
                  style: AppText.h3(color: AppColors.dark),
                ),
                Text(
                  'Alexander Jonathan',
                  style: AppText.h4(color: AppColors.dark),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteOld,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.search, color: AppColors.grey, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Search car type...',
                            style: AppText.p(color: AppColors.grey),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Remix.equalizer_line,
                            color: AppColors.dark, size: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih berdasarkan brands',
                      style: AppText.h6(color: AppColors.dark),
                    ),
                    Row(
                      children: [
                        Icon(Remix.arrow_right_line,
                            color: AppColors.dark, size: 20),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(2)),
                Container(
                  height: 110,
                  child: Obx(() => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.brands.length,
                        itemBuilder: (context, index) {
                          final String image =
                              controller.brands[index]['image'] as String;
                          final String name =
                              controller.brands[index]['name'] as String;

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildBrandLogo(image, name),
                          );
                        },
                      )),
                ),
                SizedBox(height: AppResponsive.h(2)),
                Text(
                  'Pilih berdasarkan transmisi',
                  style: AppText.h6(color: AppColors.dark),
                ),
                SizedBox(height: AppResponsive.h(2)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTransmissionOption('Automatic', true),
                      SizedBox(width: 12),
                      _buildTransmissionOption('Electric', false),
                      SizedBox(width: 12),
                      _buildTransmissionOption('Manual', false),
                      SizedBox(width: 12),
                      _buildTransmissionOption('CV', false),
                    ],
                  ),
                ),
                SizedBox(height: AppResponsive.h(3)),
                buildCarListingsSlider(),
                SizedBox(height: AppResponsive.h(2)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildBrandLogo(String imagePath, String brandName) {
    return Container(
      width: Get.width * 0.27,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 40,
            width: 40,
          ),
          SizedBox(height: 8),
          Text(
            brandName,
            style: AppText.pSmall(color: AppColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _buildTransmissionOption(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.warning : AppColors.whiteOld,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: AppText.pSmall(color: AppColors.dark),
      ),
    );
  }

  Widget _buildCarListing(
    String imagePath,
    String logoName,
    String carName,
    String price,
    String horsePower,
    String transmission,
    String seats,
    Map<String, dynamic> car
  ) {
    return InkWell(
      onTap: (){
        Get.toNamed(Routes.DETAIL_MOBIL, arguments: car);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.whiteOld,
                            child: Image.asset(
                              'assets/images/${logoName.toLowerCase().split(' ')[0]}.png',
                              width: 16,
                              height: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            logoName,
                            style: AppText.small(color: AppColors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '\Rp${price}',
                            style: AppText.h5(color: AppColors.dark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    carName,
                    style: AppText.h6(color: AppColors.dark),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Remix.dashboard_3_line,
                              size: 16, color: AppColors.dark),
                          SizedBox(width: 4),
                          Text(
                            horsePower,
                            style: AppText.small(color: AppColors.dark),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Remix.steering_2_line,
                              size: 16, color: AppColors.dark),
                          SizedBox(width: 4),
                          Text(
                            transmission,
                            style: AppText.small(color: AppColors.dark),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Remix.user_3_line,
                              size: 16, color: AppColors.dark),
                          SizedBox(width: 4),
                          Text(
                            seats,
                            style: AppText.small(color: AppColors.dark),
                          ),
                        ],
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

  Widget buildCarListingsSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mobil Terlaris',
              style: AppText.h6(color: AppColors.dark),
            ),
            Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: AppText.small(color: AppColors.grey),
                ),
                SizedBox(width: 4),
                Icon(Remix.arrow_right_line, color: AppColors.dark, size: 18),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 300,
          child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.carListings.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final car = controller.carListings[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: Container(
                      width: Get.width * 0.7,
                      child: _buildCarListing(
                        car['image'] as String,
                        car['logoName'] as String,
                        car['carName'] as String,
                        car['price'] as String,
                        car['horsePower'] as String,
                        car['transmission'] as String,
                        car['seats'] as String,
                        car
                      ),
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }
}
