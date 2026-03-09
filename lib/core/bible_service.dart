import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/providers/app_providers.dart';

class BibleService {
  final Ref _ref;

  BibleService(this._ref);

  Future<String?> getVerseText(String reference) async {
    try {
      // Busca apenas localmente agora que a Bíblia está embutida
      final db = _ref.read(databaseServiceProvider);
      return await db.getLocalVerse(reference);
    } catch (e) {
      debugPrint('Error getting verse: $e');
      return null;
    }
  }
}
