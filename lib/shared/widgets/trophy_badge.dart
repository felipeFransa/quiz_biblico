import 'package:flutter/material.dart';
import '../../features/gamification/models/achievement.dart';
import '../../features/gamification/providers/progress_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unlocked ? achievement.color.withValues(alpha: 0.5) : theme.colorScheme.outline,
          width: unlocked ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (unlocked ? achievement.color : Colors.black).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with Bloom/Glow if unlocked
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked ? achievement.color.withValues(alpha: 0.15) : theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              unlocked ? achievement.icon : Icons.lock_outline,
              size: 32,
              color: unlocked ? achievement.color : theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: unlocked ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
          const Spacer(),
          // Progress section
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    unlocked ? 'Concluído' : '$progress/${achievement.target}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: unlocked ? achievement.color : theme.colorScheme.secondary,
                    ),
                  ),
                  if (!unlocked)
                    Text(
                      '${(percent * 100).toInt()}%',
                      style: theme.textTheme.labelSmall,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    unlocked ? achievement.color : theme.colorScheme.secondary.withValues(alpha: 0.4),
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
