import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Obx(() {
        // Show loading indicator saat controller BELUM ready (isReady = false)
        if (!controller.isReady.value) {
          // PERBAIKAN: tambah negasi (!)
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Memuat...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        // Show main content setelah controller ready (isReady = true)
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: AppResponsive.padding(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: controller.isReady.value ? () => Get.back() : null,
                    child: Icon(
                      Icons.arrow_back,
                      color: controller.isReady.value
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      size: 28,
                    ),
                  ),
                  SizedBox(height: AppResponsive.h(2)),

                  // PERUBAHAN: Tambahkan Stack untuk background logo
                  Stack(
                    children: [
                      Positioned(
                        right: -40,
                        left: -35,
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            'assets/images/logo-login.png',
                            width: AppResponsive.w(13), // Responsive width
                            height: AppResponsive.h(13), // Responsive height
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Text di atas logo
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Selamat Datang Kembali!',
                              style: AppText.h5(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: AppResponsive.h(9)),
                          Text(
                            'Masuk ke akunmu dan temukan mobil\nimpian hari ini.',
                            style:
                                AppText.p(color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: AppResponsive.h(4)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppResponsive.padding(left: 2, bottom: 0.5),
                        child: Text(
                          'Email',
                          style: AppText.small(color: Colors.white),
                        ),
                      ),
                      Obx(() => Container(
                            height: AppResponsive.h(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: controller.emailError.value
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: controller.emailController,
                              enabled: controller.isReady.value,
                              cursorColor: AppColors.secondary,
                              style: AppText.p(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: AppResponsive.padding(
                                    horizontal: 3, vertical: 1.5),
                                hintText: 'Masukkan email',
                                hintStyle: AppText.p(
                                    color: Colors.white.withOpacity(0.5)),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                              onChanged: (value) =>
                                  controller.onEmailChanged(value),
                            ),
                          )),
                      Obx(() => controller.emailError.value
                          ? Padding(
                              padding: AppResponsive.padding(left: 2, top: 0.5),
                              child: Text(
                                controller.emailErrorText.value,
                                style: AppText.small(color: Colors.red),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                  SizedBox(height: AppResponsive.h(3)),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppResponsive.padding(left: 2, bottom: 0.5),
                        child: Text(
                          'Kata Sandi',
                          style: AppText.small(color: Colors.white),
                        ),
                      ),
                      Obx(() => Container(
                            height: AppResponsive.h(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: controller.passwordError.value
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: controller.passwordController,
                              enabled: controller.isReady
                                  .value, // PERBAIKAN: Enable jika ready
                              obscureText: !controller.passwordVisible.value,
                              cursorColor: AppColors.secondary,
                              style: AppText.p(color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: AppResponsive.padding(
                                    horizontal: 3, vertical: 1.5),
                                hintText: 'Masukkan kata sandi',
                                hintStyle: AppText.p(
                                    color: Colors.white.withOpacity(0.5)),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20,
                                ),
                                suffixIcon: InkWell(
                                  onTap: controller.isReady
                                          .value // PERBAIKAN: Check ready state
                                      ? () =>
                                          controller.togglePasswordVisibility()
                                      : null,
                                  child: Icon(
                                    controller.passwordVisible.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                              ),
                              onChanged: (value) => controller.onPasswordChanged(
                                  value), // PERBAIKAN: Gunakan method dari controller
                            ),
                          )),
                      // Password Error Text
                      Obx(() => controller.passwordError.value
                          ? Padding(
                              padding: AppResponsive.padding(left: 2, top: 0.5),
                              child: Text(
                                controller.passwordErrorText.value,
                                style: AppText.small(color: Colors.red),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.isReady.value
                          ? () => controller.forgotPassword()
                          : null,
                      child: Text(
                        'Lupa Kata Sandi?',
                        style: AppText.small(color: AppColors.secondary),
                      ),
                    ),
                  ),

                  SizedBox(height: AppResponsive.h(2)),

                  // Login Button
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: AppResponsive.h(6),
                        child: ElevatedButton(
                          onPressed: (controller.isLoading.value ||
                                  !controller.isReady
                                      .value) // PERBAIKAN: !isReady untuk disable
                              ? null
                              : () => controller.login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: (controller.isLoading.value ||
                                  !controller.isReady
                                      .value) // PERBAIKAN: !isReady untuk loading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                )
                              : Text(
                                  'Masuk',
                                  style:
                                      AppText.button(color: AppColors.primary),
                                ),
                        ),
                      )),

                  SizedBox(height: AppResponsive.h(2)),

                  // Register Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppText.small(color: Colors.white),
                        ),
                        InkWell(
                          onTap: controller.isReady.value 
                            ? () => controller.goToRegister()
                            : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.w(4),
                              vertical: AppResponsive.h(1),
                            ),
                            decoration: BoxDecoration(
                              color: controller.isReady.value 
                                ? Colors.white.withOpacity(0.15)
                                : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: controller.isReady.value
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Daftar Sekarang',
                              style: AppText.smallBold(
                                color: controller.isReady.value 
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.1) // PERBAIKAN: Disabled style jika belum ready
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}