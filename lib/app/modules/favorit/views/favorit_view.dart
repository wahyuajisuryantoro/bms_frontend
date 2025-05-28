import 'package:dealer_mobil/app/helpers/currency_formatter.dart';
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
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.isError.value) {
          return _buildErrorState();
        }

        return controller.favoriteCars.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: controller.refreshFavorites,
                color: AppColors.primary,
                child: _buildFavoritList(),
              );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Mobil Favorit',
        style: AppText.h4(color: AppColors.dark),
      ),
      backgroundColor: AppColors.secondary,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        Obx(() => controller.favoriteCars.isEmpty
            ? SizedBox()
            : Container(
                margin: EdgeInsets.only(right: AppResponsive.w(4)),
                child: IconButton(
                  onPressed: () => _showClearAllDialog(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Remix.delete_bin_line,
                    color: AppColors.danger,
                    size: AppResponsive.getResponsiveSize(20),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppResponsive.w(6)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: AppResponsive.h(3)),
          Text(
            'Memuat favorit Anda...',
            style: AppText.bodyMedium(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: AppResponsive.margin(horizontal: 6),
        padding: AppResponsive.padding(all: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.w(4)),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Remix.wifi_off_line,
                size: AppResponsive.getResponsiveSize(40),
                color: AppColors.danger,
              ),
            ),
            SizedBox(height: AppResponsive.h(2)),
            Text(
              'Oops! Ada Masalah',
              style: AppText.h5(color: AppColors.dark),
            ),
            SizedBox(height: AppResponsive.h(1)),
            Text(
              controller.errorMessage.value,
              style: AppText.bodyMedium(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.h(3)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.getAllDataFavorite(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: AppResponsive.padding(vertical: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppResponsive.getResponsiveSize(12)),
                  ),
                ),
                icon: Icon(Remix.refresh_line),
                label: Text('Coba Lagi',
                    style: AppText.button(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: AppResponsive.margin(horizontal: 6),
        padding: AppResponsive.padding(all: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.w(8)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Remix.heart_3_line,
                size: AppResponsive.getResponsiveSize(80),
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppResponsive.h(4)),
            Text(
              'Belum Ada Favorit',
              style: AppText.h4(color: AppColors.dark),
            ),
            SizedBox(height: AppResponsive.h(1.5)),
            Text(
              'Jelajahi koleksi mobil kami dan tambahkan\nyang paling Anda sukai ke favorit',
              style: AppText.bodyMedium(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.h(5)),
            Container(
              height: AppResponsive.h(8),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/list-mobil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: AppResponsive.padding(vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppResponsive.getResponsiveSize(15)),
                  ),
                  elevation: 3,
                ),
                icon: Icon(
                  Remix.car_line,
                  size: AppResponsive.getResponsiveSize(20),
                  color: Colors.white,
                ),
                label: Text(
                  'Jelajahi Mobil',
                  style: AppText.bodyMediumBold(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritList() {
    return ListView.builder(
      padding: AppResponsive.padding(all: 4),
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: controller.favoriteCars.length,
      itemBuilder: (context, index) {
        final car = controller.favoriteCars[index];
        return _buildFavoritItem(car, index);
      },
    );
  }

  Widget _buildFavoritItem(Map<String, dynamic> car, int index) {
    return Container(
      margin: AppResponsive.margin(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              Get.toNamed('/detail-mobil', arguments: {'id': car['mobil_id']}),
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(AppResponsive.getResponsiveSize(20)),
                      topRight:
                          Radius.circular(AppResponsive.getResponsiveSize(20)),
                    ),
                    child: Stack(
                      children: [
                        car['thumbnail_foto'] != null
                            ? Image.network(
                                car['thumbnail_foto'],
                                height: AppResponsive.h(22),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImagePlaceholder(),
                              )
                            : _buildImagePlaceholder(),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: AppResponsive.h(1.5),
                    right: AppResponsive.w(3),
                    child: GestureDetector(
                      onTap: () => _showRemoveDialog(car),
                      child: Container(
                        padding: AppResponsive.padding(all: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Remix.heart_3_fill,
                          color: AppColors.danger,
                          size: AppResponsive.getResponsiveSize(22),
                        ),
                      ),
                    ),
                  ),
                  if (car['tahun_keluaran'] != null)
                    Positioned(
                      top: AppResponsive.h(1.5),
                      left: AppResponsive.w(3),
                      child: Container(
                        padding:
                            AppResponsive.padding(horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(8)),
                        ),
                        child: Text(
                          car['tahun_keluaran'].toString(),
                          style: AppText.caption(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: AppResponsive.padding(all: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car['nama_mobil'] ?? 'Nama Mobil',
                                style: AppText.h5(color: AppColors.dark),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: AppResponsive.h(0.5)),
                              Text(
                                'by ${car['merk'] ?? 'Unknown'}',
                                style: AppText.bodySmall(color: AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppResponsive.h(2)),
                    Container(
                      padding:
                          AppResponsive.padding(horizontal: 3, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                            AppResponsive.getResponsiveSize(12)),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Remix.money_dollar_circle_line,
                            size: AppResponsive.getResponsiveSize(16),
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppResponsive.w(1)),
                          Text(
                            CurrencyFormatter.formatRupiah(car['harga_cash']),
                            style: AppText.bodyMediumBold(
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppResponsive.h(2.5)),
                    Wrap(
                      spacing: AppResponsive.w(2),
                      runSpacing: AppResponsive.h(1),
                      children: [
                        _buildModernInfoChip(
                          icon: Remix.settings_3_line,
                          label: car['transmisi'] ?? '',
                          color: AppColors.info,
                        ),
                        _buildModernInfoChip(
                          icon: Remix.gas_station_line,
                          label: car['bahan_bakar'] ?? '',
                          color: AppColors.success,
                        ),
                        _buildModernInfoChip(
                          icon: Remix.car_line,
                          label: car['merk'] ?? '',
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: AppResponsive.h(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.muted,
            AppColors.muted.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Remix.image_line,
              size: AppResponsive.getResponsiveSize(32),
              color: AppColors.grey,
            ),
            SizedBox(height: AppResponsive.h(1)),
            Text(
              'Foto tidak tersedia',
              style: AppText.caption(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: AppResponsive.padding(horizontal: 2.5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppResponsive.getResponsiveSize(14),
            color: color,
          ),
          SizedBox(width: AppResponsive.w(1)),
          Text(
            label,
            style: AppText.bodySmall(color: color),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
        ),
        child: Container(
          padding: AppResponsive.padding(all: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppResponsive.w(2)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.danger.withOpacity(0.1),
                      AppColors.danger.withOpacity(0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Remix.delete_bin_line,
                  size: AppResponsive.getResponsiveSize(32),
                  color: AppColors.danger,
                ),
              ),
              SizedBox(height: AppResponsive.h(3)),
              Text(
                'Hapus Semua Favorit?',
                style: AppText.h5(color: AppColors.dark),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(1.5)),
              Text(
                'Tindakan ini akan menghapus semua mobil favorit Anda. Apakah Anda yakin ingin melanjutkan?',
                style: AppText.bodyMedium(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(4)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.muted),
                        padding: AppResponsive.padding(vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(12)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: AppText.button(color: AppColors.dark),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.w(3)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.clearAllFavorites();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        padding: AppResponsive.padding(vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(12)),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Ya, Hapus',
                        style: AppText.button(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showRemoveDialog(Map<String, dynamic> car) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
        ),
        child: Container(
          padding: AppResponsive.padding(all: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppResponsive.w(3)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Remix.heart_3_fill,
                  size: AppResponsive.getResponsiveSize(28),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppResponsive.h(2.5)),
              Text(
                'Hapus dari Favorit?',
                style: AppText.h5(color: AppColors.dark),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppResponsive.h(1)),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppText.bodyMedium(color: AppColors.grey),
                  children: [
                    TextSpan(text: 'Apakah Anda yakin ingin menghapus '),
                    TextSpan(
                      text: car['nama_mobil'] ?? 'mobil ini',
                      style: AppText.bodyMediumBold(color: AppColors.dark),
                    ),
                    TextSpan(text: ' dari daftar favorit?'),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.h(4)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.muted),
                        padding: AppResponsive.padding(vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(12)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: AppText.button(color: AppColors.dark),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.w(3)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.removeFavorite(car);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        padding: AppResponsive.padding(vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppResponsive.getResponsiveSize(12)),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Ya, Hapus',
                        style: AppText.button(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
