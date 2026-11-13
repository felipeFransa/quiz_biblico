import 'package:flutter/material.dart';

const Map<String, String> categoryNormalization = {
  'Antigo Testamento': 'oldTestament',
  'Novo Testamento': 'newTestament',
  'Profetas': 'prophets',
  'Milagres': 'miracles',
  'Parábolas': 'parables',
  'Personagens': 'characters',
  'Mulheres da Bíblia': 'women',
};

const Map<String, String> categoryLabels = {
  'oldTestament': 'Antigo Testamento',
  'newTestament': 'Novo Testamento',
  'prophets': 'Profetas',
  'gospels': 'Evangelhos',
  'epistles': 'Epístolas',
  'acts': 'Atos',
  'genesis': 'Gênesis',
  'exodus': 'Êxodo',
  'psalms': 'Salmos',
  'revelation': 'Revelação',
  'characters': 'Personagens',
  'women': 'Mulheres da Bíblia',
  'miracles': 'Milagres',
  'parables': 'Parábolas',
  'geography': 'Geografia Bíblica',
  'chronology': 'Cronologia',
};

const Map<String, Map<String, dynamic>> categoryConfig = {
  'oldTestament': {
    'icon': Icons.history_edu_rounded,
    'color': Color(0xFF7B4F2E),
    'gradient': [Color(0xFFFDF3E7), Color(0xFFFEEDD5)],
    'subtitle': 'Criação, Leis e Profetas',
  },
  'newTestament': {
    'icon': Icons.menu_book_rounded,
    'color': Color(0xFF2A3175),
    'gradient': [Color(0xFFE8EEFF), Color(0xFFD6DEFF)],
    'subtitle': 'Evangelhos e Epístolas',
  },
  'gospels': {
    'icon': Icons.auto_stories_rounded,
    'color': Color(0xFF2A3175),
    'gradient': [Color(0xFFE8EEFF), Color(0xFFD6DEFF)],
    'subtitle': 'Evangelhos',
  },
  'prophets': {
    'icon': Icons.record_voice_over_rounded,
    'color': Color(0xFF5D4037),
    'gradient': [Color(0xFFFBE9E7), Color(0xFFFFCCBC)],
    'subtitle': 'Profetas e profecias',
  },
};

String categoryLabel(String slug) => categoryLabels[slug] ?? slug;

String normalizeCategory(String category) =>
    categoryNormalization[category] ?? category;
