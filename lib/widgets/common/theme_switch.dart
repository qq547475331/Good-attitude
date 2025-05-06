import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  final Color? activeColor;
  final Color? inactiveColor;
  
  const ThemeSwitch({
    super.key,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.light_mode, size: 20),
        const SizedBox(width: 8),
        Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) => themeProvider.setTheme(value),
          activeColor: activeColor,
          inactiveThumbColor: inactiveColor,
        ),
        const SizedBox(width: 8),
        const Icon(Icons.dark_mode, size: 20),
      ],
    );
  }
} 