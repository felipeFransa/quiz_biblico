import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement_list.dart';
import '../providers/progress_provider.dart';
import '../../../shared/widgets/trophy_badge.dart';
import '../../../core/theme/app_theme.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(progressProvider);
    final theme = Theme.of(context);
    final allAchievements = AchievementList.all;
    final unlockedCount = allAchievements.where((a) => a.isUnlocked(stats)).length;
    final totalCount = allAchievements.length;
    final percent = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Celestial background
          Container(decoration: AppTheme.celestialDecoration),

          // Watermark
          Positioned(
            bottom: -40,
            left: -60,
            child: Opacity(
              opacity: 0.04,
              child: Icon(
                Icons.emoji_events_rounded,
                size: 320,
                color: AppTheme.divineGold,
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // Sacred Header
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: AppTheme.primaryBlue,
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.primaryBlue.withValues(alpha: 0.85),
                          AppTheme.celestialBlue.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            // Trophy icon with golden ring
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.divineGold.withValues(alpha: 0.6),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.emoji_events_rounded,
                                color: AppTheme.divineGold,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Minhas Conquistas',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '"Bem-aventurado o homem que persevera"',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Progress summary
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppTheme.divineGold.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome_rounded, color: AppTheme.divineGold, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$unlockedCount de $totalCount desbloqueadas',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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

              // Global progress bar just below the header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PROGRESSO GERAL',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.divineGold,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            '${(percent * 100).toInt()}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.divineGold),
                          backgroundColor: AppTheme.cardBorder,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Achievements Grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = allAchievements[index];
                      return TrophyBadge(achievement: achievement);
                    },
                    childCount: allAchievements.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
