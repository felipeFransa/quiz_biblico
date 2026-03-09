import 'package:flutter/material.dart';
import 'achievement.dart';

class AchievementList {
  static final List<Achievement> all = [
    Achievement(
      id: 'first_question',
      title: 'Primeiro Passo',
      description: 'Responda sua primeira pergunta',
      icon: Icons.directions_walk,
      color: Colors.brown,
      target: 1,
      getProgress: (stats) => stats.totalQuestionsAnswered,
    ),
    Achievement(
      id: 'quiz_10',
      title: 'Estudioso',
      description: 'Responda 10 perguntas',
      icon: Icons.menu_book,
      color: Colors.blue,
      target: 10,
      getProgress: (stats) => stats.totalQuestionsAnswered,
    ),
    Achievement(
      id: 'quiz_100',
      title: 'Escriba',
      description: 'Responda 100 perguntas',
      icon: Icons.edit_note,
      color: const Color(0xFFC0C0C0), // Silver
      target: 100,
      getProgress: (stats) => stats.totalQuestionsAnswered,
    ),
    Achievement(
      id: 'quiz_500',
      title: 'Doutor da Lei',
      description: 'Responda 500 perguntas',
      icon: Icons.verified,
      color: Colors.amber,
      target: 500,
      getProgress: (stats) => stats.totalQuestionsAnswered,
    ),
    Achievement(
      id: 'streak_7',
      title: 'Servo Fiel',
      description: 'Mantenha um streak de 7 dias',
      icon: Icons.local_fire_department,
      color: Colors.orange,
      target: 7,
      getProgress: (stats) => stats.streak,
    ),
    Achievement(
      id: 'perfect_quiz',
      title: 'Perfeito em Cristo',
      description: 'Complete um quiz sem erros',
      icon: Icons.check_circle,
      color: Colors.green,
      target: 1,
      getProgress: (stats) => stats.totalCorrectAnswers == stats.totalQuestionsAnswered && stats.totalQuestionsAnswered > 0 ? 1 : 0,
    ),
  ];
}
