import 'package:flutter/material.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/kebijakan_dan_privasi_controller.dart';

class KebijakanDanPrivasiView extends GetView<KebijakanDanPrivasiController> {
  const KebijakanDanPrivasiView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Kebijakan Privasi',
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
          // Header
          _buildHeader(),
          SizedBox(height: AppResponsive.h(3)),
          
          // Tanggal update
          _buildLastUpdatedInfo(),
          SizedBox(height: AppResponsive.h(3)),
          
          // Privacy Policy Sections
          ...List.generate(
            controller.privacySections.length,
            (index) => _buildPrivacySection(index),
          ),
          
          // Footer
          SizedBox(height: AppResponsive.h(4)),
        
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Remix.shield_check_line,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(28),
            ),
            SizedBox(width: AppResponsive.w(3)),
            Text(
              'Kebijakan Privasi',
              style: AppText.h4(color: AppColors.dark),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.h(2)),
        Text(
          'Dokumen ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda saat Anda menggunakan aplikasi dan layanan kami. Kami menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda.',
          style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
        ),
      ],
    );
  }
  
  Widget _buildLastUpdatedInfo() {
    return Container(
      width: double.infinity,
      padding: AppResponsive.padding(all: 2.5),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Remix.information_line,
            color: AppColors.info,
            size: AppResponsive.getResponsiveSize(20),
          ),
          SizedBox(width: AppResponsive.w(2)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
                children: [
                  const TextSpan(
                    text: 'Terakhir diperbarui: ',
                  ),
                  TextSpan(
                    text: controller.lastUpdated,
                    style: AppText.pSmallBold(color: AppColors.dark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPrivacySection(int index) {
    final section = controller.privacySections[index];
    
    return Obx(() {
      final isExpanded = controller.isSectionExpanded(index);
      
      return Column(
        children: [
          SizedBox(height: AppResponsive.h(2)),
          // Section header
          InkWell(
            onTap: () => controller.toggleSection(index),
            borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
            child: Container(
              width: double.infinity,
              padding: AppResponsive.padding(horizontal: 3, vertical: 2),
              decoration: BoxDecoration(
                color: isExpanded 
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.title,
                      style: AppText.h6(
                        color: isExpanded 
                            ? AppColors.primary
                            : AppColors.dark,
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.w(2)),
                  Icon(
                    isExpanded
                        ? Remix.arrow_up_s_line
                        : Remix.arrow_down_s_line,
                    color: isExpanded
                        ? AppColors.primary
                        : AppColors.grey,
                    size: AppResponsive.getResponsiveSize(24),
                  ),
                ],
              ),
            ),
          ),
          
          // Section content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: double.infinity,
              padding: isExpanded 
                  ? AppResponsive.padding(horizontal: 3, vertical: 2)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppResponsive.getResponsiveSize(10)),
                  bottomRight: Radius.circular(AppResponsive.getResponsiveSize(10)),
                ),
              ),
              child: isExpanded
                  ? Text(
                      section.content,
                      style: AppText.p(color: AppColors.dark.withOpacity(0.8)),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      );
    });
  }
  
  
}