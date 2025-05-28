import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sukses_verifikasi_email_controller.dart';

class SuksesVerifikasiEmailView
    extends GetView<SuksesVerifikasiEmailController> {
  const SuksesVerifikasiEmailView({super.key});
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: AppResponsive.padding(horizontal: 6, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppResponsive.h(5)),
              
              // Icon Email
              Container(
                padding: AppResponsive.padding(all: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: AppResponsive.h(8),
                ),
              ),
              
              SizedBox(height: AppResponsive.h(4)),
              
              // Judul
              Text(
                'Verifikasi Email',
                style: AppText.h3(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppResponsive.h(2)),
              
              // Deskripsi
              Obx(() => Text(
                'Kami telah mengirimkan link verifikasi ke\n${controller.email.value}',
                style: AppText.p(color: Colors.white.withOpacity(0.9)),
                textAlign: TextAlign.center,
              )),
              
              SizedBox(height: AppResponsive.h(2)),
              
              Text(
                'Silakan cek email Anda dan klik link verifikasi untuk mengaktifkan akun Anda.',
                style: AppText.p(color: Colors.white.withOpacity(0.9)),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppResponsive.h(4)),
              
              // Tombol Resend
              Obx(() => SizedBox(
                width: double.infinity,
                height: AppResponsive.h(6),
                child: ElevatedButton(
                  onPressed: controller.isLoading.value 
                    ? null 
                    : () => controller.resendVerification(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      )
                    : Text(
                        'Kirim Ulang Link Verifikasi',
                        style: AppText.button(color: AppColors.primary),
                      ),
                ),
              )),
              
              SizedBox(height: AppResponsive.h(2)),
              
              // Tombol ke Login
              SizedBox(
                width: double.infinity,
                height: AppResponsive.h(6),
                child: TextButton(
                  onPressed: () => controller.goToLogin(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.white.withOpacity(0.5))
                    ),
                  ),
                  child: Text(
                    'Kembali ke Halaman Login',
                    style: AppText.button(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
