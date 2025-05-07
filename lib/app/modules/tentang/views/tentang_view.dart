import 'package:flutter/material.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/tentang_controller.dart';

class TentangView extends GetView<TentangController> {
  const TentangView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Tentang BMS',
          style: AppText.h5(color: AppColors.dark),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Remix.arrow_left_line,
            color: AppColors.dark,
            size: AppResponsive.getResponsiveSize(24),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildBody(context),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppResponsive.padding(horizontal: 5, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo dan Judul
          _buildHeader(),
          SizedBox(height: AppResponsive.h(4)),
          
          // Tentang BMS
          _buildAboutSection(),
          SizedBox(height: AppResponsive.h(4)),
          
          // Layanan
          _buildServicesSection(),
          SizedBox(height: AppResponsive.h(4)),
          
          // Lokasi
          _buildLocationSection(),
          SizedBox(height: AppResponsive.h(4)),
          
          // Kontak
          _buildContactSection(),
          SizedBox(height: AppResponsive.h(4)),
          
          
          SizedBox(height: AppResponsive.h(2)),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          // Logo BMS
          Container(
            width: AppResponsive.w(40),
            height: AppResponsive.h(20),
            
            padding: AppResponsive.padding(all: 2),
            child: Hero(
              tag: 'bms-logo',
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.h(2)),
          Text(
            controller.dealerInfo['nama']!,
            style: AppText.h5(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppResponsive.h(1)),
          Text(
            'Dealer Mobil Bekas Terpercaya',
            style: AppText.p(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAboutSection() {
    return Container(
      padding: AppResponsive.padding(all: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(16)),
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
          Row(
            children: [
              Icon(
                Remix.information_line,
                color: AppColors.primary,
                size: AppResponsive.getResponsiveSize(24),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Tentang Kami',
                style: AppText.h5(color: AppColors.dark),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(2)),
          Text(
            'BMS (${controller.dealerInfo["singkatan"]}) adalah showroom mobil bekas terpercaya yang berlokasi di ${controller.dealerInfo["kota"]}. Kami menawarkan berbagai pilihan mobil berkualitas dengan harga terbaik.',
            style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
          ),
          SizedBox(height: AppResponsive.h(1.5)),
          Text(
            'Dengan pengalaman bertahun-tahun di bidang jual beli mobil, kami berkomitmen memberikan pelayanan terbaik dan transparan untuk setiap pelanggan.',
            style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServicesSection() {
    return Container(
      padding: AppResponsive.padding(all: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(16)),
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
          Row(
            children: [
              Icon(
                Remix.service_line,
                color: AppColors.primary,
                size: AppResponsive.getResponsiveSize(24),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Layanan Kami',
                style: AppText.h5(color: AppColors.dark),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(2)),
          
          // Menggunakan data dari controller
          ...controller.servicesList.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            
            IconData getServiceIcon(String iconName) {
              switch (iconName) {
                case 'money_dollar_circle_line':
                  return Remix.money_dollar_circle_line;
                case 'bank_card_line':
                  return Remix.bank_card_line;
                case 'exchange_line':
                  return Remix.exchange_line;
                default:
                  return Remix.service_line;
              }
            }
            
            return Column(
              children: [
                _buildServiceItem(
                  icon: getServiceIcon(service['icon'] as String),
                  title: service['title'] as String,
                  description: service['description'] as String,
                ),
                if (index < controller.servicesList.length - 1)
                  SizedBox(height: AppResponsive.h(2)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppResponsive.padding(all: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppResponsive.getResponsiveSize(20),
          ),
        ),
        SizedBox(width: AppResponsive.w(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.h6(color: AppColors.dark),
              ),
              SizedBox(height: AppResponsive.h(0.5)),
              Text(
                description,
                style: AppText.p(color: AppColors.dark.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLocationSection() {
    return Container(
      padding: AppResponsive.padding(all: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(16)),
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
          Row(
            children: [
              Icon(
                Remix.map_pin_2_line,
                color: AppColors.primary,
                size: AppResponsive.getResponsiveSize(24),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Lokasi Kami',
                style: AppText.h5(color: AppColors.dark),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(2)),
          
          // Alamat dari controller
          Text(
            controller.dealerInfo['alamat']!,
            style: AppText.h6(color: AppColors.dark),
          ),
          SizedBox(height: AppResponsive.h(0.5)),
          Text(
            controller.dealerInfo['nama']!,
            style: AppText.bodyMedium(color: AppColors.primary).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppResponsive.h(0.5)),
          Text(
            controller.dealerInfo['kota']!,
            style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
          ),
          
          SizedBox(height: AppResponsive.h(2)),
          
          // Jam Operasional
          Row(
            children: [
              Icon(
                Remix.time_line,
                color: AppColors.info,
                size: AppResponsive.getResponsiveSize(18),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Jam Operasional:',
                style: AppText.bodyMedium(color: AppColors.dark).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(0.5)),
          Padding(
            padding: AppResponsive.padding(left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.operationalHours.map((hours) => 
                Padding(
                  padding: AppResponsive.padding(vertical: 0.25),
                  child: Text(
                    '${hours['day']}: ${hours['hours']}',
                    style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
                  ),
                )
              ).toList(),
            ),
          ),
          
          // Tombol arahkan ke lokasi
          SizedBox(height: AppResponsive.h(2)),
          InkWell(
            onTap: () {
              // Buka di Google Maps
              final fullAddress = "${controller.dealerInfo['alamat']}, ${controller.dealerInfo['kota']}";
              controller.openMaps(fullAddress);
            },
            child: Container(
              width: double.infinity,
              padding: AppResponsive.padding(vertical: 1.2),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(8)),
                border: Border.all(color: AppColors.info, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Remix.map_2_line,
                    color: AppColors.info,
                    size: AppResponsive.getResponsiveSize(18),
                  ),
                  SizedBox(width: AppResponsive.w(1.5)),
                  Text(
                    'Arahkan ke Lokasi',
                    style: AppText.button(color: AppColors.info),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactSection() {
    return Container(
      padding: AppResponsive.padding(all: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(16)),
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
          Row(
            children: [
              Icon(
                Remix.contacts_line,
                color: AppColors.primary,
                size: AppResponsive.getResponsiveSize(24),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Kontak',
                style: AppText.h5(color: AppColors.dark),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(2)),
          
          // Nomor Telepon/WhatsApp
          
          
          SizedBox(height: AppResponsive.h(2)),
          
          // Email
          InkWell(
            onTap: () {
              // Buka email
              final email = controller.dealerInfo['email']!;
              controller.sendEmail(email, subject: 'Pertanyaan tentang mobil di BMS');
            },
            child: Row(
              children: [
                Container(
                  padding: AppResponsive.padding(all: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Remix.mail_line,
                    color: AppColors.primary,
                    size: AppResponsive.getResponsiveSize(18),
                  ),
                ),
                SizedBox(width: AppResponsive.w(3)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: AppText.bodyMedium(color: AppColors.dark).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppResponsive.h(0.3)),
                    SelectableText(
                      controller.dealerInfo['email']!,
                      style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Remix.external_link_line,
                  color: AppColors.primary,
                  size: AppResponsive.getResponsiveSize(18),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppResponsive.h(2)),
          
          // Media Sosial (Instagram)
          InkWell(
            onTap: () {
              // Buka Instagram
              final instagram = controller.dealerInfo['instagram']!;
              controller.openInstagram(instagram);
            },
            child: Row(
              children: [
                Container(
                  padding: AppResponsive.padding(all: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Remix.instagram_line,
                    color: AppColors.primary,
                    size: AppResponsive.getResponsiveSize(18),
                  ),
                ),
                SizedBox(width: AppResponsive.w(3)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instagram',
                      style: AppText.bodyMedium(color: AppColors.dark).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppResponsive.h(0.3)),
                    Text(
                      controller.dealerInfo['instagram']!,
                      style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Remix.external_link_line,
                  color: AppColors.primary,
                  size: AppResponsive.getResponsiveSize(18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  

  

}