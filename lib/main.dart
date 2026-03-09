import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/question_repository.dart';
import 'providers/quiz_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ads_provider.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Pre-load questions
  await QuestionRepository.instance.load();

  // Initialize providers
  final settingsProvider = SettingsProvider();
  final statsProvider = StatsProvider();
  final adsProvider = AdsProvider();

  await Future.wait([
    settingsProvider.load(),
    statsProvider.load(),
    adsProvider.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: statsProvider),
        ChangeNotifierProvider.value(value: adsProvider),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const BibleQuizApp(),
    ),
  );
}

class BibleQuizApp extends StatelessWidget {
  const BibleQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
