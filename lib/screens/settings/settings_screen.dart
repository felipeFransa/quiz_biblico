import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/enums.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _SectionHeader(title: 'Dificuldade'),
              const SizedBox(height: 12),
              ...Difficulty.values.map((d) => _DifficultyOption(
                    difficulty: d,
                    isSelected: settings.difficulty == d,
                    onTap: () => settings.setDifficulty(d),
                  )),
              const SizedBox(height: 28),
              const _SectionHeader(title: 'Preferências'),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.volume_up_rounded,
                label: 'Sons',
                trailing: Switch(
                  value: settings.soundEnabled,
                  onChanged: (val) => settings.setSoundEnabled(val),
                  activeThumbColor: AppTheme.accent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.accent,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  Color get _color {
    switch (difficulty) {
      case Difficulty.easy:
        return AppTheme.correct;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return AppTheme.wrong;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? _color.withValues(alpha: 0.1) : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _color : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, color: _color, size: 10),
            const SizedBox(width: 14),
            Text(
              difficulty.displayName,
              style: TextStyle(
                color: isSelected ? _color : Colors.white70,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Icon(Icons.check_rounded, color: _color, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
