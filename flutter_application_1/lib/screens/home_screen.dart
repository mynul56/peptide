import 'package:flutter/material.dart';
import '../widgets/calculator_form.dart';
import '../widgets/peptide_info_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool darkMode;

  const HomeScreen({
    Key? key,
    required this.onToggleTheme,
    required this.darkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child: const Column(
                        children: [
                          Text(
                            "Peptide Pal",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Geist", // Use Geist or closest match
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Your friendly peptide calculator",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF7B7B7B),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Geist",
                            ),
                          ),
                          SizedBox(height: 18),
                          CalculatorForm(),
                          SizedBox(height: 18),
                          PeptideInfoCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
