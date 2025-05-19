import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PeptidePalApp());
}

class PeptidePalApp extends StatefulWidget {
  const PeptidePalApp({super.key});

  @override
  State<PeptidePalApp> createState() => _PeptidePalAppState();
}

class _PeptidePalAppState extends State<PeptidePalApp> {
  bool _darkMode = false;

  void _toggleTheme() => setState(() => _darkMode = !_darkMode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peptide Pal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        darkMode: _darkMode,
      ),
    );
  }
}