import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        // primarySwatch: Color(0xFF042F46),
        fontFamily: "Poppins Medium",
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black,
          centerTitle: true
        )
      );
}