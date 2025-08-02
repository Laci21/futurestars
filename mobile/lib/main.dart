import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Lock orientation to portrait only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
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
    return MaterialApp(
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
      home: const PlaceholderHomeScreen(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

// Temporary placeholder screen for development
class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29), // Dark blue background like designs
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.self_improvement,
              size: 80,
              color: Color(0xFF4A90E2),
            ),
            SizedBox(height: 24),
            Text(
              'FutureStars',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Breathing Exercise',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'App structure ready! 🎯',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
