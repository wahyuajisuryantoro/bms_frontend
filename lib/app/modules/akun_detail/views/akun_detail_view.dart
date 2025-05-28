import 'package:dealer_mobil/app/components/loading_animation.dart';
import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:dealer_mobil/app/utils/app_responsive.dart';
import 'package:dealer_mobil/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'dart:io';
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
            onPressed: controller.isLoading.value ? null : controller.toggleEditMode,
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
        if (controller.isLoading.value) {
          return Center(
            child: AnimationLoading(
              width: AppResponsive.getResponsiveSize(150),
              height: AppResponsive.getResponsiveSize(150),
            ),
          );
        }
        
        if (controller.isSaving.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimationLoading(
                  width: AppResponsive.getResponsiveSize(150),
                  height: AppResponsive.getResponsiveSize(150),
                ),
                SizedBox(height: AppResponsive.h(2)),
                Text(
                  'Menyimpan perubahan...',
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppResponsive.padding(all: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto profil dengan tombol edit
              _buildProfilePhoto(),
              SizedBox(height: AppResponsive.h(4)),

              // Detail informasi
              controller.isEditMode.value 
                ? _buildEditForm(context)
                : _buildProfileDetails(context),
                
              SizedBox(height: AppResponsive.h(8)),
              
              // Tampilkan tombol save hanya dalam mode edit
              if (controller.isEditMode.value)
                _buildSaveButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfilePhoto() {
    return Center(
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
              child: Obx(() {
                // Show selected image if in edit mode
                if (controller.isEditMode.value && controller.selectedImageFile.value != null) {
                  return Image.file(
                    controller.selectedImageFile.value!,
                    fit: BoxFit.cover,
                  );
                }
                // Show profile image from server
                else if (controller.profileImageUrl.value.isNotEmpty) {
                  return Image.network(
                    controller.profileImageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  );
                }
                // Show default avatar
                else {
                  return _buildDefaultAvatar();
                }
              }),
            ),
          ),
          // Tombol edit foto (only in edit mode)
          if (controller.isEditMode.value)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.pickImage,
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
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.muted,
      child: Icon(
        Remix.user_3_fill,
        size: AppResponsive.h(7),
        color: AppColors.primary,
      ),
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
            label: 'No. WhatsApp',
            value: controller.userData['no_wa'] ?? '-',
          ),
          
          SizedBox(height: AppResponsive.h(3)),

          // Alamat
          Text(
            'Alamat',
            style: AppText.h5(color: AppColors.dark),
          ),
          SizedBox(height: AppResponsive.h(2)),
          
          if (controller.userData['alamat_lengkap'] != null && 
              controller.userData['alamat_lengkap'].toString().isNotEmpty)
            _buildInfoItem(
              context,
              icon: Remix.home_line,
              label: 'Alamat Lengkap',
              value: controller.userData['alamat_lengkap'] ?? '-',
            ),
          
          if (controller.userData['dusun'] != null && 
              controller.userData['dusun'].toString().isNotEmpty)
            _buildInfoItem(
              context,
              icon: Remix.community_line,
              label: 'Dusun',
              value: controller.userData['dusun'] ?? '-',
            ),
            
          if (controller.userData['village'] != null)
            _buildInfoItem(
              context,
              icon: Remix.map_pin_line,
              label: 'Kelurahan/Desa',
              value: controller.userData['village']['name'] ?? '-',
            ),
            
          if (controller.userData['district'] != null)
            _buildInfoItem(
              context,
              icon: Remix.map_2_line,
              label: 'Kecamatan',
              value: controller.userData['district']['name'] ?? '-',
            ),
            
          if (controller.userData['regency'] != null)
            _buildInfoItem(
              context,
              icon: Remix.building_2_line,
              label: 'Kota/Kabupaten',
              value: controller.userData['regency']['name'] ?? '-',
            ),
            
          if (controller.userData['province'] != null)
            _buildInfoItem(
              context,
              icon: Remix.map_pin_2_line,
              label: 'Provinsi',
              value: controller.userData['province']['name'] ?? '-',
            ),
            
          _buildInfoItem(
            context,
            icon: Remix.mail_send_line,
            label: 'Kode Pos',
            value: controller.userData['kode_pos'] ?? '-',
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

            // Email (Read-only)
            _buildTextField(
              label: 'Email',
              hintText: 'Email',
              controller: controller.emailController,
              icon: Remix.mail_line,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              fillColor: AppColors.muted.withOpacity(0.5),
            ),
            SizedBox(height: AppResponsive.h(2)),

            // No WhatsApp
            _buildTextField(
              label: 'No. WhatsApp',
              hintText: 'Contoh: 08123456789',
              controller: controller.noWaController,
              validator: controller.validatePhone,
              icon: Remix.phone_line,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppResponsive.h(3)),

            // Alamat
            Text(
              'Alamat',
              style: AppText.h5(color: AppColors.dark),
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Provinsi Dropdown
            _buildDropdownField(
              label: 'Provinsi',
              hintText: 'Pilih Provinsi',
              icon: Remix.map_pin_2_line,
              value: controller.selectedProvinceId.value,
              items: controller.provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province['id'].toString(),
                  child: Text(province['name'] ?? ''),
                );
              }).toList(),
              onChanged: controller.onProvinceChanged,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Kota/Kabupaten Dropdown
            _buildDropdownField(
              label: 'Kota/Kabupaten',
              hintText: 'Pilih Kota/Kabupaten',
              icon: Remix.building_2_line,
              value: controller.selectedRegencyId.value,
              items: controller.regencies.map((regency) {
                return DropdownMenuItem<String>(
                  value: regency['id'].toString(),
                  child: Text(regency['name'] ?? ''),
                );
              }).toList(),
              onChanged: controller.onRegencyChanged,
              enabled: controller.selectedProvinceId.value != null,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Kecamatan Dropdown
            _buildDropdownField(
              label: 'Kecamatan',
              hintText: 'Pilih Kecamatan',
              icon: Remix.map_2_line,
              value: controller.selectedDistrictId.value,
              items: controller.districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district['id'].toString(),
                  child: Text(district['name'] ?? ''),
                );
              }).toList(),
              onChanged: controller.onDistrictChanged,
              enabled: controller.selectedRegencyId.value != null,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Kelurahan/Desa Dropdown
            _buildDropdownField(
              label: 'Kelurahan/Desa',
              hintText: 'Pilih Kelurahan/Desa',
              icon: Remix.map_pin_line,
              value: controller.selectedVillageId.value,
              items: controller.villages.map((village) {
                return DropdownMenuItem<String>(
                  value: village['id'].toString(),
                  child: Text(village['name'] ?? ''),
                );
              }).toList(),
              onChanged: controller.onVillageChanged,
              enabled: controller.selectedDistrictId.value != null,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Dusun
            _buildTextField(
              label: 'Dusun',
              hintText: 'Masukkan nama dusun (opsional)',
              controller: controller.dusunController,
              icon: Remix.community_line,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Alamat Lengkap
            _buildTextField(
              label: 'Alamat Lengkap',
              hintText: 'Masukkan alamat lengkap (RT/RW, No. Rumah, dll)',
              controller: controller.alamatLengkapController,
              icon: Remix.home_line,
              maxLines: 3,
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Kode Pos
            _buildTextField(
              label: 'Kode Pos',
              hintText: 'Masukkan kode pos',
              controller: controller.kodePosController,
              validator: controller.validatePostalCode,
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
    bool readOnly = false,
    Color? fillColor,
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
          readOnly: readOnly,
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
            fillColor: fillColor ?? AppColors.muted.withOpacity(0.3),
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
    required String hintText,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    bool enabled = true,
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
            color: enabled ? AppColors.muted.withOpacity(0.3) : AppColors.muted.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hintText,
              style: AppText.bodyMedium(color: AppColors.grey.withOpacity(0.5)),
            ),
            icon: Icon(
              Remix.arrow_down_s_line,
              color: enabled ? AppColors.dark : AppColors.grey,
            ),
            style: AppText.bodyMedium(color: AppColors.dark),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: enabled ? AppColors.primary : AppColors.grey,
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
            items: items,
            onChanged: enabled ? onChanged : null,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(AppResponsive.getResponsiveSize(10)),
          ),
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