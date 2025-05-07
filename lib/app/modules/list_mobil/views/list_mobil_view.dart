import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/widget/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_text.dart';
import '../controllers/list_mobil_controller.dart';

class ListMobilView extends GetView<ListMobilController> {
  const ListMobilView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi AppResponsive
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppResponsive.padding(all: 2),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.searchCars,
                      decoration: InputDecoration(
                        hintText: 'Cari mobil...',
                        hintStyle: AppText.bodyMedium(color: AppColors.grey),
                        prefixIcon: Icon(
                          Remix.search_2_line,
                          color: AppColors.dark,
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
                    ),
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
                final filteredCars = controller.filteredCarListings;
                if (filteredCars.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada mobil ditemukan',
                      style: AppText.h5(color: AppColors.grey),
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
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  // Widget untuk kartu mobil
  Widget _buildCarCard(Map<String, dynamic> car) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.DETAIL_MOBIL, arguments: car);
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
                  child: Image.asset(
                    car['image'] as String,
                    width: double.infinity,
                    height: constraints.maxHeight * 0.4,
                    fit: BoxFit.cover,
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
                                      Text(
                                        car['carName'] as String,
                                        style:
                                            AppText.h6(color: AppColors.dark),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Image.asset(
                                        controller.brands.firstWhere(
                                          (brand) =>
                                              brand['name'] == car['logoName'],
                                          orElse: () => {
                                            'image':
                                                'assets/images/default_logo.png'
                                          },
                                        )['image'] as String,
                                        width: AppResponsive.w(6),
                                        height: AppResponsive.h(4),
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '\Rp. ${car['price']}',
                          style: AppText.bodyLarge(color: AppColors.dark),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSpecItem(
                              icon: Icons.speed,
                              label: car['horsePower'] as String,
                            ),
                            _buildSpecItem(
                              icon: Icons.settings,
                              label: car['transmission'] as String,
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

  // Widget untuk item spesifikasi
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

  // Di dalam class ListMobilView
Widget _buildFilterBottomSheet() {
  // Inisialisasi variabel untuk menyimpan filter yang dipilih
  Map<String, dynamic> activeFilters = Map<String, dynamic>.from(controller.activeFilters.value);
  
  return StatefulBuilder(
    builder: (context, setState) {
      // Dropdown options
      final List<String> transmissions = ['Manual', 'Automatic'];
      final List<String> bodyTypes = ['Sedan', 'SUV', 'Hatchback', 'MPV'];
      final List<String> engineCapacities = ['1.0L', '1.5L', '2.0L', '2.5L'];
      final List<String> colors = ['Putih', 'Hitam', 'Silver', 'Merah'];
      final List<String> fuelTypes = ['Bensin', 'Diesel', 'Hybrid'];
      final List<String> years = ['2019', '2020', '2021', '2022', '2023'];
      
      // Price range options
      final List<String> priceRanges = [
        '< 20.000.000', 
        '30.000.000 - 50.000.000', 
        '100.000.000 - 300.000.000', 
        '> 500.000.000'
      ];

      // Fungsi helper untuk mendapatkan filter yang aktif
      bool isActive(String filterType, String value) {
        return activeFilters[filterType] == value;
      }
      
      // Fungsi helper untuk mengubah filter
      void toggleFilter(String filterType, String? value) {
        setState(() {
          if (value == null || (activeFilters[filterType] == value)) {
            activeFilters.remove(filterType);
          } else {
            activeFilters[filterType] = value;
          }
        });
      }

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
              // Header dengan judul dan tombol
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
                        // Tombol Reset
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
                        // Tombol Close
                        IconButton(
                          icon: Icon(Remix.close_line, color: AppColors.dark),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Konten filter dengan scroll
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: AppResponsive.padding(all: 3),
                  children: [
                    // Filter yang aktif
                    if (activeFilters.isNotEmpty)
                      _buildFilterSection(
                        title: 'Filter Aktif',
                        child: Wrap(
                          spacing: AppResponsive.w(2),
                          runSpacing: AppResponsive.h(1),
                          children: activeFilters.entries.map((entry) {
                            return Chip(
                              label: Text('${entry.key}: ${entry.value}'),
                              deleteIcon: Icon(Remix.close_line, size: 18),
                              onDeleted: () {
                                setState(() {
                                  activeFilters.remove(entry.key);
                                });
                              },
                              backgroundColor: AppColors.primary.withOpacity(0.2),
                              labelStyle: AppText.bodySmall(
                                color: AppColors.primary,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Rentang Harga
                    _buildFilterSection(
                      title: 'Rentang Harga',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: priceRanges.map((price) {
                          final isSelected = isActive('priceRange', price);
                          return FilterChip(
                            label: Text(price),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('priceRange', selected ? price : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Merk
                    _buildFilterSection(
                      title: 'Merk',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: controller.brands.map((brand) {
                          final brandName = brand['name'] as String;
                          final isSelected = isActive('brand', brandName);
                          return FilterChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                brand['image'] as String,
                                width: AppResponsive.w(5),
                                height: AppResponsive.h(3),
                                fit: BoxFit.contain,
                              ),
                            ),
                            label: Text(brandName),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('brand', selected ? brandName : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Transmisi
                    _buildFilterSection(
                      title: 'Transmisi',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: transmissions.map((transmission) {
                          final isSelected = isActive('transmission', transmission);
                          return FilterChip(
                            label: Text(transmission),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('transmission', selected ? transmission : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Tipe Body
                    _buildFilterSection(
                      title: 'Tipe Body',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: bodyTypes.map((bodyType) {
                          final isSelected = isActive('bodyType', bodyType);
                          return FilterChip(
                            label: Text(bodyType),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('bodyType', selected ? bodyType : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Kapasitas Mesin
                    _buildFilterSection(
                      title: 'Kapasitas Mesin',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: engineCapacities.map((capacity) {
                          final isSelected = isActive('engineCapacity', capacity);
                          return FilterChip(
                            label: Text(capacity),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('engineCapacity', selected ? capacity : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Warna
                    _buildFilterSection(
                      title: 'Warna',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: colors.map((color) {
                          final isSelected = isActive('color', color);
                          return FilterChip(
                            label: Text(color),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('color', selected ? color : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Bahan Bakar
                    _buildFilterSection(
                      title: 'Bahan Bakar',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: fuelTypes.map((fuelType) {
                          final isSelected = isActive('fuelType', fuelType);
                          return FilterChip(
                            label: Text(fuelType),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('fuelType', selected ? fuelType : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Tahun Keluaran
                    _buildFilterSection(
                      title: 'Tahun Keluaran',
                      child: Wrap(
                        spacing: AppResponsive.w(2),
                        runSpacing: AppResponsive.h(1),
                        children: years.map((year) {
                          final isSelected = isActive('year', year);
                          return FilterChip(
                            label: Text(year),
                            selected: isSelected,
                            onSelected: (selected) {
                              toggleFilter('year', selected ? year : null);
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            labelStyle: AppText.bodyMedium(
                              color: isSelected ? AppColors.primary : AppColors.dark,
                            ),
                            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
                          );
                        }).toList(),
                      ),
                    ),

                    // Spasi bawah
                    SizedBox(height: AppResponsive.h(10)),
                  ],
                ),
              ),
              
              // Footer dengan tombol
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
                    // Tombol Reset
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
                    // Tombol Terapkan
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // Terapkan filter
                          controller.applyCarFilter(activeFilters);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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

// Helper method untuk section filter
Widget _buildFilterSection({
  required String title,
  required Widget child,
}) {
  return Container(
    margin: AppResponsive.padding(vertical: 2),
    padding: AppResponsive.padding(all: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
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
            style: AppText.h6(color: AppColors.dark,),
          ),
        ),
        child,
      ],
    ),
  );
}
}
