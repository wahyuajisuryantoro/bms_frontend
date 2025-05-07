import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TentangController extends GetxController {
  // Informasi dealer
  final dealerInfo = {
    'nama': 'BURSA MOBIL SOLO',
    'singkatan': 'BMS',
    'alamat': 'Underpass Makam Haji, No. 384',
    'kota': 'Kartasura, Sukoharjo',
    'phone': '81272602294',
    'email': 'info@bursamobilsolo.com',
    'instagram': '@bursamobilsolo',
  };
  
  // Layanan yang ditawarkan
  final servicesList = [
    {
      'title': 'Jual Beli Cash',
      'description': 'Proses cepat dan harga bersaing untuk pembelian tunai.',
      'icon': 'money_dollar_circle_line',
    },
    {
      'title': 'Kredit Mobil',
      'description': 'Cicilan ringan, syarat mudah, dan proses persetujuan cepat.',
      'icon': 'bank_card_line',
    },
    {
      'title': 'Tukar Tambah',
      'description': 'Nilai terbaik untuk mobil lama Anda dengan proses tukar tambah yang mudah.',
      'icon': 'exchange_line',
    },
  ];
  
  // Jam operasional 
  final operationalHours = [
    {'day': 'Senin - Sabtu', 'hours': '08:00 - 17:00 WIB', 'isOff': false},
    {'day': 'Minggu', 'hours': '09:00 - 15:00 WIB', 'isOff': false},
  ];
  
  // Buka URL di browser
  Future<void> launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Buka WhatsApp
  void openWhatsApp(String phoneNumber, {String message = ''}) {
    // Format nomor telepon (hapus "0" di awal jika ada dan tambahkan kode negara)
    final formattedPhone = phoneNumber.startsWith('0')
        ? '62${phoneNumber.substring(1)}'
        : phoneNumber;
        
    // Default pesan
    final whatsappMessage = message.isEmpty 
        ? 'Halo, saya ingin bertanya tentang mobil di BMS...'
        : message;
        
    // Buat URL WhatsApp
    final whatsappUrl = Uri.parse(
      'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(whatsappMessage)}'
    );
    
    // Buka WhatsApp
    launchUrl(whatsappUrl.toString());
  }
  
  // Telepon langsung
  void makePhoneCall(String phoneNumber) {
    // Format nomor telepon
    final formattedPhone = phoneNumber.startsWith('0')
        ? phoneNumber
        : '0$phoneNumber';
        
    // Buat URL telepon
    final telUrl = Uri.parse('tel:$formattedPhone');
    
    // Buka dialer telepon
    launchUrl(telUrl.toString());
  }
  
  // Buka email
  void sendEmail(String email, {String subject = '', String body = ''}) {
    final emailUrl = Uri.parse(
      'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}'
    );
    
    launchUrl(emailUrl.toString());
  }
  
  // Buka Instagram
  void openInstagram(String username) {
    // Hapus @ jika ada
    final formattedUsername = username.startsWith('@')
        ? username.substring(1)
        : username;
        
    // Coba buka di aplikasi
    launchUrl('instagram://user?username=$formattedUsername')
        .catchError((_) {
      // Fallback ke browser jika aplikasi tidak tersedia
      launchUrl('https://instagram.com/$formattedUsername');
    });
  }
  
  // Buka Maps dengan alamat dealer
  void openMaps(String address) {
    final query = Uri.encodeComponent('$address - BURSA MOBIL SOLO');
    launchUrl('https://maps.google.com/?q=$query');
  }
}