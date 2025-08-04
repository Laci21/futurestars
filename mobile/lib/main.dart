import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';

void main() {
  // Lock orientation to portrait only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Set light status bar for dark background
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    // Wrap entire app in ProviderScope for Riverpod state management
    const ProviderScope(
      child: BreathingExerciseApp(),
    ),
  );
}

class BreathingExerciseApp extends StatelessWidget {
  const BreathingExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FutureStars Breathing Exercise',
      theme: ThemeData(
        // Light mode only for V1
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2), // Blue theme matching designs
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light, // Force light mode
      routerConfig: appRouter, // Use our go_router configuration
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}
