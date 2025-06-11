import 'package:dealer_mobil/app/components/loading_animation.dart';
import 'package:dealer_mobil/app/helpers/currency_formatter.dart';
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        controller.handleDoubleBackToExit();
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            color: AppColors.primary,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), // Penting untuk RefreshIndicator
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    _buildHeader(),
                    SizedBox(height: AppResponsive.h(2)),
                    _buildWelcomeSection(),
                    SizedBox(height: 16),
                    _buildSearchBar(),
                    SizedBox(height: AppResponsive.h(2)),
                    _buildBrandsSection(),
                    SizedBox(height: AppResponsive.h(2)),
                    _buildTransmissionsSection(),
                    SizedBox(height: AppResponsive.h(3)),
                    buildCarListingsSlider(),
                    SizedBox(height: AppResponsive.h(2)),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Remix.map_pin_2_line, color: AppColors.primary, size: 20),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Showroom',
                  style: AppText.small(color: AppColors.grey),
                ),
                Text(
                  'Bursa Mobil Solo',
                  style: AppText.pSmall(color: AppColors.dark),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Tombol refresh manual
            Obx(() => controller.isRefreshing.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : IconButton(
                    onPressed: () => controller.refreshData(),
                    icon: Icon(
                      Remix.refresh_line,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  )),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              width: 50,
              height: 50,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang',
          style: AppText.h3(color: AppColors.dark),
        ),
        Obx(() => Text(
              controller.userName.value,
              style: AppText.h4(color: AppColors.dark),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteOld,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.LIST_MOBIL, arguments: {'openSearch': true});
        },
        child: Container(
          height: 48,
          child: Row(
            children: [
              Icon(Remix.search_2_line, color: AppColors.grey, size: 22),
              SizedBox(width: 10),
              Text(
                'Cari Mobil...',
                style: AppText.p(color: AppColors.grey),
              ),
              Spacer(),
              Icon(Remix.equalizer_line, color: AppColors.dark, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pilih berdasarkan brands',
              style: AppText.h6(color: AppColors.dark),
            ),
            Obx(
              () => controller.brands.length > controller.maxBrandsToShow
                  ? GestureDetector(
                      onTap: () => controller.isExpandedBrands.toggle(),
                      child: Row(
                        children: [
                          Text(
                            controller.isExpandedBrands.value ? 'Tutup' : 'Lihat Semua',
                            style: AppText.small(color: AppColors.primary),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            controller.isExpandedBrands.value
                                ? Remix.arrow_up_line
                                : Remix.arrow_right_line,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.h(2)),
        Obx(() => controller.isLoadingBrands.value
            ? AnimationLoading.container(height: 110)
            : _buildBrandsGrid()),
      ],
    );
  }

  Widget _buildBrandsGrid() {
    return Container(
      height: controller.isExpandedBrands.value &&
              controller.brands.length > controller.maxBrandsToShow
          ? (110 * ((controller.brands.length / 3).ceil().toDouble()))
          : 110.0,
      child: Obx(() {
        final isExpanded = controller.isExpandedBrands.value;
        final brandsToShow = isExpanded
            ? controller.brands
            : controller.brands.take(controller.maxBrandsToShow).toList();

        if (isExpanded && controller.brands.length > controller.maxBrandsToShow) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.brands.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final brand = controller.brands[index];
              final String image = brand['image'] as String;
              final String name = brand['name'] as String;
              final int id = brand['id'] as int;

              return GestureDetector(
                child: _buildBrandLogo(image, name, false),
              );
            },
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: brandsToShow.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final brand = brandsToShow[index];
              final String image = brand['image'] as String;
              final String name = brand['name'] as String;
              final int id = brand['id'] as int;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildBrandLogo(image, name, false),
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildTransmissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih berdasarkan transmisi',
          style: AppText.h6(color: AppColors.dark),
        ),
        SizedBox(height: AppResponsive.h(2)),
        Obx(() => controller.isLoadingTransmissions.value
            ? AnimationLoading.container(height: 60)
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.transmissions.asMap().entries.map((entry) {
                    int idx = entry.key;
                    Map<String, dynamic> item = entry.value;
                    int itemId = item['id'] as int;
                    bool isSelected = item['isSelected'] as bool;

                    return Padding(
                      padding: EdgeInsets.only(right: 12, left: idx == 0 ? 0 : 0),
                      child: GestureDetector(
                        child: _buildTransmissionOption(
                          item['name'],
                          isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
      ],
    );
  }

  // Cache info widget untuk debugging (opsional)
  
  Widget _buildBrandLogo(String image, String name, [bool isSelected = false]) {
    return Container(
      width: Get.width * 0.25,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.LIST_MOBIL, arguments: {
            'filter': {
              'brand': name,
              'merk_id': controller.brands
                  .firstWhere((brand) => brand['name'] == name)['id']
                  .toString(),
            }
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: AppText.pSmall(
                color: isSelected ? AppColors.primary : AppColors.dark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransmissionOption(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        final selectedTransmission = controller.transmissions
            .firstWhere((transmission) => transmission['name'] == title);

        Get.toNamed(Routes.LIST_MOBIL, arguments: {
          'filter': {
            'transmission': title,
            'transmisi_id': selectedTransmission['id'].toString(),
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.whiteOld,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: AppText.pSmall(
            color: isSelected ? Colors.white : AppColors.dark,
          ),
        ),
      ),
    );
  }

  Widget _buildCarListing(Map<String, dynamic> car) {
    // Tampilkan harga Cash
    String formattedPrice = CurrencyFormatter.formatRupiah(car['harga']);

    return InkWell(
      onTap: () {
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
              child: Container(
                width: 300,
                height: 190,
                color: Colors.white,
                child: car['thumbnail_foto'] != null
                    ? Image.network(
                        car['thumbnail_foto'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.car_crash,
                              size: 50, color: Colors.grey),
                        ),
                      )
                    : Center(
                        child:
                            Icon(Icons.car_crash, size: 50, color: Colors.grey),
                      ),
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
                          car['foto_merk'] != null
                              ? CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.whiteOld,
                                  backgroundImage:
                                      NetworkImage(car['foto_merk']),
                                )
                              : CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.whiteOld,
                                  child: Text(
                                    car['merk'] != null
                                        ? car['merk'].toString().substring(0, 1)
                                        : '?',
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                          SizedBox(width: 8),
                          Text(
                            car['merk'] != null
                                ? car['merk'].toString()
                                : 'Unknown',
                            style: AppText.small(color: AppColors.grey),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Cash",
                            style: AppText.small(
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            formattedPrice,
                            style:
                                AppText.bodyMediumBold(color: AppColors.dark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    car['nama_mobil'] != null
                        ? car['nama_mobil'].toString()
                        : 'Unknown Model',
                    style: AppText.h6(color: AppColors.dark),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.settings,
                                size: 16, color: AppColors.dark),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                car['kapasitas_mesin'] != null
                                    ? "${car['kapasitas_mesin']}"
                                    : "-",
                                style: AppText.small(color: AppColors.dark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.repeat, size: 16, color: AppColors.dark),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                car['transmisi'] != null
                                    ? car['transmisi'].toString()
                                    : "-",
                                style: AppText.small(color: AppColors.dark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.directions_car,
                                size: 16, color: AppColors.dark),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                car['tipe_bodi'] != null
                                    ? car['tipe_bodi'].toString()
                                    : "-",
                                style: AppText.small(color: AppColors.dark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
              'Mobil Tersedia',
              style: AppText.h6(color: AppColors.dark),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LIST_MOBIL);
              },
              child: Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: AppText.small(color: AppColors.primary),
                  ),
                  SizedBox(width: 4),
                  Icon(Remix.arrow_right_line,
                      color: AppColors.primary, size: 18),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingCars.value) {
            return AnimationLoading.container(
              height: 200,
              animationWidth: 150,
              animationHeight: 150,
            );
          }

          List<Map<String, dynamic>> displayedCars = controller.carListings;

          if (displayedCars.isEmpty) {
            return Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.whiteOld,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Remix.search_2_line,
                    size: 50,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada mobil ditemukan',
                    style: AppText.p(color: AppColors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Coba lagi nanti',
                    style: AppText.small(color: AppColors.grey),
                  ),
                ],
              ),
            );
          }

          return Container(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayedCars.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final car = displayedCars[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: 16,
                    left: index == 0 ? 0 : 0,
                  ),
                  child: Container(
                    width: Get.width * 0.7,
                    child: _buildCarListing(car),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}