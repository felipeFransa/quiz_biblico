import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/enums.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/ads_provider.dart';
import '../quiz/quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<_CategoryData> _categories = [
    _CategoryData(QuizCategory.oldTestament, Color(0xFF7B5EA7)),
    _CategoryData(QuizCategory.newTestament, Color(0xFF2E86AB)),
    _CategoryData(QuizCategory.characters, Color(0xFF4CAF80)),
    _CategoryData(QuizCategory.miracles, Color(0xFFE8A838)),
    _CategoryData(QuizCategory.prophets, Color(0xFFE74C3C)),
    _CategoryData(QuizCategory.women, Color(0xFFD64C8C)),
    _CategoryData(QuizCategory.parables, Color(0xFF1ABC9C)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, i) {
            final cat = _categories[i];
            return _CategoryCard(data: cat, index: i)
                .animate()
                .fadeIn(delay: (i * 60).ms, duration: 400.ms)
                .scale(delay: (i * 60).ms, duration: 400.ms);
          },
        ),
      ),
    );
  }
}

class _CategoryData {
  final QuizCategory category;
  final Color color;
  const _CategoryData(this.category, this.color);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryData data;
  final int index;

  const _CategoryCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _startWithCategory(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              data.color.withValues(alpha: 0.7),
              data.color.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: data.color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.category.emoji,
                style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.category.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startWithCategory(BuildContext context) async {
    final quiz = context.read<QuizProvider>();
    final settings = context.read<SettingsProvider>();
    final ads = context.read<AdsProvider>();

    await quiz.startQuiz(
      category: data.category,
      difficulty: settings.difficulty,
    );

    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
      ads.maybeShowInterstitial();
    }
  }
}
