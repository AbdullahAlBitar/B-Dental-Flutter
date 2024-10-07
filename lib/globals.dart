import 'package:flutter/material.dart';

const url = "https://b-dental.onrender.com";

// Dark mode colors
Color darkColorPrimary = const Color(0xFF00796B);  // Rich Teal
Color darkColorAccent = const Color(0xFF26C6DA);  // Vibrant Cyan
Color darkBG = const Color(0xFF263238);  // Rich Dark Blue-Gray
Color darkDarkBG = const Color(0xFF1A1A1A);  // Very Dark Gray
Color darkTextColor = Colors.white;  // White text for dark mode

// Light mode colors
Color lightColorPrimary = const Color(0xFF009688);  // Teal
Color lightColorAccent = const Color(0xFF00BCD4);  // Cyan
Color lightBG = const Color(0xFFF5F5F5);  // Light Gray
Color lightDarkBG = const Color(0xFFE0E0E0);  // Medium Gray
Color lightTextColor = const Color(0xFF212121);  // Black text for light mode

// Getter functions for current theme colors
Color getPrimaryColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? darkColorPrimary : lightColorPrimary;
}

Color getAccentColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? darkColorAccent : lightColorAccent;
}

Color getBackgroundColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? darkBG : lightBG;
}

Color getDarkBackgroundColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? darkDarkBG : lightDarkBG;
}

Color getTextColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark ? darkTextColor : lightTextColor;
}



// Color getPrimaryColor =const Color.fromARGB(255, 0, 69, 75);
// Color getAccentColor =Colors.cyanAccent;

// Color getBackgroundColor = const Color.fromARGB(255, 59, 59, 59);
// Color getDarkBackgroundColor = const Color.fromARGB(255, 32, 32, 32);