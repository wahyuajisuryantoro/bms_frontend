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
                if (controller.car.containsKey('opsi_pembayaran') &&
                    controller.car['opsi_pembayaran'] != null &&
                    (controller.car['opsi_pembayaran'] as List).isNotEmpty)
                  Column(
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            (controller.car['opsi_pembayaran'] as List).length,
                        itemBuilder: (context, index) {
                          final opsi = (controller.car['opsi_pembayaran']
                              as List)[index];
                          return _buildOpsiPembayaranItem(opsi);
                        },
                      ),
                      SizedBox(height: AppResponsive.h(3)),
                      _buildSimulasiKreditSection(),
                      SizedBox(height: AppResponsive.h(3)),
                    ],
                  ),
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

  Widget _buildOpsiPembayaranItem(Map<String, dynamic> opsi) {
    final String metode = opsi['metode'] ?? '';

    final dynamic hargaRaw = opsi['harga'] ?? 0;
    final num harga =
        hargaRaw is String ? num.tryParse(hargaRaw) ?? 0 : (hargaRaw as num);

    final dynamic tenorRaw = opsi['tenor'];
    final int? tenor = tenorRaw == null
        ? null
        : (tenorRaw is String ? int.tryParse(tenorRaw) : (tenorRaw as int));

    final dynamic dpMinimalRaw = opsi['dp_minimal'];
    final num? dpMinimal = dpMinimalRaw == null
        ? null
        : (dpMinimalRaw is String
            ? num.tryParse(dpMinimalRaw)
            : (dpMinimalRaw as num));

    final dynamic angsuranPerBulanRaw = opsi['angsuran_per_bulan'];
    final num? angsuranPerBulan = angsuranPerBulanRaw == null
        ? null
        : (angsuranPerBulanRaw is String
            ? num.tryParse(angsuranPerBulanRaw)
            : (angsuranPerBulanRaw as num));

    return Container(
      margin: AppResponsive.margin(vertical: 1),
      padding: AppResponsive.padding(all: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
        border: Border.all(color: AppColors.muted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
                decoration: BoxDecoration(
                  color: metode == 'Cash'
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.success.withOpacity(0.2),
                  borderRadius:
                      BorderRadius.circular(AppResponsive.getResponsiveSize(4)),
                ),
                child: Text(
                  metode,
                  style: AppText.caption(
                    color: metode == 'Cash'
                        ? AppColors.primary
                        : AppColors.success,
                  ),
                ),
              ),
              if (tenor != null)
                Container(
                  padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                        AppResponsive.getResponsiveSize(4)),
                  ),
                  child: Text(
                    '$tenor bulan',
                    style: AppText.caption(
                      color: AppColors.info,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppResponsive.h(1)),
          if (metode == 'Cash')
            Text(
              CurrencyFormatter.formatRupiah(harga),
              style: AppText.bodyMedium(color: AppColors.dark),
            ),
          if (metode != 'Cash') ...[
            if (dpMinimal != null && dpMinimal > 0)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'DP Minimal: ${CurrencyFormatter.formatRupiah(dpMinimal)}',
                  style: AppText.bodySmall(color: AppColors.dark),
                ),
              ),
            if (angsuranPerBulan != null && angsuranPerBulan > 0)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Angsuran: ${CurrencyFormatter.formatRupiah(angsuranPerBulan)}/bulan',
                  style: AppText.bodySmall(color: AppColors.dark),
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
            'Pilih DP',
            style: AppText.bodyMediumBold(color: AppColors.dark),
          ),
          SizedBox(height: 8),
          _buildDpOptions(),
          SizedBox(height: 24),
          _buildInfoCard(
            title: 'Harga OTR',
            value: CurrencyFormatter.formatRupiah(simulasi['harga_otr'] ?? 0),
            icon: Remix.price_tag_3_line,
            iconColor: AppColors.primary,
          ),
          SizedBox(height: 12),
          _buildInfoCard(
            title: 'Total DP',
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
          SizedBox(height: 12),
          _buildInfoCard(
            title: 'Bunga',
            value: '${simulasi['bunga_tahunan'] ?? 0}% per tahun',
            icon: Remix.percent_line,
            iconColor: AppColors.danger,
          ),
          SizedBox(height: 24),
          if (simulasi.containsKey('rincian_angsuran') &&
              simulasi['rincian_angsuran'] is List &&
              (simulasi['rincian_angsuran'] as List).isNotEmpty) ...[
            Text(
              'Rincian Angsuran (Bulan 1-12)',
              style: AppText.bodyMediumBold(color: AppColors.dark),
            ),
            SizedBox(height: 8),
            _buildRincianAngsuranTable(simulasi['rincian_angsuran']),
            SizedBox(height: 16),
            Text(
              'Catatan: Bunga dihitung dengan metode anuitas',
              style: AppText.caption(color: AppColors.grey),
            ),
          ],
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Ajukan Kredit',
                  'Fitur ini akan menghubungkan Anda dengan dealer',
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: EdgeInsets.all(20),
                  duration: Duration(seconds: 2),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ajukan Kredit Sekarang',
                style: AppText.bodyMediumBold(color: Colors.white),
              ),
            ),
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

  Widget _buildDpOptions() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.dpOptions.length,
        itemBuilder: (context, index) {
          final option = controller.dpOptions[index];
          final isSelected =
              controller.selectedDp.value == option['percentage'];

          return GestureDetector(
            onTap: () => controller.changeDp(option['percentage'].toDouble()),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildRincianAngsuranTable(List<dynamic> rincianAngsuran) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.muted),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              MaterialStateProperty.all(AppColors.muted.withOpacity(0.2)),
          dataRowMaxHeight: 60,
          dataRowMinHeight: 48,
          columnSpacing: 16,
          horizontalMargin: 12,
          columns: [
            DataColumn(
              label: Text(
                'Bulan',
                style: AppText.smallBold(color: AppColors.dark),
              ),
            ),
            DataColumn(
              label: Text(
                'Angsuran',
                style: AppText.smallBold(color: AppColors.dark),
              ),
            ),
            DataColumn(
              label: Text(
                'Pokok',
                style: AppText.smallBold(color: AppColors.dark),
              ),
            ),
            DataColumn(
              label: Text(
                'Bunga',
                style: AppText.smallBold(color: AppColors.dark),
              ),
            ),
            DataColumn(
              label: Text(
                'Sisa Pokok',
                style: AppText.smallBold(color: AppColors.dark),
              ),
            ),
          ],
          rows: List.generate(
            rincianAngsuran.length,
            (index) {
              final rincian = rincianAngsuran[index];
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      '${rincian['bulan']}',
                      style: AppText.bodySmall(color: AppColors.dark),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormatter.formatRupiah(rincian['angsuran'] ?? 0),
                      style: AppText.bodySmall(color: AppColors.dark),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormatter.formatRupiah(rincian['pokok'] ?? 0),
                      style: AppText.bodySmall(color: AppColors.dark),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormatter.formatRupiah(rincian['bunga'] ?? 0),
                      style: AppText.bodySmall(color: AppColors.dark),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormatter.formatRupiah(
                          rincian['sisa_pokok'] ?? 0),
                      style: AppText.bodySmall(color: AppColors.dark),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
