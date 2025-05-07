import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/bg-onboarding.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Dark Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),
          // Content Card
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  padding: AppResponsive.padding(horizontal: 4, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Logo - using SizedBox to ensure proper dimensions
                      Image.asset(
                        'assets/images/logo.png',
                        width: AppResponsive.w(33),
                      ),

                      SizedBox(height: AppResponsive.h(3)),

                      Text(
                        'Beli Mobil Jadi Lebih Mudah!',
                        style: AppText.h5(color: AppColors.dark),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: AppResponsive.h(1.5)),

                      Text(
                        'Temukan mobil impianmu dalam hitungan menit.',
                        style: AppText.pSmall(color: AppColors.grey),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: AppResponsive.h(4)),

                      SizedBox(
                        width: double.infinity,
                        height: AppResponsive.h(6),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.LOGIN);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Masuk',
                            style: AppText.button(color: AppColors.secondary),
                          ),
                        ),
                      ),

                     SizedBox(height: AppResponsive.h(2)),
                     
                      SizedBox(
                        width: double.infinity,
                        height: AppResponsive.h(6),
                        child: OutlinedButton(
                          onPressed: () {
                            Get.toNamed(Routes.REGISTER);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Daftar',
                            style: AppText.button(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
