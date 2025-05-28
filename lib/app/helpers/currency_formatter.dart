import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatRupiah(dynamic value) {
    if (value == null) return 'Rp 0';
    
    try {
      // Konversi ke string dan bersihkan karakter non-digit
      String stringValue = value.toString().replaceAll(RegExp(r'[^\d.]'), '');
      
      // Jika berisi titik desimal, ambil hanya angka sebelum titik
      if (stringValue.contains('.')) {
        stringValue = stringValue.split('.')[0];
      }
      
      // Cek jika string kosong
      if (stringValue.isEmpty) return 'Rp 0';
      
      // Konversi ke double
      double numericValue = double.parse(stringValue);
      
      // KOREKSI: Bagi dengan 100 jika nilainya lebih dari 1 miliar
      // (asumsi: nilai dari server 100x lebih besar dari yang seharusnya)
      if (numericValue > 1000000000) {
        numericValue = numericValue / 100;
      }
      
      // Format dengan pemisah ribuan
      final formatter = NumberFormat('#,###', 'id');
      String formattedValue = formatter.format(numericValue);
      
      return 'Rp $formattedValue';
    } catch (e) {
      print('Error formatting currency: $e');
      return 'Rp 0';
    }
  }
}