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

// Current theme (can be toggled between dark and light)
bool isDarkMode = true;

// Getter functions for current theme colors
Color get globalColorDark => isDarkMode ? darkColorPrimary : lightColorPrimary;
Color get globalColorLight => isDarkMode ? darkColorAccent : lightColorAccent;
Color get globalBG => isDarkMode ? darkBG : lightBG;
Color get globalDarkBG => isDarkMode ? darkDarkBG : lightDarkBG;
Color get globalTextColor => isDarkMode ? darkTextColor : lightTextColor;


// Color globalColorDark =const Color.fromARGB(255, 0, 69, 75);
// Color globalColorLight =Colors.cyanAccent;

// Color globalBG = const Color.fromARGB(255, 59, 59, 59);
// Color globalDarkBG = const Color.fromARGB(255, 32, 32, 32);