import 'package:get/get.dart';

class KebijakanDanPrivasiController extends GetxController {
  // Data kebijakan privasi
  final List<PrivacySection> privacySections = [
    PrivacySection(
      title: 'Informasi yang Kami Kumpulkan',
      content: 'Kami mengumpulkan beberapa jenis informasi dari pengguna aplikasi BMS, termasuk:\n'
          '• Informasi Pribadi: Nama, alamat email, nomor telepon, dan alamat.\n'
          '• Informasi Kendaraan: Detail kendaraan yang Anda jual atau beli melalui layanan kami.\n'
          '• Informasi Penggunaan: Data tentang bagaimana Anda menggunakan aplikasi, termasuk waktu akses, fitur yang digunakan, dan interaksi dengan konten.',
    ),
    PrivacySection(
      title: 'Bagaimana Kami Menggunakan Informasi',
      content: 'Informasi yang dikumpulkan digunakan untuk:\n'
          '• Menyediakan dan memelihara layanan kami.\n'
          '• Mengirimkan pemberitahuan terkait layanan, pembaruan, dan pesan promosi.\n'
          '• Memproses transaksi dan mengirimkan informasi terkait pembelian.\n'
          '• Meningkatkan layanan dan pengalaman pengguna.\n'
          '• Berkomunikasi dengan Anda tentang pertanyaan, permintaan, atau komentar.',
    ),
    PrivacySection(
      title: 'Berbagi Informasi',
      content: 'Kami dapat berbagi informasi Anda dengan:\n'
          '• Mitra Bisnis: Penyedia layanan yang membantu kami dalam menjalankan aplikasi dan layanan.\n'
          '• Pihak Berwenang: Jika diwajibkan oleh hukum atau untuk melindungi hak dan keamanan.\n'
          '• Calon Pembeli/Penjual: Informasi kontak dapat dibagikan antara calon pembeli dan penjual untuk memfasilitasi transaksi.\n\n'
          'Kami tidak akan menjual informasi pribadi Anda kepada pihak ketiga untuk tujuan pemasaran tanpa persetujuan Anda.',
    ),
    PrivacySection(
      title: 'Keamanan Data',
      content: 'Kami berkomitmen untuk melindungi informasi pribadi Anda. Kami menerapkan langkah-langkah keamanan fisik, elektronik, dan prosedural yang sesuai untuk melindungi informasi Anda dari akses yang tidak sah atau penggunaan yang tidak benar.',
    ),
    PrivacySection(
      title: 'Hak Pengguna',
      content: 'Anda memiliki hak untuk:\n'
          '• Mengakses dan meninjau informasi pribadi yang kami simpan tentang Anda.\n'
          '• Meminta koreksi informasi yang tidak akurat.\n'
          '• Meminta penghapusan data Anda dalam batas-batas hukum yang berlaku.\n'
          '• Membatasi atau menolak pemrosesan data pribadi Anda.\n'
          '• Menarik persetujuan Anda untuk pengumpulan atau pemrosesan data.',
    ),
    PrivacySection(
      title: 'Cookie dan Teknologi Pelacakan',
      content: 'Kami menggunakan cookie dan teknologi serupa untuk meningkatkan pengalaman pengguna, menganalisis tren, mengelola situs, dan mengumpulkan informasi demografis tentang basis pengguna kami secara keseluruhan. Anda dapat mengontrol penggunaan cookie melalui pengaturan browser Anda.',
    ),
    PrivacySection(
      title: 'Perubahan Kebijakan',
      content: 'Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Kami akan memberi tahu Anda tentang perubahan signifikan dengan memposting pemberitahuan di aplikasi atau mengirimkan pemberitahuan langsung. Kami mendorong Anda untuk meninjau Kebijakan Privasi ini secara berkala untuk mengetahui informasi terbaru tentang praktik privasi kami.',
    ),
    PrivacySection(
      title: 'Kontak Kami',
      content: 'Jika Anda memiliki pertanyaan atau kekhawatiran tentang Kebijakan Privasi kami atau praktik data kami, silakan hubungi tim dukungan pelanggan kami melalui:\n'
          '• Email: info@bursamobilsolo.com\n'
          '• Telepon: 081272602294\n'
          '• Alamat: Underpass Makam Haji, No. 384, Kartasura, SKH',
    ),
  ];

  // Tanggal terakhir pembaruan kebijakan privasi
  final String lastUpdated = '15 April 2024';
  
  // Rx variabel untuk melacak bagian yang diperluas
  final RxInt expandedIndex = RxInt(-1);
  
  // Toggle expand/collapse section
  void toggleSection(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // collapse if already expanded
    } else {
      expandedIndex.value = index; // expand this section
    }
  }
  
  // Check if section is expanded
  bool isSectionExpanded(int index) {
    return expandedIndex.value == index;
  }
}

// Model untuk section kebijakan privasi
class PrivacySection {
  final String title;
  final String content;
  
  PrivacySection({
    required this.title,
    required this.content,
  });
}