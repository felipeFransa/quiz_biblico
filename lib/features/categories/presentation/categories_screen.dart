import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/constants/category_constants.dart';
import '../../quiz/providers/quiz_provider.dart';
import '../../quiz/presentation/quiz_screen.dart';
import '../../../core/theme/app_theme.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(decoration: AppTheme.celestialDecoration),

          Positioned(
            bottom: -60,
            left: -60,
            child: Opacity(
              opacity: 0.04,
              child: Icon(Icons.auto_stories_rounded, size: 320, color: AppTheme.divineGold),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
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
                    'Categorias',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
                    child: Text(
                      'Escolha seu campo de batalha sagrada',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),

              FutureBuilder<List<String>>(
                future: ref.read(databaseServiceProvider).getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                  }

                  final categories = snapshot.data!;
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final slug = categories[index];
                          final label = categoryLabel(slug);
                          final config = categoryConfig[slug] ?? {
                            'icon': Icons.auto_stories_rounded,
                            'color': AppTheme.primaryBlue,
                            'gradient': [AppTheme.celestialBlue, Colors.white],
                            'subtitle': 'Conteúdo Bíblico',
                          };
                          final iconColor = config['color'] as Color;
                          final gradientColors = config['gradient'] as List<Color>;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(28),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(28),
                                onTap: () async {
                                  await ref.read(quizProvider.notifier).startQuiz(slug);
                                  if (context.mounted) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: gradientColors,
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: iconColor.withValues(alpha: 0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: iconColor.withValues(alpha: 0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: iconColor.withValues(alpha: 0.2),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(config['icon'] as IconData, color: iconColor, size: 28),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              label,
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: iconColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              config['subtitle'] as String,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: iconColor.withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: iconColor.withValues(alpha: 0.5)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: categories.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
