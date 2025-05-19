import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const String _themeKey = 'dark_mode';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool(_themeKey) ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _darkMode = !_darkMode);
    await prefs.setBool(_themeKey, _darkMode);
  }

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