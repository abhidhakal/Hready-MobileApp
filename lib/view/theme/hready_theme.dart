import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF042F46);

Map<int, Color> primaryColorSwatch = {
  50: Color(0xFFE1E8EB),
  100: Color(0xFFB3C5D0),
  200: Color(0xFF80A0B1),
  300: Color(0xFF4D7B91),
  400: Color(0xFF265F79),
  500: primaryColor,
  600: Color(0xFF032C40),
  700: Color(0xFF022435),
  800: Color(0xFF021D2B),
  900: Color(0xFF01101A),
};

MaterialColor customPrimarySwatch = MaterialColor(primaryColor.value, primaryColorSwatch);

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    primarySwatch: customPrimarySwatch,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    fontFamily: "Poppins Medium",
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Color(0xFF191919)),
      labelStyle: TextStyle(color: Color(0xFF191919)),
      floatingLabelStyle: TextStyle(color: Color(0xFF191919)),
      iconColor: Color(0xFF191919),
      prefixIconColor: Color(0xFF191919),
      suffixIconColor: Color(0xFF191919),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
