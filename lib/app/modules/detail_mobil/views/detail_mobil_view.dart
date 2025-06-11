import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dealer_mobil/app/components/loading_animation.dart';
import 'package:dealer_mobil/app/helpers/currency_formatter.dart';
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
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
                child: AnimationLoading.container(
              height: 100,
            ));
          }

          if (controller.isError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.danger,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: AppText.h5(color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          if (controller.car.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data mobil',
                style: AppText.h5(color: AppColors.grey),
              ),
            );
          }

          return _buildContent(context);
        }),
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
                          ? CachedNetworkImage(
                              imageUrl: imagePath,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.muted,
                                child: Center(
                                  child: Icon(
                                    Remix.image_line,
                                    size: AppResponsive.getResponsiveSize(40),
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                              memCacheWidth: 800,
                              memCacheHeight: 600,
                              maxWidthDiskCache: 1500,
                              fadeOutDuration: Duration(milliseconds: 300),
                              fadeInDuration: Duration(milliseconds: 300),
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
              Positioned(
                top: AppResponsive.h(2),
                right: AppResponsive.w(4),
                child: Obx(() => GestureDetector(
                      onTap: controller.isLoadingFavorite.value
                          ? null
                          : controller.toggleFavorite,
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
                        child: controller.isLoadingFavorite.value
                            ? SizedBox(
                                width: AppResponsive.getResponsiveSize(24),
                                height: AppResponsive.getResponsiveSize(24),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                ),
                              )
                            : Icon(
                                controller.isFavorite.value
                                    ? Remix.heart_fill
                                    : Remix.heart_line,
                                color: controller.isFavorite.value
                                    ? AppColors.danger
                                    : AppColors.dark,
                                size: AppResponsive.getResponsiveSize(24),
                              ),
                      ),
                    )),
              ),
            ],
          ),
          if (controller.galleryImages.length > 1)
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
                              child: CachedNetworkImage(
                                imageUrl: imagePath,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.muted.withOpacity(0.3),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.primary),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.muted,
                                  child: Icon(
                                    Remix.image_line,
                                    size: AppResponsive.getResponsiveSize(20),
                                    color: AppColors.grey,
                                  ),
                                ),
                              )),
                        ),
                      );
                    },
                  )),
            ),
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
                            controller.car['nama_mobil'] ?? 'Nama Mobil',
                            style: AppText.h4(color: AppColors.dark),
                          ),
                          SizedBox(height: AppResponsive.h(0.5)),
                          Text(
                            'Diproduksi oleh ${controller.car['merk'] ?? 'Unknown'}',
                            style: AppText.bodyMedium(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (controller.car['foto_merk'] != null)
                      Image.network(
                        controller.car['foto_merk'],
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
                if (controller.car['deskripsi'] != null &&
                    controller.car['deskripsi'].toString().isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi',
                        style: AppText.h5(color: AppColors.dark),
                      ),
                      SizedBox(height: AppResponsive.h(1)),
                      Text(
                        controller.car['deskripsi'],
                        style: AppText.p(color: AppColors.dark),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: AppResponsive.h(3)),
                    ],
                  ),
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
                          value: controller.car['merk'] ?? '-',
                        ),
                        _buildSpecItem(
                          icon: Remix.steering_2_fill,
                          label: 'Model',
                          value: controller.car['nama_mobil'] ?? '-',
                        ),
                        _buildSpecItem(
                          icon: Remix.calendar_fill,
                          label: 'Tahun',
                          value: controller.car['tahun_keluaran']?.toString() ??
                              '-',
                        ),
                        _buildSpecItem(
                          icon: Remix.shape_fill,
                          label: 'Tipe Bodi',
                          value: controller.car['tipe_bodi'] ?? '-',
                        ),
                        _buildSpecItem(
                          icon: Remix.settings_3_fill,
                          label: 'Transmisi',
                          value: controller.car['transmisi'] ?? '-',
                        ),
                        _buildSpecItem(
                          icon: Remix.device_fill,
                          label: 'Mesin',
                          value:
                              "${controller.car['kapasitas_mesin'] ?? '-'} cc",
                        ),
                        _buildSpecItem(
                          icon: Remix.paint_fill,
                          label: 'Warna',
                          value: controller.car['warna'] is List
                              ? (controller.car['warna'] as List).join(', ')
                              : (controller.car['warna']?.toString() ?? '-'),
                        ),
                        _buildSpecItem(
                          icon: Remix.gas_station_fill,
                          label: 'Bahan Bakar',
                          value: controller.car['bahan_bakar'] ?? '-',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(5)),
                
                // Updated Opsi Pembayaran Section
                _buildOpsiPembayaranSection(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga Cash',
                          style: AppText.bodyMedium(color: AppColors.grey),
                        ),
                        Text(
                          controller.getFormattedPrice(),
                          style: AppText.h5(color: AppColors.dark),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: AppResponsive.h(21),
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
                          style: AppText.bodyMediumBold(color: Colors.white),
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

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required dynamic value,
  }) {
    String displayValue;

    if (value is List) {
      displayValue = value.join(', ');
    } else if (value is Map) {
      displayValue = value.toString();
    } else {
      displayValue = value?.toString() ?? '-';
    }

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
                  displayValue,
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

  Widget _buildOpsiPembayaranSection() {
    // Check if opsi_kredit is available
    final bool hasKreditOption = controller.car.containsKey('opsi_kredit') && 
                                controller.car['opsi_kredit'] != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Remix.money_dollar_circle_line,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(22),
            ),
            SizedBox(width: AppResponsive.w(2)),
            Text(
              'Opsi Pembayaran',
              style: AppText.h5(color: AppColors.dark),
            ),
          ],
        ),
        Divider(color: AppColors.muted),
        
        // Cash Option
        _buildPaymentOptionCard(
          title: 'Pembayaran Cash',
          subtitle: 'Bayar langsung tanpa cicilan',
          price: controller.getFormattedPrice(),
          icon: Remix.money_dollar_circle_fill,
          iconColor: AppColors.success,
          isRecommended: false,
        ),
        
        SizedBox(height: AppResponsive.h(2)),
        
        // Credit Option (if available)
        if (hasKreditOption) ...[
          _buildPaymentOptionCard(
            title: 'Pembayaran Kredit',
            subtitle: controller.car['opsi_kredit']['nama_template'] ?? 'Paket Kredit Tersedia',
            price: 'Mulai dari simulasi kredit',
            icon: Remix.bank_card_fill,
            iconColor: AppColors.primary,
            isRecommended: true,
            kreditInfo: controller.car['opsi_kredit'],
          ),
          
          SizedBox(height: AppResponsive.h(3)),
          _buildSimulasiKreditSection(),
        ] else ...[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.muted),
            ),
            child: Row(
              children: [
                Icon(
                  Remix.information_line,
                  color: AppColors.grey,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Opsi kredit tidak tersedia untuk mobil ini',
                    style: AppText.bodyMedium(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        SizedBox(height: AppResponsive.h(3)),
      ],
    );
  }

  Widget _buildPaymentOptionCard({
    required String title,
    required String subtitle,
    required String price,
    required IconData icon,
    required Color iconColor,
    required bool isRecommended,
    Map<String, dynamic>? kreditInfo,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? AppColors.primary : AppColors.muted,
          width: isRecommended ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppText.bodyMediumBold(color: AppColors.dark),
                        ),
                        if (isRecommended) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Direkomendasikan',
                              style: AppText.caption(color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppText.bodySmall(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          Text(
            price,
            style: AppText.h6(color: AppColors.dark),
          ),
          
          // Additional info for credit option
          if (kreditInfo != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (kreditInfo.containsKey('tenor_tersedia') && 
                      kreditInfo['tenor_tersedia'] is List) ...[
                    Text(
                      'Tenor tersedia: ${(kreditInfo['tenor_tersedia'] as List).join(', ')} bulan',
                      style: AppText.bodySmall(color: AppColors.primary),
                    ),
                  ],
                  if (kreditInfo.containsKey('dp_minimal_percentage')) ...[
                    Text(
                      'DP minimal: ${kreditInfo['dp_minimal_percentage']}% dari harga mobil',
                      style: AppText.bodySmall(color: AppColors.primary),
                    ),
                  ],
                ],
              ),
            ),
          ],
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
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      images[index],
                      maxWidth: 2000,
                      maxHeight: 2000,
                    ),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2.5,
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: "image_$index"),
                    filterQuality: FilterQuality.high,
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
                onPageChanged: (index) {},
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(30),
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
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${initialIndex + 1}/${images.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildSimulasiKreditSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Remix.calculator_line,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(22),
            ),
            SizedBox(width: AppResponsive.w(2)),
            Text(
              'Simulasi Kredit',
              style: AppText.h5(color: AppColors.dark),
            ),
          ],
        ),
        Divider(color: AppColors.muted),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: controller.toggleSimulasiExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Klik untuk menghitung simulasi kredit',
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                  ),
                  Obx(() => Icon(
                        controller.isSimulasiExpanded.value
                            ? Remix.arrow_up_s_line
                            : Remix.arrow_down_s_line,
                        color: AppColors.primary,
                      )),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          if (!controller.isSimulasiExpanded.value) {
            return SizedBox.shrink();
          }

          if (controller.isLoadingSimulasi.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: AnimationLoading.container(height: 80),
              ),
            );
          }

          if (controller.isSimulasiError.value) {
            return _buildErrorWidget();
          }

          return controller.hasilSimulasi.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Pilih tenor dan DP untuk melihat simulasi kredit',
                      style: AppText.bodySmall(color: AppColors.grey),
                    ),
                  ),
                )
              : _buildSimulasiData();
        }),
      ],
    );
  }

  Widget _buildSimulasiData() {
    final simulasi = controller.hasilSimulasi;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Tenor',
            style: AppText.bodyMediumBold(color: AppColors.dark),
          ),
          SizedBox(height: 8),
          _buildTenorOptions(),
          SizedBox(height: 16),
          Text(
            'Masukkan DP',
            style: AppText.bodyMediumBold(color: AppColors.dark),
          ),
          SizedBox(height: 8),
          _buildDpInput(),
          SizedBox(height: 24),
          _buildInfoCard(
            title: 'Harga OTR',
            value: CurrencyFormatter.formatRupiah(simulasi['harga_otr'] ?? 0),
            icon: Remix.price_tag_3_line,
            iconColor: AppColors.primary,
          ),
          SizedBox(height: 12),
          _buildInfoCard(
            title: 'Total DP (${controller.getDpPercentage().toStringAsFixed(1)}%)',
            value: CurrencyFormatter.formatRupiah(simulasi['dp_amount'] ?? 0),
            icon: Remix.money_dollar_circle_line,
            iconColor: AppColors.success,
          ),
          SizedBox(height: 12),
          _buildInfoCard(
            title: 'Angsuran per Bulan',
            value: CurrencyFormatter.formatRupiah(
                simulasi['angsuran_per_bulan'] ?? 0),
            icon: Remix.money_dollar_box_line,
            iconColor: AppColors.info,
          ),
          SizedBox(height: 12),
          _buildInfoCard(
            title: 'Tenor',
            value:
                '${simulasi['tenor'] ?? 0} bulan (${(simulasi['tenor'] ?? 0) ~/ 12} tahun)',
            icon: Remix.time_line,
            iconColor: AppColors.warning,
          ),
    
        ],
      ),
    );
  }

  Widget _buildTenorOptions() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.tenorOptions.length,
        itemBuilder: (context, index) {
          final option = controller.tenorOptions[index];
          final isSelected = controller.selectedTenor.value == option['tenor'];

          return GestureDetector(
            onTap: () => controller.changeTenor(option['tenor']),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.muted,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                option['label'],
                style: AppText.bodySmall(
                  color: isSelected ? Colors.white : AppColors.dark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// Update _buildDpInput method di DetailMobilView.dart untuk parsing yang benar
// Update UI _buildDpInput untuk trigger yang lebih santai

Widget _buildDpInput() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.muted),
        ),
        child: Row(
          children: [
            Text(
              'Rp',
              style: AppText.bodyMedium(color: AppColors.dark),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.dpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah DP',
                  border: InputBorder.none,
                  hintStyle: AppText.bodySmall(color: AppColors.grey),
                ),
                style: AppText.bodyMedium(color: AppColors.dark),
                onChanged: (value) {
                  // Format input dengan pemisah ribuan
                  String formatted = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (formatted.isNotEmpty) {
                    try {
                      final number = int.parse(formatted);
                      final formattedText = number.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      );
                      
                      if (formattedText != value) {
                        controller.dpController.value = TextEditingValue(
                          text: formattedText,
                          selection: TextSelection.collapsed(offset: formattedText.length),
                        );
                      }
                      
                      final cleanValue = formatted;
                      final amount = controller.parseToDouble(cleanValue);
                      controller.selectedDpAmount.value = amount;

                      
                    } catch (e) {
                      print('Error formatting number: $e');
                    }
                  } else {

                    controller.selectedDpAmount.value = 0.0;
                  }
                },
                onFieldSubmitted: (value) {
                  // Trigger hanya saat user tekan Enter dan input valid
                  final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  final amount = controller.parseToDouble(cleanValue);
                  if (amount > 0 && controller.selectedTenor.value > 0) {
                    controller.hitungSimulasiKredit();
                  }
                },
              ),
            ),
            // Tombol untuk trigger manual
            IconButton(
              onPressed: () {
                controller.triggerSimulasiKredit();
              },
              icon: Icon(
                Remix.calculator_line,
                color: AppColors.primary,
                size: 20,
              ),
              tooltip: 'Hitung Simulasi',
            ),
          ],
        ),
      ),
      SizedBox(height: 8),
      Obx(() => controller.dpValidationInfo.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilihan Cepat:',
                  style: AppText.caption(color: AppColors.grey),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [10, 15, 20, 25, 30].map((percentage) {
                    final hargaOtrRaw = controller.dpValidationInfo['harga_otr'];
                    final hargaOtr = controller.parseToDouble(hargaOtrRaw);
                    final amount = (hargaOtr * percentage) / 100;
                    final isSelected = (controller.selectedDpAmount.value - amount).abs() < 1000;
                    
                    return GestureDetector(
                      onTap: () {
                        controller.selectedDpAmount.value = amount;
                        try {
                          controller.dpController.text = amount.toInt().toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]}.',
                          );
                          if (controller.selectedTenor.value > 0) {
                            controller.hitungSimulasiKredit();
                          }
                        } catch (e) {
                          print('Error setting DP amount: $e');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.muted,
                          ),
                        ),
                        child: Text(
                          '$percentage%',
                          style: AppText.bodySmall(
                            color: isSelected ? Colors.white : AppColors.dark,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          : SizedBox.shrink()),
      
      SizedBox(height: 16),
      
      // Manual trigger button (primary way to calculate)
      Center(
        child: Obx(() => ElevatedButton.icon(
              onPressed: controller.isLoadingSimulasi.value 
                  ? null 
                  : () {
                      if (controller.selectedTenor.value > 0 && controller.selectedDpAmount.value > 0) {
                        controller.hitungSimulasiKredit();
                      } else {
                        Get.snackbar(
                          'Info',
                          'Silakan pilih tenor dan masukkan jumlah DP terlebih dahulu',
                          backgroundColor: AppColors.info,
                          colorText: Colors.white,
                          duration: Duration(seconds: 2),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: controller.isLoadingSimulasi.value
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      Remix.calculator_line,
                      color: Colors.white,
                      size: 18,
                    ),
              label: Text(
                controller.isLoadingSimulasi.value 
                    ? 'Menghitung...' 
                    : 'Hitung Simulasi Kredit',
                style: AppText.bodyMedium(color: Colors.white),
              ),
            )),
      ),
    ],
  );
}

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.muted.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.caption(color: AppColors.grey),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppText.bodyMediumBold(color: AppColors.dark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(
            Remix.error_warning_line,
            size: 40,
            color: AppColors.danger,
          ),
          SizedBox(height: 12),
          Text(
            controller.simulasiErrorMessage.value,
            textAlign: TextAlign.center,
            style: AppText.bodyMedium(color: AppColors.dark),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.hitungSimulasiKredit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Coba Lagi',
              style: AppText.bodyMedium(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}