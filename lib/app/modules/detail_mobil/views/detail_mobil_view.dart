import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/detail_mobil_controller.dart';

class DetailMobilView extends GetView<DetailMobilController> {
  const DetailMobilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi AppResponsive
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: GetBuilder<DetailMobilController>(
          builder: (_) => controller.car.isEmpty
              ? Center(child: CircularProgressIndicator())
              : _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Obx(() {
                final imagePath = controller.selectedImage.value.isNotEmpty
                    ? controller.selectedImage.value
                    : (controller.galleryImages.isNotEmpty
                        ? controller.galleryImages[0]
                        : '');

                return ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom:
                        Radius.circular(AppResponsive.getResponsiveSize(20)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      final int currentIndex = controller.galleryImages
                          .indexOf(controller.selectedImage.value);
                      _showFullScreenImage(context, controller.galleryImages,
                          currentIndex >= 0 ? currentIndex : 0);
                    },
                    child: Container(
                      width: double.infinity,
                      height: AppResponsive.h(30),
                      child: imagePath.isNotEmpty
                          ? Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
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
                            )
                          : Container(
                              color: AppColors.muted,
                              child: Center(
                                child: Icon(
                                  Remix.image_line,
                                  size: AppResponsive.getResponsiveSize(40),
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              }),

              // Tombol kembali
              Positioned(
                top: AppResponsive.h(2),
                left: AppResponsive.w(4),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: AppResponsive.padding(all: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppResponsive.getResponsiveSize(8)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Remix.arrow_left_line,
                      color: AppColors.dark,
                      size: AppResponsive.getResponsiveSize(24),
                    ),
                  ),
                ),
              ),

              // Favorit
              Positioned(
                top: AppResponsive.h(2),
                right: AppResponsive.w(4),
                child: GestureDetector(
                  onTap: () => controller.toggleFavorite(),
                  child: Obx(() => Container(
                        padding:
                            AppResponsive.padding(horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(8)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          controller.isFavorite.value
                              ? Remix.heart_3_fill
                              : Remix.heart_2_line,
                          color: controller.isFavorite.value
                              ? AppColors.danger
                              : AppColors.dark,
                          size: AppResponsive.getResponsiveSize(25),
                        ),
                      )),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(4),
            height: AppResponsive.h(8),
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: AppResponsive.padding(horizontal: 4),
                  itemCount: controller.galleryImages.length,
                  itemBuilder: (context, index) {
                    final imagePath = controller.galleryImages[index];
                    final bool isSelected =
                        controller.selectedImage.value == imagePath;

                    return GestureDetector(
                      onTap: () {
                        controller.setSelectedImage(imagePath);
                      },
                      child: Container(
                        width: AppResponsive.w(16),
                        height: AppResponsive.h(6),
                        margin: AppResponsive.margin(horizontal: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(8)),
                          border: Border.all(
                            color:
                                isSelected ? AppColors.primary : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(6)),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.muted,
                                child: Icon(
                                  Remix.image_line,
                                  size: AppResponsive.getResponsiveSize(20),
                                  color: AppColors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
          // Informasi utama mobil
          Container(
            padding: AppResponsive.padding(all: 4),
            decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.car['carName'] as String,
                            style: AppText.h4(color: AppColors.dark),
                          ),
                          SizedBox(height: AppResponsive.h(0.5)),
                          Text(
                            'Diproduksi oleh ${controller.car['logoName']}, Inc.',
                            style: AppText.bodyMedium(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      controller.brands.firstWhere(
                        (brand) => brand['name'] == controller.car['logoName'],
                        orElse: () =>
                            {'image': 'assets/images/default_logo.png'},
                      )['image'] as String,
                      width: AppResponsive.w(10),
                      height: AppResponsive.h(6),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: AppResponsive.w(10),
                          height: AppResponsive.h(6),
                          color: AppColors.muted,
                          child: Icon(
                            Remix.image_line,
                            color: AppColors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(3)),

                // Deskripsi
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi',
                      style: AppText.h5(color: AppColors.dark),
                    ),
                    SizedBox(height: AppResponsive.h(1)),
                    Text(
                      controller.car['description'],
                      style: AppText.p(color: AppColors.dark),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(3)),

                // // Fitur
                // Text(
                //   'Fitur',
                //   style: AppText.h5(color: AppColors.dark),
                // ),
                // SizedBox(height: AppResponsive.h(2)),

                // // Feature Icons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     _buildFeatureItem(
                //       icon: Icons.airline_seat_recline_normal,
                //       label: 'Kapasitas',
                //       value: controller.car['seats'],
                //     ),
                //     _buildFeatureItem(
                //       icon: Icons.speed,
                //       label: 'Kecepatan',
                //       value: '200 KM/H',
                //     ),
                //     _buildFeatureItem(
                //       icon: Icons.power,
                //       label: 'Tenaga',
                //       value: controller.car['horsePower'],
                //     ),
                //   ],
                // ),

                SizedBox(height: AppResponsive.h(4)),

                // Specification section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Remix.dashboard_3_line,
                          color: AppColors.primary,
                          size: AppResponsive.getResponsiveSize(22),
                        ),
                        SizedBox(width: AppResponsive.w(2)),
                        Text(
                          'Spesifikasi',
                          style: AppText.h5(color: AppColors.dark),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.muted),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: AppResponsive.w(2),
                      mainAxisSpacing: AppResponsive.h(2),
                      children: [
                        _buildSpecItem(
                          icon: Remix.car_fill,
                          label: 'Merek',
                          value: controller.car['logoName'],
                        ),
                        _buildSpecItem(
                          icon: Remix.steering_2_fill,
                          label: 'Model',
                          value: controller.car['carName']
                              .toString()
                              .split(' ')
                              .last,
                        ),
                        _buildSpecItem(
                          icon: Remix.calendar_fill,
                          label: 'Tahun',
                          value: controller.car['year'],
                        ),
                        _buildSpecItem(
                          icon: Remix.shape_fill,
                          label: 'Tipe Bodi',
                          value: controller.car['bodyType'],
                        ),
                        _buildSpecItem(
                          icon: Remix.settings_3_fill,
                          label: 'Transmisi',
                          value: controller.car['transmission'],
                        ),
                        _buildSpecItem(
                          icon: Remix.device_fill,
                          label: 'Mesin',
                          value: controller.car['engineCapacity'],
                        ),
                        // _buildSpecItem(
                        //   icon: Remix.flashlight_fill,
                        //   label: 'Tenaga',
                        //   value: controller.car['horsePower'],
                        // ),
                        _buildSpecItem(
                          icon: Remix.user_3_fill,
                          label: 'Kapasitas',
                          value: controller.car['seats'],
                        ),
                        _buildSpecItem(
                          icon: Remix.paint_fill,
                          label: 'Warna',
                          value: controller.car['color'],
                        ),
                        _buildSpecItem(
                          icon: Remix.gas_station_fill,
                          label: 'Bahan Bakar',
                          value: controller.car['fuelType'],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(5)),

                // Price and Buy Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp${controller.car['price']}',
                      style: AppText.h5(color: AppColors.dark),
                    ),
                    SizedBox(
                      height: AppResponsive.h(6),
                      child: ElevatedButton(
                        onPressed: controller.buyNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(10),
                            ),
                          ),
                        ),
                        child: Text(
                          'Hubungi Sekarang',
                          style: AppText.button(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: AppResponsive.padding(all: 2),
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius:
                BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppResponsive.getResponsiveSize(24),
          ),
        ),
        SizedBox(height: AppResponsive.h(1)),
        Text(
          label,
          style: AppText.caption(color: AppColors.grey),
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        Text(
          value,
          style: AppText.bodySmall(color: AppColors.dark),
        ),
      ],
    );
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: AppResponsive.padding(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
        border: Border.all(color: AppColors.muted),
      ),
      child: Row(
        children: [
          Container(
            padding: AppResponsive.padding(all: 0.8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(AppResponsive.getResponsiveSize(6)),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(14),
            ),
          ),
          SizedBox(width: AppResponsive.w(1.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppText.caption(color: AppColors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppText.bodySmall(color: AppColors.dark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Gallery Viewer
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: AssetImage(images[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                itemCount: images.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(color: Colors.black),
                pageController: PageController(initialPage: initialIndex),
              ),

              // Close Button
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Remix.close_line,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
