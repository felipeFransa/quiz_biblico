import 'package:flutter/material.dart';
import '../../features/gamification/models/achievement.dart';
import '../../features/gamification/providers/progress_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class TrophyBadge extends ConsumerWidget {
  final Achievement achievement;

  const TrophyBadge({super.key, required this.achievement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(progressProvider);
    final unlocked = achievement.isUnlocked(stats);
    final progress = achievement.getProgress(stats);
    final percent = (progress / achievement.target).clamp(0.0, 1.0);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unlocked
              ? AppTheme.divineGold.withValues(alpha: 0.5)
              : AppTheme.cardBorder,
          width: unlocked ? 2 : 1,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: AppTheme.divineGold.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with divine glow if unlocked
          Stack(
            alignment: Alignment.center,
            children: [
              if (unlocked)
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.divineGold.withValues(alpha: 0.2),
                        AppTheme.divineGold.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: unlocked
                      ? AppTheme.divineGold.withValues(alpha: 0.12)
                      : theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: unlocked
                        ? AppTheme.divineGold.withValues(alpha: 0.4)
                        : AppTheme.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  unlocked ? achievement.icon : Icons.lock_outline_rounded,
                  size: 28,
                  color: unlocked
                      ? AppTheme.divineGold
                      : AppTheme.textSecondary.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: unlocked ? AppTheme.textMain : AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          // Description
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              color: AppTheme.textSecondary,
              height: 1.3,
            ),
          ),

          const Spacer(),

          // Progress section
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    unlocked ? '✓ Concluído' : '$progress/${achievement.target}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: unlocked ? AppTheme.divineGold : AppTheme.primaryBlue,
                    ),
                  ),
                  if (!unlocked)
                    Text(
                      '${(percent * 100).toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 7,
                  backgroundColor: AppTheme.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    unlocked
                        ? AppTheme.divineGold
                        : AppTheme.primaryBlue.withValues(alpha: 0.5),
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
