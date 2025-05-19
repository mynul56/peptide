import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool darkMode;
  final VoidCallback onToggleTheme;

  const ThemeToggleButton({
    super.key,
    required this.darkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Icon(
          darkMode ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey<bool>(darkMode),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: onToggleTheme,
      tooltip: darkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}