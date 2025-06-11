import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatRupiah(dynamic value) {
    if (value == null) return 'Rp 0';
    
    try {
      String stringValue = value.toString().replaceAll(RegExp(r'[^\d.]'), '');
      
      if (stringValue.contains('.')) {
        stringValue = stringValue.split('.')[0];
      }
      
      if (stringValue.isEmpty) return 'Rp 0';
      
      double numericValue = double.parse(stringValue);
      
      if (numericValue > 1000000000) {
        numericValue = numericValue / 100;
      }
      final formatter = NumberFormat('#,###', 'id');
      String formattedValue = formatter.format(numericValue);
      
      return 'Rp $formattedValue';
    } catch (e) {
      print('Error formatting currency: $e');
      return 'Rp 0';
    }
  }
}