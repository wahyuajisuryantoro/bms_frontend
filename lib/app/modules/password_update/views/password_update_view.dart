import 'package:dealer_mobil/app/components/loading_animation.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/password_update_controller.dart';

class PasswordUpdateView extends GetView<PasswordUpdateController> {
  const PasswordUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Update Password',
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
      body: Obx(() => controller.isLoading.value
          ? Center(
              child: AnimationLoading(
                width: AppResponsive.getResponsiveSize(150),
                height: AppResponsive.getResponsiveSize(150),
              ),
            )
          : _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppResponsive.padding(horizontal: 5, vertical: 3),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon dan header
            _buildHeader(),
            SizedBox(height: AppResponsive.h(4)),

            // Container untuk form password
            _buildPasswordForm(),

            // Error message
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? _buildErrorMessage()
                : SizedBox.shrink()),

            SizedBox(height: AppResponsive.h(4)),

            // Tombol aksi
            _buildActionButtons(),
          ],
        ),
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
              Remix.lock_password_line,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(36),
            ),
          ),
          SizedBox(height: AppResponsive.h(2)),
          Text(
            'Update Password',
            style: AppText.h4(color: AppColors.dark),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppResponsive.h(1)),
          Text(
            'Buat password yang kuat untuk melindungi akun Anda',
            style: AppText.p(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Container(
      padding: AppResponsive.padding(all: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
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
          // Password lama
          _buildPasswordField(
            controller: controller.oldPasswordController,
            label: 'Password Lama',
            hintText: 'Masukkan password lama Anda',
            icon: Remix.lock_line,
            validator: controller.validateOldPassword,
            isPasswordVisible: controller.oldPasswordVisible,
            togglePasswordVisibility: controller.toggleOldPasswordVisibility,
          ),
          SizedBox(height: AppResponsive.h(3)),

          // Password baru
          _buildPasswordField(
            controller: controller.newPasswordController,
            label: 'Password Baru',
            hintText: 'Masukkan password baru Anda',
            icon: Remix.lock_password_line,
            validator: controller.validateNewPassword,
            isPasswordVisible: controller.newPasswordVisible,
            togglePasswordVisibility: controller.toggleNewPasswordVisibility,
            showStrengthIndicator: true,
          ),
          SizedBox(height: AppResponsive.h(3)),

          // Konfirmasi password baru
          _buildPasswordField(
            controller: controller.confirmPasswordController,
            label: 'Konfirmasi Password Baru',
            hintText: 'Masukkan kembali password baru Anda',
            icon: Remix.lock_password_fill,
            validator: controller.validateConfirmPassword,
            isPasswordVisible: controller.confirmPasswordVisible,
            togglePasswordVisibility:
                controller.toggleConfirmPasswordVisibility,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    required RxBool isPasswordVisible,
    required Function() togglePasswordVisibility,
    bool showStrengthIndicator = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.bodyMedium(color: AppColors.dark).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppResponsive.h(1)),
        Obx(() => TextFormField(
              controller: controller,
              validator: validator,
              obscureText: !isPasswordVisible.value,
              style: AppText.bodyMedium(color: AppColors.dark),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    AppText.bodyMedium(color: AppColors.grey.withOpacity(0.5)),
                prefixIcon: Icon(
                  icon,
                  color: AppColors.primary,
                  size: AppResponsive.getResponsiveSize(20),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Remix.eye_line
                        : Remix.eye_off_line,
                    color: AppColors.grey,
                    size: AppResponsive.getResponsiveSize(20),
                  ),
                  onPressed: togglePasswordVisibility,
                ),
                filled: true,
                fillColor: AppColors.muted.withOpacity(0.3),
                contentPadding:
                    AppResponsive.padding(vertical: 1.5, horizontal: 2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppResponsive.getResponsiveSize(10)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppResponsive.getResponsiveSize(10)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppResponsive.getResponsiveSize(10)),
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppResponsive.getResponsiveSize(10)),
                  borderSide: BorderSide(color: AppColors.danger, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppResponsive.getResponsiveSize(10)),
                  borderSide: BorderSide(color: AppColors.danger, width: 1),
                ),
              ),
            )),
        if (showStrengthIndicator)
          Obx(() {
            final password = this.controller.passwordText.value;
            final strength = this.controller.passwordStrength.value;
            final color = this.controller.passwordStrengthColor.value;
            final label = this.controller.passwordStrengthLabel.value;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppResponsive.h(1.5)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      AppResponsive.getResponsiveSize(5)),
                  child: TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: strength,
                    ),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: AppColors.muted,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: AppResponsive.h(0.8),
                    ),
                  ),
                ),
                
                SizedBox(height: AppResponsive.h(0.5)),
                
                // Strength label
                if (password.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        'Kekuatan Password: ',
                        style: AppText.small(color: AppColors.grey),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: Text(
                          label,
                          key: ValueKey<String>(label),
                          style: AppText.smallBold(color: color),
                        ),
                      ),
                    ],
                  ),
                
                SizedBox(height: AppResponsive.h(1)),
                
                // Password tips
                if (password.isNotEmpty && strength < 0.75)
                  Container(
                    padding: AppResponsive.padding(all: 2),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                          AppResponsive.getResponsiveSize(10)),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips untuk password yang kuat:',
                          style: AppText.smallBold(color: AppColors.dark),
                        ),
                        SizedBox(height: AppResponsive.h(0.5)),
                        // Menggunakan Obx untuk masing-masing kriteria password
                        Obx(() => _buildPasswordTip(
                            'Minimal 8 karakter', 
                            this.controller.hasMinLengthValue.value)),
                        Obx(() => _buildPasswordTip(
                            'Mengandung huruf besar dan kecil',
                            this.controller.hasUpperAndLowerCaseValue.value)),
                        Obx(() => _buildPasswordTip(
                            'Mengandung angka',
                            this.controller.hasDigitsValue.value)),
                        Obx(() => _buildPasswordTip(
                            'Mengandung karakter khusus (misalnya: !@#\$&)',
                            this.controller.hasSpecialCharsValue.value)),
                      ],
                    ),
                  ),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildPasswordTip(String text, bool isValid) {
    return Padding(
      padding: AppResponsive.padding(vertical: 0.3),
      child: Row(
        children: [
          // Animasi ketika status isValid berubah
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isValid ? Remix.check_line : Remix.close_line,
              key: ValueKey<bool>(isValid),
              color: isValid ? AppColors.success : AppColors.danger,
              size: AppResponsive.getResponsiveSize(14),
            ),
          ),
          SizedBox(width: AppResponsive.w(1)),
          Text(
            text,
            style: AppText.small(
              color: AppColors.dark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: AppResponsive.margin(vertical: 2),
      padding: AppResponsive.padding(all: 2),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
        border: Border.all(
          color: AppColors.danger.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Remix.error_warning_line,
            color: AppColors.danger,
            size: AppResponsive.getResponsiveSize(20),
          ),
          SizedBox(width: AppResponsive.w(2)),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: AppText.p(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Tombol batal
        Expanded(
          child: OutlinedButton(
            onPressed: controller.cancel,
            style: OutlinedButton.styleFrom(
              padding: AppResponsive.padding(vertical: 1.5),
              side: BorderSide(color: AppColors.dark.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppResponsive.getResponsiveSize(12)),
              ),
            ),
            child: Text(
              'Batal',
              style: AppText.button(color: AppColors.dark),
            ),
          ),
        ),
        SizedBox(width: AppResponsive.w(3)),

        // Tombol update
        Expanded(
          child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: AppResponsive.padding(vertical: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppResponsive.getResponsiveSize(12)),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: AppResponsive.getResponsiveSize(20),
                        width: AppResponsive.getResponsiveSize(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Update Password',
                        style: AppText.button(color: Colors.white),
                      ),
              )),
        ),
      ],
    );
  }
}