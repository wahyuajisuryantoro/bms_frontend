import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/akun_detail_controller.dart';

class AkunDetailView extends GetView<AkunDetailController> {
  const AkunDetailView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Detail Akun',
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
        actions: [
          Obx(() => IconButton(
            onPressed: controller.toggleEditMode,
            icon: Icon(
              controller.isEditMode.value
                  ? Remix.close_line
                  : Remix.edit_line,
              color: controller.isEditMode.value
                  ? AppColors.danger
                  : AppColors.dark,
              size: AppResponsive.getResponsiveSize(24),
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isSaving.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppResponsive.padding(all: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto profil dengan tombol edit
              Center(
                child: Stack(
                  children: [
                    // Foto profil
                    Container(
                      width: AppResponsive.h(14),
                      height: AppResponsive.h(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.1),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppResponsive.h(14)),
                        child: Image.asset(
                          controller.userData['profileImage'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.muted,
                              child: Icon(
                                Remix.user_3_fill,
                                size: AppResponsive.h(7),
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Tombol edit foto
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: AppResponsive.padding(all: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Remix.camera_line,
                          color: Colors.white,
                          size: AppResponsive.getResponsiveSize(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.h(4)),

              // Detail informasi
              controller.isEditMode.value 
                ? _buildEditForm(context)
                : _buildProfileDetails(context),
                
              SizedBox(height: AppResponsive.h(8)), // Memberikan ruang di bawah form
              
              // Tampilkan tombol save hanya dalam mode edit
              if (controller.isEditMode.value)
                _buildSaveButton(),
            ],
          ),
        );
      }),
    );
  }

  // Widget untuk menampilkan detail profil dalam mode view
  Widget _buildProfileDetails(BuildContext context) {
    return Container(
      padding: AppResponsive.padding(all: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
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
          Text(
            'Informasi Pribadi',
            style: AppText.h5(color: AppColors.dark),
          ),
          SizedBox(height: AppResponsive.h(3)),

          // Informasi detail
          _buildInfoItem(
            context,
            icon: Remix.user_3_line,
            label: 'Nama Lengkap',
            value: controller.userData['name'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.mail_line,
            label: 'Email',
            value: controller.userData['email'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.phone_line,
            label: 'Telepon',
            value: controller.userData['phone'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.user_2_line,
            label: 'Jenis Kelamin',
            value: controller.userData['gender'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.calendar_line,
            label: 'Tanggal Lahir',
            value: controller.userData['birthDate'] ?? '-',
          ),
          SizedBox(height: AppResponsive.h(3)),

          // Alamat
          Text(
            'Alamat',
            style: AppText.h5(color: AppColors.dark),
          ),
          SizedBox(height: AppResponsive.h(2)),
          _buildInfoItem(
            context,
            icon: Remix.map_pin_line,
            label: 'Alamat Lengkap',
            value: controller.userData['address'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.building_2_line,
            label: 'Kota/Kabupaten',
            value: controller.userData['city'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.map_pin_2_line,
            label: 'Provinsi',
            value: controller.userData['province'] ?? '-',
          ),
          _buildInfoItem(
            context,
            icon: Remix.mail_send_line,
            label: 'Kode Pos',
            value: controller.userData['postalCode'] ?? '-',
            isLast: true,
          ),
        ],
      ),
    );
  }

  // Widget untuk item informasi
  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: AppResponsive.padding(all: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppResponsive.getResponsiveSize(20),
              ),
            ),
            SizedBox(width: AppResponsive.w(3)),

            // Text information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppText.caption(color: AppColors.grey),
                  ),
                  SizedBox(height: AppResponsive.h(0.5)),
                  Text(
                    value,
                    style: AppText.bodyMedium(color: AppColors.dark),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: AppResponsive.padding(vertical: 2),
            child: Divider(color: AppColors.muted),
          ),
      ],
    );
  }

  // Widget untuk form edit profil
  Widget _buildEditForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        padding: AppResponsive.padding(all: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(20)),
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
            Text(
              'Informasi Pribadi',
              style: AppText.h5(color: AppColors.dark),
            ),
            SizedBox(height: AppResponsive.h(3)),

            // Nama Lengkap
            _buildTextField(
              label: 'Nama Lengkap',
              hintText: 'Masukkan nama lengkap',
              controller: controller.nameController,
              validator: controller.validateName,
              icon: Remix.user_3_line,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Email
            _buildTextField(
              label: 'Email',
              hintText: 'Masukkan email',
              controller: controller.emailController,
              validator: controller.validateEmail,
              icon: Remix.mail_line,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Telepon
            _buildTextField(
              label: 'Telepon',
              hintText: 'Masukkan nomor telepon',
              controller: controller.phoneController,
              validator: controller.validatePhone,
              icon: Remix.phone_line,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Jenis Kelamin
            _buildDropdownField(
              label: 'Jenis Kelamin',
              icon: Remix.user_2_line,
            ),
            SizedBox(height: AppResponsive.h(3)),

            // Alamat
            Text(
              'Alamat',
              style: AppText.h5(color: AppColors.dark),
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Alamat Lengkap
            _buildTextField(
              label: 'Alamat Lengkap',
              hintText: 'Masukkan alamat lengkap',
              controller: controller.addressController,
              icon: Remix.map_pin_line,
              maxLines: 2,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Kota/Kabupaten
            _buildTextField(
              label: 'Kota/Kabupaten',
              hintText: 'Masukkan kota/kabupaten',
              controller: controller.cityController,
              icon: Remix.building_2_line,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Provinsi
            _buildTextField(
              label: 'Provinsi',
              hintText: 'Masukkan provinsi',
              controller: controller.provinceController,
              icon: Remix.map_pin_2_line,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Kode Pos
            _buildTextField(
              label: 'Kode Pos',
              hintText: 'Masukkan kode pos',
              controller: controller.postalCodeController,
              icon: Remix.mail_send_line,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk text field
  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
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
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppText.bodyMedium(color: AppColors.dark),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppText.bodyMedium(color: AppColors.grey.withOpacity(0.5)),
            prefixIcon: Icon(
              icon,
              color: AppColors.primary,
              size: AppResponsive.getResponsiveSize(20),
            ),
            filled: true,
            fillColor: AppColors.muted.withOpacity(0.3),
            contentPadding: AppResponsive.padding(vertical: 1.5, horizontal: 2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              borderSide: BorderSide(color: AppColors.danger, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              borderSide: BorderSide(color: AppColors.danger, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk dropdown field
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.muted.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedGender.value,
                icon: Icon(
                  Remix.arrow_down_s_line,
                  color: AppColors.dark,
                ),
                style: AppText.bodyMedium(color: AppColors.dark),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    icon,
                    color: AppColors.primary,
                    size: AppResponsive.getResponsiveSize(20),
                  ),
                  contentPadding: AppResponsive.padding(vertical: 1.5, horizontal: 2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                items: controller.genderOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedGender.value = newValue;
                  }
                },
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
              )),
        ),
      ],
    );
  }
  
  // Widget untuk tombol simpan
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: AppResponsive.h(6),
      child: ElevatedButton.icon(
        onPressed: controller.updateUserData,
        icon: Icon(Remix.save_line, color: Colors.white),
        label: Text(
          'Simpan Perubahan',
          style: AppText.button(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}