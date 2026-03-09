import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/app_providers.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../shared/themes/theme_config.dart';
import '../../../features/gamification/providers/progress_provider.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(settingsProvider);
    final stats = ref.watch(progressProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Celestial background
          Container(decoration: AppTheme.celestialDecoration),

          // Watermark
          Positioned(
            top: -40,
            right: -60,
            child: Opacity(
              opacity: 0.04,
              child: Icon(Icons.settings_rounded, size: 320, color: AppTheme.divineGold),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: AppTheme.primaryBlue,
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(60, 0, 16, 16),
                  title: Text(
                    'Ajustes',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Section header
                    _SectionHeader(title: 'PERSONALIZAÇÃO', icon: Icons.palette_rounded),
                    const SizedBox(height: 16),

                    // Themes
                    ...ThemeConfig.themes.map((palette) {
                      final isUnlocked = stats.level >= palette.unlockLevel;
                      final isSelected = userState.currentThemeId == palette.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: isUnlocked ? () => ref.read(settingsProvider.notifier).setTheme(palette.id) : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? palette.primary
                                      : AppTheme.cardBorder,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: palette.primary.withValues(alpha: 0.2),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        )
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.03),
                                          blurRadius: 10,
                                        )
                                      ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: palette.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: palette.primary.withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check_rounded, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          palette.name,
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? palette.primary : AppTheme.textMain,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isUnlocked ? 'Tema disponível' : 'Nível ${palette.unlockLevel} necessário',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: isUnlocked ? AppTheme.textSecondary : theme.colorScheme.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isUnlocked)
                                    const Icon(Icons.lock_outline_rounded, color: AppTheme.textSecondary, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    _SectionHeader(title: 'DADOS E SISTEMA', icon: Icons.storage_rounded),
                    const SizedBox(height: 16),

                    _SettingsTileNew(
                      theme: theme,
                      icon: Icons.sync_rounded,
                      iconColor: AppTheme.accentGreen,
                      title: 'Sincronizar Conteúdo',
                      subtitle: 'Baixar novas perguntas da nuvem',
                      onTap: () async {
                        final db = ref.read(databaseServiceProvider);
                        const url = 'https://raw.githubusercontent.com/felipefranca/quiz_biblico/main/assets/questions.json';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sincronizando...')),
                        );
                        final success = await db.syncFromApi(url);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(success ? 'Sincronização concluída!' : 'Erro na sincronização.')),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.divineGold),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.divineGold,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _SettingsTileNew extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTileNew({
    required this.theme,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
