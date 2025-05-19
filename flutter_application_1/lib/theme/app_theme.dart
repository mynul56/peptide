import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF45CFDD),
          brightness: Brightness.light,
          primary: const Color(0xFF45CFDD),
          secondary: const Color(0xFF32BACF),
          surface: Colors.white,
          background: const Color(0xFFF6F7FB),
        ),
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          bodyLarge: const TextStyle(fontWeight: FontWeight.normal),
          bodyMedium: const TextStyle(fontWeight: FontWeight.normal),
          titleLarge: const TextStyle(fontWeight: FontWeight.bold),
          titleMedium: const TextStyle(fontWeight: FontWeight.w600),
          titleSmall: const TextStyle(fontWeight: FontWeight.w500),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF45CFDD),
          brightness: Brightness.dark,
          primary: const Color(0xFF45CFDD),
          secondary: const Color(0xFF32BACF),
          surface: const Color(0xFF232526),
          background: const Color(0xFF18191A),
          error: const Color(0xFFCF6679),
          onBackground: Colors.white,
          onSurface: Colors.white,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        ),
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          bodyLarge: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          bodyMedium: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white70),
          titleLarge: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          titleMedium: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          titleSmall: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xFF18191A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF232526),
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF232526),
          elevation: 2,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF45CFDD), width: 0.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF232526),
          labelStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          hintStyle: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w400),
          helperStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w400),
          counterStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w400),
          prefixIconColor: Colors.white70,
          suffixIconColor: Colors.white70,
          floatingLabelStyle: const TextStyle(color: Color(0xFF45CFDD), fontWeight: FontWeight.w600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF45CFDD), width: 2),
          ),
        ),
        useMaterial3: true,
      );
}