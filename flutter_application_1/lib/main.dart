import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'providers/peptide_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PeptidePalApp()));
}

class PeptidePalApp extends ConsumerStatefulWidget {
  const PeptidePalApp({super.key});

  @override
  ConsumerState<PeptidePalApp> createState() => _PeptidePalAppState();
}

class _PeptidePalAppState extends ConsumerState<PeptidePalApp> {
  static const String _themeKey = 'dark_mode';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      if (mounted) {
        ref.read(darkModeProvider.notifier).state = isDark;
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  Future<void> _toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = !ref.read(darkModeProvider);
      if (mounted) {
        ref.read(darkModeProvider.notifier).state = isDark;
      }
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(darkModeProvider);
    
    return MaterialApp(
      title: 'Peptide Pal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        darkMode: darkMode,
      ));
  }
}