import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/informasi_controller.dart';

class InformasiView extends GetView<InformasiController> {
  const InformasiView({super.key});
 @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Hubungi Kami',
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
          // Header section
          _buildHeader(),
          SizedBox(height: AppResponsive.h(4)),
          
          // Customer support section
          _buildSectionTitle('Dukungan Pelanggan'),
          SizedBox(height: AppResponsive.h(2)),
          _buildContactCard(
            title: 'Admin Layanan Pelanggan',
            subtitle: 'Bantuan seputar aplikasi dan layanan',
            icon: Remix.customer_service_2_line,
            iconColor: AppColors.info,
            phoneNumber: '089603816531',
          ),
          SizedBox(height: AppResponsive.h(3)),
          
          // Seller section
          _buildSectionTitle('Informasi Seller'),
          SizedBox(height: AppResponsive.h(2)),
          _buildContactCard(
            title: 'Dealer Mobil Jakarta',
            subtitle: 'Layanan penjualan dan informasi produk',
            icon: Remix.store_2_line,
            iconColor: AppColors.primary,
            phoneNumber: '089603816531',
            showRating: true,
          ),
          SizedBox(height: AppResponsive.h(2)),
          _buildContactCard(
            title: 'Marketing Specialist',
            subtitle: 'Konsultasi pembelian dan kredit',
            icon: Remix.user_3_line,
            iconColor: AppColors.primary,
            phoneNumber: '089603816531',
          ),
          
          SizedBox(height: AppResponsive.h(4)),
          
          // Operational hours
          _buildOperationalHours(),
          
          SizedBox(height: AppResponsive.h(3)),
          
          // Additional info
          _buildAdditionalInfo(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: AppResponsive.padding(all: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Remix.customer_service_line,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(36),
            ),
          ),
          SizedBox(height: AppResponsive.h(2)),
          Text(
            'Butuh Bantuan?',
            style: AppText.h4(color: AppColors.dark),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppResponsive.h(1)),
          Text(
            'Hubungi seller atau admin kami untuk mendapatkan bantuan',
            style: AppText.p(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: AppResponsive.padding(horizontal: 1),
      child: Text(
        title,
        style: AppText.h5(color: AppColors.dark),
      ),
    );
  }
  
  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String phoneNumber,
    bool showRating = false,
  }) {
    return Container(
      padding: AppResponsive.padding(vertical: 2, horizontal: 3),
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
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: AppResponsive.padding(all: 2),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: AppResponsive.getResponsiveSize(24),
                ),
              ),
              SizedBox(width: AppResponsive.w(3)),
              
              // Contact info
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
                      subtitle,
                      style: AppText.small(color: AppColors.grey),
                    ),
                    
                    // Rating
                    if (showRating) ...[
                      SizedBox(height: AppResponsive.h(0.5)),
                      Row(
                        children: [
                          Icon(
                            Remix.star_fill,
                            color: AppColors.warning,
                            size: AppResponsive.getResponsiveSize(16),
                          ),
                          SizedBox(width: AppResponsive.w(0.5)),
                          Text(
                            '4.9',
                            style: AppText.smallBold(color: AppColors.dark),
                          ),
                          SizedBox(width: AppResponsive.w(0.5)),
                          Text(
                            '(120 reviews)',
                            style: AppText.small(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppResponsive.h(2)),
          
          // WhatsApp button
          GestureDetector(
            onTap: () => _launchWhatsApp(phoneNumber),
            child: Container(
              padding: AppResponsive.padding(vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366), // WhatsApp color
                borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Remix.whatsapp_line,
                    color: Colors.white,
                    size: AppResponsive.getResponsiveSize(20),
                  ),
                  SizedBox(width: AppResponsive.w(2)),
                  Text(
                    'Chat via WhatsApp',
                    style: AppText.button(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOperationalHours() {
    return Container(
      padding: AppResponsive.padding(all: 3),
      decoration: BoxDecoration(
        color: AppColors.whiteOld,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Remix.time_line,
                color: AppColors.primary,
                size: AppResponsive.getResponsiveSize(20),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Jam Operasional',
                style: AppText.h6(color: AppColors.dark),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(2)),
          
          _buildTimeRow('Senin - Jumat', '08:00 - 17:00'),
          SizedBox(height: AppResponsive.h(1)),
          _buildTimeRow('Sabtu', '09:00 - 15:00'),
          SizedBox(height: AppResponsive.h(1)),
          _buildTimeRow('Minggu', 'Tutup', isOff: true),
          
          SizedBox(height: AppResponsive.h(2)),
          
          Text(
            'Respon chat dapat lebih lambat di luar jam operasional.',
            style: AppText.small(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeRow(String day, String hours, {bool isOff = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: AppText.p(color: AppColors.dark),
        ),
        Text(
          hours,
          style: AppText.pSmallBold(
            color: isOff ? AppColors.danger : AppColors.dark,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAdditionalInfo() {
    return Container(
      padding: AppResponsive.padding(all: 3),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(16)),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Remix.information_line,
                color: AppColors.info,
                size: AppResponsive.getResponsiveSize(20),
              ),
              SizedBox(width: AppResponsive.w(2)),
              Text(
                'Informasi Tambahan',
                style: AppText.h6(color: AppColors.dark),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.h(1.5)),
          
          Text(
            'Untuk penawaran khusus dan negosiasi harga, silakan hubungi marketing specialist kami melalui WhatsApp.',
            style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
          ),
          
          SizedBox(height: AppResponsive.h(1.5)),
          
          Text(
            'Tim admin kami siap membantu jika Anda mengalami kendala dalam penggunaan aplikasi atau memiliki pertanyaan terkait layanan kami.',
            style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
  
  void _launchWhatsApp(String phoneNumber) async {
    final formattedPhone = phoneNumber.startsWith('0') 
        ? '62${phoneNumber.substring(1)}' 
        : phoneNumber;
    
    const message = 'Halo, saya ingin bertanya tentang...';
    
    final whatsappUrl = Uri.parse(
      'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}'
    );
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka WhatsApp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  }
}
