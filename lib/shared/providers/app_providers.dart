import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database_service.dart';
import '../../core/audio_service.dart';
import '../../core/ads/ad_service.dart';

import '../../core/bible_service.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());
final audioServiceProvider = Provider((ref) => AudioService());
final adServiceProvider = Provider((ref) => AdService());
final bibleServiceProvider = Provider((ref) => BibleService(ref));
