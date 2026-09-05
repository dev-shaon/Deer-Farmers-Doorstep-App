import 'package:flutter/material.dart';

Color hexToColor(String? hex) {
  if (hex == null || hex.isEmpty) return Colors.red;
  try {
    String cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
    return Colors.red;
  } catch (e) {
    return Colors.red;
  }
}

double colorToHue(Color color) {
  final HSVColor hsv = HSVColor.fromColor(color);
  return hsv.hue;
}