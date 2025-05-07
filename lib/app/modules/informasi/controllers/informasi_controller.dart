import 'dart:io';

import 'package:dealer_mobil/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class InformasiController extends GetxController {
 final adminContact = {
    'title': 'Admin Layanan Pelanggan',
    'subtitle': 'Bantuan seputar aplikasi dan layanan',
    'phone': '089603816531',
    'icon': Remix.customer_service_2_line,
    'iconColor': AppColors.info,
  };
  
  final sellerContacts = [
    {
      'title': 'Dealer Mobil Jakarta',
      'subtitle': 'Layanan penjualan dan informasi produk',
      'phone': '089603816531',
      'icon': Remix.store_2_line,
      'iconColor': AppColors.primary,
      'rating': 4.9,
      'reviewCount': 120,
    },
    {
      'title': 'Marketing Specialist',
      'subtitle': 'Konsultasi pembelian dan kredit',
      'phone': '089603816531',
      'icon': Remix.user_3_line,
      'iconColor': AppColors.primary,
    },
  ];
  
  // Operational hours
  final operationalHours = [
    {'day': 'Senin - Jumat', 'hours': '08:00 - 17:00', 'isOff': false},
    {'day': 'Sabtu', 'hours': '09:00 - 15:00', 'isOff': false},
    {'day': 'Minggu', 'hours': 'Tutup', 'isOff': true},
  ];
  
  // Additional info
  final additionalInfo = [
    'Untuk penawaran khusus dan negosiasi harga, silakan hubungi marketing specialist kami melalui WhatsApp.',
    'Tim admin kami siap membantu jika Anda mengalami kendala dalam penggunaan aplikasi atau memiliki pertanyaan terkait layanan kami.',
  ];
  
  // Launch WhatsApp dengan url_launcher yang aman
  Future<void> launchWhatsApp(String phoneNumber) async {
    try {
      // Format the phone number properly
      final formattedPhone = phoneNumber.startsWith('0')
          ? '62${phoneNumber.substring(1)}'
          : phoneNumber;
          
      // Default message
      const message = 'Halo, saya ingin bertanya tentang...';
      
      // Create different URLs for different platforms to maximize compatibility
      Uri whatsappUri;
      
      if (Platform.isAndroid) {
        // Specific approach for Android
        whatsappUri = Uri.parse("https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}");
      } else if (Platform.isIOS) {
        // Specific approach for iOS
        whatsappUri = Uri.parse("https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}");
      } else {
        // Web/desktop fallback
        whatsappUri = Uri.parse("https://web.whatsapp.com/send?phone=$formattedPhone&text=${Uri.encodeComponent(message)}");
      }
      
      // Safely launch URL with proper error handling
      _safeLaunchUrl(whatsappUri, phoneNumber);
      
    } catch (e) {
      showErrorMessage('Terjadi kesalahan: ${e.toString()}');
    }
  }
  
  // Safe method to launch URLs with proper fallbacks
  Future<void> _safeLaunchUrl(Uri uri, String phoneNumber) async {
    try {
      // Check if the URL can be launched
      // Wrapped in try-catch to handle any unexpected errors
      final canLaunch = await canLaunchUrl(uri).catchError((error) {
        // Specific handling for channel-error which is common with url_launcher
        if (error.toString().contains('channel-error')) {
          return false;
        }
        throw error; // Re-throw other errors
      });
      
      if (canLaunch) {
        // Launch with specific mode to ensure it opens in external app
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        ).catchError((error) {
          // If launching fails, show the manual dialog
          showManualWhatsAppDialog(phoneNumber);
          return false;
        });
      } else {
        // If canLaunchUrl returns false, show the manual dialog
        showManualWhatsAppDialog(phoneNumber);
      }
    } catch (e) {
      // Catch-all for any other errors
      showManualWhatsAppDialog(phoneNumber);
    }
  }
  
  // Show error message
  void showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.danger,
      colorText: Colors.white,
      margin: EdgeInsets.all(20),
      duration: Duration(seconds: 3),
      icon: Icon(
        Remix.error_warning_line,
        color: Colors.white,
      ),
    );
  }
  
  // Show dialog with manual WhatsApp instructions
  void showManualWhatsAppDialog(String phoneNumber) {
    final formattedPhone = phoneNumber.startsWith('0')
        ? '62${phoneNumber.substring(1)}'
        : phoneNumber;
        
    Get.dialog(
      AlertDialog(
        title: Text('Buka WhatsApp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Silakan buka WhatsApp dan tambahkan kontak ini secara manual:'),
            SizedBox(height: 16),
            SelectableText(
              phoneNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text('Atau buka link ini di browser:'),
            SizedBox(height: 8),
            SelectableText(
              'https://wa.me/$formattedPhone',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
