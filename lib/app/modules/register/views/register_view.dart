import 'package:dealer_mobil/app/routes/app_pages.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 6, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(height: AppResponsive.h(4)),
                Text(
                  'Daftar untuk Mulai!',
                  style: AppText.h3(color: Colors.white),
                ),
                SizedBox(height: AppResponsive.h(2)),
                Text(
                  'Buat akun barumu dapatkan mobil\n dengan cepat & aman.',
                  style: AppText.p(color: Colors.white.withOpacity(0.9)),
                ),
                SizedBox(height: AppResponsive.h(5)),

                // Nama
                Padding(
                  padding: AppResponsive.padding(left: 2, bottom: 0.5),
                  child: Text(
                    'Nama',
                    style: AppText.small(color: Colors.white),
                  ),
                ),
                Obx(() => Container(
                      height: AppResponsive.h(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: controller.nameError.value
                              ? Colors.red
                              : Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.nameController,
                        cursorColor: AppColors.secondary,
                        style: AppText.p(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: AppResponsive.padding(
                              horizontal: 3, vertical: 1.5),
                          hintStyle:
                              AppText.p(color: Colors.white.withOpacity(0.5)),
                        ),
                        onChanged: (_) {
                          if (controller.nameError.value) {
                            controller.nameError.value = false;
                          }
                        },
                      ),
                    )),
                Obx(() => controller.nameError.value
                    ? Padding(
                        padding: AppResponsive.padding(left: 2, top: 1),
                        child: Text(
                          controller.nameErrorText.value,
                          style: AppText.small(color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: AppResponsive.h(3)),

                // Email
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
                        cursorColor: AppColors.secondary,
                        style: AppText.p(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: AppResponsive.padding(
                              horizontal: 3, vertical: 1.5),
                          hintStyle:
                              AppText.p(color: Colors.white.withOpacity(0.5)),
                        ),
                        onChanged: (_) {
                          if (controller.emailError.value) {
                            controller.emailError.value = false;
                          }
                        },
                      ),
                    )),
                Obx(() => controller.emailError.value
                    ? Padding(
                        padding: AppResponsive.padding(left: 2, top: 1),
                        child: Text(
                          controller.emailErrorText.value,
                          style: AppText.small(color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: AppResponsive.h(3)),

                // Nomor WhatsApp (dengan format otomatis)
                Padding(
                  padding: AppResponsive.padding(left: 2, bottom: 0.5),
                  child: Text(
                    'Nomor WhatsApp',
                    style: AppText.small(color: Colors.white),
                  ),
                ),
                Obx(() => Container(
                      height: AppResponsive.h(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: controller.noWaError.value
                              ? Colors.red
                              : Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.noWaController,
                        cursorColor: AppColors.secondary,
                        style: AppText.p(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: AppResponsive.padding(
                              horizontal: 3, vertical: 1.5),
                          hintText: '628xxxxxxxxxx',
                          hintStyle:
                              AppText.p(color: Colors.white.withOpacity(0.5)),
                        ),
                        onChanged: (_) {
                          if (controller.noWaError.value) {
                            controller.noWaError.value = false;
                          }
                        },
                      ),
                    )),
                Obx(() => controller.noWaError.value
                    ? Padding(
                        padding: AppResponsive.padding(left: 2, top: 1),
                        child: Text(
                          controller.noWaErrorText.value,
                          style: AppText.small(color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: AppResponsive.h(3)),

                // Kata Sandi (dengan icon visibility)
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
                        obscureText: !controller.isPasswordVisible.value,
                        cursorColor: AppColors.secondary,
                        style: AppText.p(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: AppResponsive.padding(
                              horizontal: 3, vertical: 1.5),
                          hintStyle:
                              AppText.p(color: Colors.white.withOpacity(0.5)),
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Remix.eye_line
                                  : Remix.eye_off_line,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          if (controller.passwordError.value) {
                            controller.passwordError.value = false;
                          }
                        },
                      ),
                    )),
                Obx(() => controller.passwordError.value
                    ? Padding(
                        padding: AppResponsive.padding(left: 2, top: 1),
                        child: Text(
                          controller.passwordErrorText.value,
                          style: AppText.small(color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: AppResponsive.h(3)),

                // Konfirmasi Kata Sandi (dengan icon visibility)
                Padding(
                  padding: AppResponsive.padding(left: 2, bottom: 0.5),
                  child: Text(
                    'Konfirmasi Kata Sandi',
                    style: AppText.small(color: Colors.white),
                  ),
                ),
                Obx(() => Container(
                      height: AppResponsive.h(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: controller.confirmPasswordError.value
                              ? Colors.red
                              : Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        cursorColor: AppColors.secondary,
                        style: AppText.p(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: AppResponsive.padding(
                              horizontal: 3, vertical: 1.5),
                          hintStyle:
                              AppText.p(color: Colors.white.withOpacity(0.5)),
                          suffixIcon: IconButton(
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Remix.eye_line
                                  : Remix.eye_off_line,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          if (controller.confirmPasswordError.value) {
                            controller.confirmPasswordError.value = false;
                          }
                        },
                      ),
                    )),
                Obx(() => controller.confirmPasswordError.value
                    ? Padding(
                        padding: AppResponsive.padding(left: 2, top: 1),
                        child: Text(
                          controller.confirmPasswordErrorText.value,
                          style: AppText.small(color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: AppResponsive.h(4)),

                // Tombol Daftar
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: AppResponsive.h(6),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.register(),
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              )
                            : Text(
                                'Daftar',
                                style: AppText.button(color: AppColors.primary),
                              ),
                      ),
                    )),

                SizedBox(height: AppResponsive.h(2)),

                // Link ke halaman Login
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: AppText.small(color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        child: Text(
                          'Masuk Sekarang',
                          style: AppText.smallBold(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
