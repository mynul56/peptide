import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/calculator_form.dart';
import '../widgets/peptide_info_card.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/history_panel.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool darkMode;

  const HomeScreen({
    Key? key,
    required this.onToggleTheme,
    required this.darkMode,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for showing History panel
  void _openHistoryPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HistoryPanel(),
    );
  }

  // For CalculatorForm to trigger refresh on history add/copy
  void _onHistoryUsed(Map<String, dynamic> entry) {
    // This callback can be used to repopulate CalculatorForm inputs, if needed.
    // For more integration, consider using a state management solution.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.history,
            color: Theme.of(context).iconTheme.color,
            size: Theme.of(context).iconTheme.size,
          ),
          tooltip: "History",
          onPressed: _openHistoryPanel,
        ),
        actions: [
          ThemeToggleButton(
            darkMode: widget.darkMode,
            onToggleTheme: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            'Peptide Pal',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.onSurface,
                              fontFamily: "Geist",
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Your friendly peptide calculator",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Geist",
                            ),
                          ),
                          const SizedBox(height: 18),
                          CalculatorForm(
                            onHistoryUsed: _onHistoryUsed, // for future use
                          ),
                          const SizedBox(height: 18),
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