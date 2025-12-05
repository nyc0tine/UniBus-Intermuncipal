import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    String formatted = '';

    if (text.length >= 1) {
      formatted = '(${text.substring(0, min(text.length, 2))}';
    }
    if (text.length >= 3) {
      formatted += ') ${text.substring(2, min(text.length, 7))}';
    }
    if (text.length > 7) {
      formatted += '-${text.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  int min(int a, int b) => (a < b) ? a : b;
}
