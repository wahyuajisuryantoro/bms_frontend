import 'package:dealer_mobil/app/components/loading_animation.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/widget/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_text.dart';
import '../controllers/list_mobil_controller.dart';

class ListMobilView extends GetView<ListMobilController> {
  const ListMobilView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppResponsive.padding(all: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => controller.isSearchFocused.value
                          ? TextField(
                              controller: controller.searchController,
                              focusNode: controller.searchFocusNode,
                              onChanged: controller.searchCars,
                              autofocus: controller.isSearchFocused.value,
                              decoration: InputDecoration(
                                hintText: 'Cari mobil...',
                                hintStyle:
                                    AppText.bodyMedium(color: AppColors.grey),
                                prefixIcon: Icon(
                                  Remix.search_2_line,
                                  color: AppColors.dark,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close, color: AppColors.grey),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.searchCars('');
                                    controller.isSearchFocused.value = false;
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppResponsive.getResponsiveSize(15)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppResponsive.getResponsiveSize(15)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppResponsive.getResponsiveSize(15)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300)),
                              ),
                              style: AppText.bodyMedium(color: AppColors.dark),
                            )
                          : InkWell(
                              onTap: () {
                                controller.isSearchFocused.value = true;
                                Future.delayed(Duration(milliseconds: 100), () {
                                  controller.searchFocusNode.requestFocus();
                                });
                              },
                              child: Container(
                                height: 48,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      AppResponsive.getResponsiveSize(15)),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      Remix.search_2_line,
                                      color: AppColors.dark,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Cari mobil...',
                                      style: AppText.bodyMedium(
                                          color: AppColors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    ),
                    SizedBox(width: AppResponsive.w(2)),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => _buildFilterBottomSheet(),
                        );
                      },
                      child: Icon(
                        Remix.sound_module_line,
                        color: AppColors.dark,
                        size: AppResponsive.getResponsiveSize(20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child:AnimationLoading.container(
                        height : 100
                      )
                    );
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
                            onPressed: () => controller.fetchMobil(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredCars = controller.filteredCarListings;
                  if (filteredCars.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Remix.search_2_line,
                            size: 60,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada mobil ditemukan',
                            style: AppText.h5(color: AppColors.grey),
                          ),
                          if (controller.searchQuery.value.isNotEmpty ||
                              controller.activeFilters.value.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Coba menggunakan filter lain',
                                style: AppText.bodyMedium(color: AppColors.grey),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: AppResponsive.padding(horizontal: 4, vertical: 2),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: AppResponsive.w(2),
                      mainAxisSpacing: AppResponsive.h(2),
                    ),
                    itemCount: filteredCars.length,
                    itemBuilder: (context, index) {
                      final car = filteredCars[index];
                      return _buildCarCard(car);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildCarCard(dynamic car) {
    final String hargaFormatted = car['harga'] != null
        ? NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(double.parse(car['harga'].toString()))
        : 'Hubungi Kami';

    final String thumbnailUrl = car['thumbnail_foto'] ?? '';
    final bool hasThumbnail = thumbnailUrl.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
        Routes.DETAIL_MOBIL, 
        arguments: {
          'id': car['id'],
        }
      );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(AppResponsive.getResponsiveSize(15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppResponsive.getResponsiveSize(15)),
                  ),
                  child: hasThumbnail
                      ? Image.network(
                          thumbnailUrl,
                          width: double.infinity,
                          height: constraints.maxHeight * 0.4,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: double.infinity,
                            height: constraints.maxHeight * 0.4,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.car_crash,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: constraints.maxHeight * 0.4,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.4,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.car_crash,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: AppResponsive.padding(all: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          car['nama_mobil'] ?? 'Mobil',
                                          style:
                                              AppText.h6(color: AppColors.dark),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      if (car['foto_merk'] != null)
                                        Container(
                                          width: AppResponsive.w(6),
                                          height: AppResponsive.h(4),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  car['foto_merk']),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          hargaFormatted,
                          style: AppText.bodyLarge(color: AppColors.dark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSpecItem(
                              icon: Icons.speed,
                              label: "${car['kapasitas_mesin'] ?? '-'} cc",
                            ),
                            _buildSpecItem(
                              icon: Icons.settings,
                              label: car['transmisi'] ?? '-',
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: AppResponsive.getResponsiveSize(18),
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        Text(
          label,
          style: AppText.bodySmall(color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildFilterBottomSheet() {
    Map<String, dynamic> activeFilters =
        Map<String, dynamic>.from(controller.activeFilters.value);

    return StatefulBuilder(
      builder: (context, setState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppResponsive.getResponsiveSize(20)),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: AppResponsive.padding(horizontal: 3, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppResponsive.getResponsiveSize(20)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Mobil',
                        style: AppText.h4(color: AppColors.dark),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                activeFilters.clear();
                              });
                            },
                            child: Text(
                              'Reset',
                              style: AppText.button(color: AppColors.primary),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Remix.close_line, color: AppColors.dark),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: AppResponsive.padding(all: 3),
                    children: [
                      if (activeFilters.isNotEmpty)
                        _buildFilterSection(
                          title: 'Filter Aktif',
                          child: Wrap(
                            spacing: AppResponsive.w(2),
                            runSpacing: AppResponsive.h(1),
                            children: activeFilters.entries.map((entry) {
                              if (entry.key.contains('_id') ||
                                  entry.key == 'brand' ||
                                  entry.key == 'transmission' ||
                                  entry.key == 'bodyType' ||
                                  entry.key == 'fuelType' ||
                                  entry.key == 'engineCapacity' ||
                                  entry.key == 'color' ||
                                  entry.key == 'year' ||
                                  entry.key == 'priceRange') {
                                String filterLabel = '';
                                String filterValue = entry.value.toString();

                                if (entry.key == 'brand' ||
                                    entry.key.contains('merk')) {
                                  filterLabel = 'Merk';
                                } else if (entry.key == 'transmission' ||
                                    entry.key.contains('transmisi')) {
                                  filterLabel = 'Transmisi';
                                } else if (entry.key == 'bodyType' ||
                                    entry.key.contains('tipe_bodi')) {
                                  filterLabel = 'Tipe Body';
                                } else if (entry.key == 'fuelType' ||
                                    entry.key.contains('bahan_bakar')) {
                                  filterLabel = 'Bahan Bakar';
                                } else if (entry.key == 'engineCapacity' ||
                                    entry.key.contains('kapasitas_mesin')) {
                                  filterLabel = 'Kapasitas Mesin';
                                } else if (entry.key == 'color' ||
                                    entry.key.contains('warna')) {
                                  filterLabel = 'Warna';
                                } else if (entry.key == 'year') {
                                  filterLabel = 'Tahun';
                                } else if (entry.key == 'priceRange') {
                                  filterLabel = 'Harga';
                                }

                                if (entry.key.endsWith('_id')) {
                                  return SizedBox.shrink();
                                }

                                return Chip(
                                  label: Text('$filterLabel: $filterValue'),
                                  deleteIcon: Icon(Remix.close_line, size: 18),
                                  onDeleted: () {
                                    setState(() {
                                      if (entry.key == 'brand') {
                                        activeFilters.remove('brand');
                                        activeFilters.remove('merk_id');
                                      } else if (entry.key == 'transmission') {
                                        activeFilters.remove('transmission');
                                        activeFilters.remove('transmisi_id');
                                      } else if (entry.key == 'bodyType') {
                                        activeFilters.remove('bodyType');
                                        activeFilters.remove('tipe_bodi_id');
                                      } else if (entry.key == 'fuelType') {
                                        activeFilters.remove('fuelType');
                                        activeFilters.remove('bahan_bakar_id');
                                      } else if (entry.key == 'engineCapacity') {
                                        activeFilters.remove('engineCapacity');
                                        activeFilters.remove('kapasitas_mesin_id');
                                      } else if (entry.key == 'color') {
                                        activeFilters.remove('color');
                                        activeFilters.remove('warna_id');
                                      } else if (entry.key == 'year') {
                                        activeFilters.remove('year');
                                      } else if (entry.key == 'priceRange') {
                                        activeFilters.remove('priceRange');
                                      } else {
                                        activeFilters.remove(entry.key);
                                      }
                                    });
                                  },
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.2),
                                  labelStyle: AppText.bodySmall(
                                    color: AppColors.primary,
                                  ),
                                );
                              }

                              return SizedBox.shrink();
                            }).toList()
                              ..removeWhere((widget) => widget is SizedBox),
                          ),
                        ),
                      _buildFilterSection(
                        title: 'Rentang Harga',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: [
                            '< 20.000.000',
                            '30.000.000 - 50.000.000',
                            '100.000.000 - 300.000.000',
                            '> 500.000.000'
                          ].map((price) {
                            final isSelected =
                                activeFilters['priceRange'] == price;
                            return FilterChip(
                              label: Text(price),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['priceRange'] = price;
                                  } else {
                                    activeFilters.remove('priceRange');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Merk',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.brands.map((brand) {
                            final brandName = brand['name'] as String;
                            final brandId = brand['id'];
                            final isSelected =
                                activeFilters['merk_id'] == brandId.toString();
                            return FilterChip(
                              avatar: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    NetworkImage(brand['image'] ?? ''),
                              ),
                              label: Text(brandName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['merk_id'] =
                                        brandId.toString();
                                    activeFilters['brand'] = brandName;
                                  } else {
                                    activeFilters.remove('merk_id');
                                    activeFilters.remove('brand');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Transmisi',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.transmisions.map((transmission) {
                            final transmissionName =
                                transmission['name'] as String;
                            final transmissionId = transmission['id'];
                            final isSelected = activeFilters['transmisi_id'] ==
                                transmissionId.toString();
                            return FilterChip(
                              label: Text(transmissionName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['transmisi_id'] =
                                        transmissionId.toString();
                                    activeFilters['transmission'] =
                                        transmissionName;
                                  } else {
                                    activeFilters.remove('transmisi_id');
                                    activeFilters.remove('transmission');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Tipe Body',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.tipeBodis.map((bodyType) {
                            final bodyTypeName = bodyType['name'] as String;
                            final bodyTypeId = bodyType['id'];
                            final isSelected = activeFilters['tipe_bodi_id'] ==
                                bodyTypeId.toString();
                            return FilterChip(
                              label: Text(bodyTypeName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['tipe_bodi_id'] =
                                        bodyTypeId.toString();
                                    activeFilters['bodyType'] = bodyTypeName;
                                  } else {
                                    activeFilters.remove('tipe_bodi_id');
                                    activeFilters.remove('bodyType');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Kapasitas Mesin',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.kapasitasMesins.map((capacity) {
                            final capacityName = capacity['name'] as String;
                            final capacityId = capacity['id'];
                            final isSelected =
                                activeFilters['kapasitas_mesin_id'] ==
                                    capacityId.toString();
                            return FilterChip(
                              label: Text(capacityName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['kapasitas_mesin_id'] =
                                        capacityId.toString();
                                    activeFilters['engineCapacity'] =
                                        capacityName;
                                  } else {
                                    activeFilters.remove('kapasitas_mesin_id');
                                    activeFilters.remove('engineCapacity');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Warna',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.warnas.map((color) {
                            final colorName = color['name'] as String;
                            final colorId = color['id'];
                            final isSelected =
                                activeFilters['warna_id'] == colorId.toString();
                            return FilterChip(
                              label: Text(colorName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['warna_id'] =
                                        colorId.toString();
                                    activeFilters['color'] = colorName;
                                  } else {
                                    activeFilters.remove('warna_id');
                                    activeFilters.remove('color');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Bahan Bakar',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.bahanBakars.map((fuel) {
                            final fuelName = fuel['name'] as String;
                            final fuelId = fuel['id'];
                            final isSelected =
                                activeFilters['bahan_bakar_id'] ==
                                    fuelId.toString();
                            return FilterChip(
                              label: Text(fuelName),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['bahan_bakar_id'] =
                                        fuelId.toString();
                                    activeFilters['fuelType'] = fuelName;
                                  } else {
                                    activeFilters.remove('bahan_bakar_id');
                                    activeFilters.remove('fuelType');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        title: 'Tahun Keluaran',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: controller.years.map((year) {
                            final yearValue = year['name'].toString();
                            final yearId = year['id'];
                            final isSelected =
                                activeFilters['year'] == yearValue;
                            return FilterChip(
                              label: Text(yearValue),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    activeFilters['year'] = yearValue;
                                  } else {
                                    activeFilters.remove('year');
                                  }
                                });
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppResponsive.getResponsiveSize(8)),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              labelStyle: AppText.bodyMedium(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.dark,
                              ),
                              padding: AppResponsive.padding(
                                  horizontal: 2, vertical: 1),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: AppResponsive.h(10)),
                    ],
                  ),
                ),
                Container(
                  padding: AppResponsive.padding(all: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            controller.resetFilters();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: AppResponsive.padding(vertical: 2),
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppResponsive.getResponsiveSize(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: AppText.button(color: AppColors.primary),
                          ),
                        ),
                      ),
                      SizedBox(width: AppResponsive.w(2)),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.applyCarFilter(activeFilters);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: AppResponsive.padding(vertical: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppResponsive.getResponsiveSize(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'Terapkan Filter',
                            style: AppText.button(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: AppResponsive.padding(vertical: 2),
      padding: AppResponsive.padding(all: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppResponsive.padding(bottom: 1),
            child: Text(
              title,
              style: AppText.h6(color: AppColors.dark),
            ),
          ),
          child,
        ],
      ),
    );
  }
}