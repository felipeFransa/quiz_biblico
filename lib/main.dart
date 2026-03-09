import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/home/presentation/main_screen.dart';
import 'shared/themes/theme_config.dart';
import 'core/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  await AdService().init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const BibliaQuizApp(),
    ),
  );
}

class BibliaQuizApp extends ConsumerWidget {
  const BibliaQuizApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(settingsProvider);
    final themePalette = ThemeConfig.getTheme(userState.currentThemeId);

    return MaterialApp(
      title: 'Bíblia Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.createThemeData(themePalette).copyWith(
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      home: const MainScreen(),
    );
  }
}
