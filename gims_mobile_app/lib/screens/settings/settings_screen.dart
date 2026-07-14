import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/brand_app_bar.dart';
import '../../core/localization/app_localizations.dart';
import '../../viewmodels/settings_viewmodel.dart';

// List of primary colors matching Daily Finance options
const List<Color> _primaryColors = [
  Color(0xFF7C3AED), // Purple (Default)
  Color(0xFF3B82F6), // Blue
  Color(0xFF10B981), // Green
  Color(0xFFF59E0B), // Orange
  Color(0xFFEF4444), // Red
  Color(0xFFEC4899), // Pink
  Color(0xFF14B8A6), // Teal
  Color(0xFF6366F1), // Indigo
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: BrandAppBar(
        title: Text(loc.get('settings_title'), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: theme.appBarTheme.foregroundColor!)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.appBarTheme.foregroundColor!, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.get('settings_security'),
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 12),
            _SettingsToggleItem(
              title: loc.get('settings_biometric_lock'),
              subtitle: loc.get('settings_biometric_subtitle'),
              icon: Icons.fingerprint_rounded,
              checked: settings.isBiometricEnabled,
              onChanged: (val) {
                if (val) {
                  // Simulate biometric setup for now
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('settings_biometric_not_setup'))));
                }
                ref.read(settingsViewModelProvider.notifier).setBiometricEnabled(val);
              },
            ),
            const SizedBox(height: 24),
            
            Text(
              'Appearance',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 12),
            _SettingsToggleItem(
              title: loc.get('settings_theme'),
              subtitle: loc.get('settings_theme_subtitle'),
              icon: Icons.dark_mode_outlined,
              checked: settings.themeMode == ThemeMode.dark,
              onChanged: (val) {
                ref.read(settingsViewModelProvider.notifier).setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: 16),
            _SettingsColorPaletteItem(
              title: loc.get('settings_color_theme'),
              subtitle: loc.get('settings_color_subtitle'),
              selectedColor: settings.primaryColor,
              onColorSelected: (color) {
                ref.read(settingsViewModelProvider.notifier).setPrimaryColor(color);
              },
            ),
            const SizedBox(height: 24),
            
            Text(
              'Localization',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 12),
            _SettingsToggleItem(
              title: loc.get('settings_language'),
              subtitle: loc.get('settings_language_subtitle'),
              icon: Icons.translate_rounded,
              checked: settings.locale.languageCode == 'bn',
              onChanged: (val) {
                ref.read(settingsViewModelProvider.notifier).setLocale(Locale(val ? 'bn' : 'en'));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
              ],
            ),
          ),
          Switch(
            value: checked,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsColorPaletteItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const _SettingsColorPaletteItem({
    required this.title,
    required this.subtitle,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.palette_outlined, color: theme.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color)),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _primaryColors.map((color) {
                final isSelected = color.toARGB32() == selectedColor.toARGB32();
                return GestureDetector(
                  onTap: () => onColorSelected(color),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: isSelected ? [
                        BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))
                      ] : null,
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
