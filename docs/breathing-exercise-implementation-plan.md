# Breathing Exercise – Implementation Plan (Flutter)

*Project goal: implement the breathing-exercise feature described in `breathing-excercise-prd.md`, matching the provided designs as closely as possible while keeping the codebase beginner-friendly and scalable.*

---

## Step-by-step implementation roadmap

### Milestone 0 – Environment & onboarding (½ day)
0.1 Install Flutter 3 SDK, Cursor, and an emulator or device.
0.2 Run `flutter doctor` until all checks are ✓.  
0.3 Read: “Your first Flutter app” tutorial and the Dart Language Tour (stop at Generics).  
0.4 **Static analysis**: add `flutter_lints` (or `very_good_analysis`) in **dev_dependencies** and enable via `analysis_options.yaml`.  
0.5 **CI pipeline**: create a minimal GitHub Action that runs `flutter pub get`, `flutter analyze`, and `flutter test` on every push/PR.

### Milestone 1 – Project scaffold (½ day)
1.1 `flutter create future_stars_breathing`  
1.2 Add dependencies:
```yaml
dependencies:
  flutter: sdk: flutter
  flutter_riverpod: ^2.4.0
  go_router: ^11.1.0
  just_audio: ^0.9.34
  google_fonts: ^6.2.1
  audio_session: ^0.1.16  # for audio focus management
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  fake_async: ^1.3.1     # for testing timers
```
1.3 Declare assets:
```yaml
assets:
  - assets/images/
  - assets/audio/
```
1.4 Copy PNGs into `assets/images/` and add **placeholder MP3s** into `assets/audio/` (use Creative Commons assets).  
1.5 Wrap your `MaterialApp` in a **`ProviderScope`** in `main.dart` to enable Riverpod globally.  
1.6 **Lock orientation**: Add `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` in main().  
1.7 Use Google Fonts and Creative-Commons audio assets to avoid redistribution issues.

### Milestone 2 – Folder structure convention (1 hr)
```
lib/
  main.dart
  router.dart
  features/breathing/
    domain/
      breathing_phase.dart
    presentation/
      screens/
        intro_screen.dart
        inhale_screen.dart
        hold_screen.dart
        exhale_screen.dart
        success_screen.dart
        help_modal.dart
      widgets/
        breathing_bubble.dart
        phase_title.dart
        countdown_text.dart
        progress_line.dart
        sound_wave_widget.dart
        oracle_avatar.dart
        gradient_background.dart
        responsive_text.dart
      controller/
        breathing_controller.dart
        breathing_animation_controller.dart
    audio/
      audio_manager.dart
```

### Milestone 3 – Navigation & state (½ day)
* Configure `go_router` with paths `/intro`, `/inhale`, `/hold`, `/exhale`, `/success`, `/episode3-placeholder`.  
* Implement enhanced `BreathingController` (`StateNotifier<BreathingState>`):
```dart
class BreathingState {
  final BreathingPhase phase;
  final int countdown;
  final bool isAudioLoaded;
  final Duration elapsed;
  final double progress; // 0.0 to 1.0 for progress indicator
}
```
* Provide via `StateNotifierProvider`.  
* Use **Riverpod v2 syntax** (`ref.read`, `ref.watch`) consistently.

### Milestone 4 – Shared components (1½ days)
* **breathing_animation_controller.dart** – Master animation controller for perfect timing synchronization:
```dart
class BreathingAnimationController {
  late AnimationController master; // 20-second total duration
  late Animation<double> bubbleScale;
  late Animation<int> countdown;
  late Animation<double> progress;
  // Phase timing: 0.0-0.05 intro, 0.05-0.3 inhale, 0.3-0.55 hold, 0.55-0.8 exhale, 0.8-1.0 success
}
```
* **breathing_bubble.dart** – perfect circle that scales smoothly using master controller. Displays phase icons/countdown inside with glowing effect.  
* **countdown_text.dart** – `AnimatedSwitcher` showing 5 → 1 synchronized with master controller.  
* **progress_line.dart** – yellow horizontal progress line at top showing exercise progress (as seen in design).  
* **sound_wave_widget.dart** – animated waveform bars during breathing phases.  
* **oracle_avatar.dart** – Oracle character implementation matching designs.  
* **gradient_background.dart** – complex gradient backgrounds + scenery overlay matching designs exactly.  
* **responsive_text.dart** – phone-first typography that scales for tablets using `MediaQuery`.  
* Add **haptics** on phase change: `HapticFeedback.lightImpact()`.  
* Validate frame budget (aim for 60 fps on low-end devices; use `const` constructors and `AnimatedBuilder`).  
* **Performance**: Pre-cache all images using `precacheImage()` in `initState()`.

### Milestone 5 – Screens (2 days)
* Each screen = `Scaffold` with `Stack` (gradient background → scenery → progress line → Oracle → sound waves → bubble → text).  
* **Pixel-perfect layouts**: Match design positioning exactly using `Positioned` and `SafeArea`.  
* **Typography**: Use custom `TextStyle` matching design fonts/sizes with responsive scaling.  
* Inhale, Hold, Exhale auto-advance on `AnimationStatus.completed`, calling `nextPhase()`.  
* Intro & Success include styled buttons matching designs.  
* **Success screen**: Navigate to `/episode3-placeholder` with "Continue to Episode 3" button.  
* Add **accessibility**: wrap breathing bubble in `Semantics(label: 'Inhale for five seconds')` (adjust per phase).  
* **Phone-first responsive**: Test on small phones (iPhone SE) and ensure tablet compatibility.

### Milestone 6 – Audio playback (½ day)
* `AudioManager` singleton wrapping `just_audio`.  
* **Placeholder audio**: Use Creative Commons meditation/nature sounds for background music.  
* **Oracle voiceovers**: Use text-to-speech or placeholder audio clips for the 5 voice prompts.  
* Pre-load all audio assets with error handling.  
* Implement volume ducking: `playVoiceClip()` ducks background music, plays clip, restores volume.  
* Integrate `AudioSession` to pause on phone calls/interruptions.  
* **Error fallback**: Graceful degradation to visual-only mode if audio fails:
```dart
try {
  await audioPlayer.play();
} on PlayerException {
  // Continue with visual-only experience
  ref.read(audioStateProvider.notifier).setAudioDisabled();
}
```

### Milestone 7 – Help modal (1 hr)
* **Help Button Design**: Circular button in top-right corner of all breathing screens
  - Position: Top-right corner of all screens (intro, inhale, hold, exhale, success)
  - Style: 40x40px circular button with soft shadow
  - Colors: Semi-transparent navy background `Color(0xFF1F2951).withOpacity(0.8)` with white "?" icon
  - Matches existing design system (similar to intro arrow button but smaller)
* **Help Overlay Implementation**: Floating overlay matching help.png design (not bottom sheet)
  - White rounded bubble with soft shadow positioned over current screen
  - Close "×" button in top-right corner of bubble
  - Gentle fade-in/out animation
  - Dismiss on tap outside bubble or close button
* **Help Content**: Brief breathing exercise explanation
```
Need Help?

This is a guided breathing exercise to help you feel calm and focused.

• Tap "Begin Breathing" to start
• Follow the Oracle's voice instructions  
• Inhale for 5 seconds when prompted
• Hold your breath briefly
• Exhale for 5 seconds to complete
• The glowing bubble will guide your timing

Your breath is your superpower - use it to find strength and calm before your next challenge.
```
* **Technical Implementation**:
  - Create `help_button.dart` (reusable help button widget)
  - Create `help_overlay.dart` (help modal content matching design)
  - Add help button to `BreathingExerciseScreen` for all phases
  - Use overlay/dialog system for proper dismissal behavior

### Milestone 8 – Polish & multi-device checks (½ day)
* **Device testing**: Test on iPhone SE (small) and iPad (large) - portrait locked via `SystemChrome`.  
* **Responsive design**: Ensure layouts work on phones primarily, scale appropriately for tablets.  
* **Typography scaling**: Use `MediaQuery.textScaleFactorOf(context)` for accessibility.  
* Force light mode: `ThemeMode.light` (no dark mode in V1).  
* **Episode 3 placeholder**: Create simple placeholder screen with "Coming soon!" message.  
* Add `flutter_localizations` for future i18n support.  
* Complete accessibility: semantic labels for all interactive elements.

### Milestone 9 – Widget testing (½ day)
* **Widget Test Strategy**: Test the single `BreathingExerciseScreen` with phase transitions (matches current architecture)
* **Animation Testing**: Use real `BreathingAnimationController` with `fake_async` for time control
* **Audio Mocking**: Mock audio service for deterministic tests without audio hardware dependencies

#### 9.1 Widget Test - Breathing Phase Auto-Advancement
* Test file: `test/widget_test.dart` (replace existing placeholder tests)
* **Setup**: 
  - Use `fake_async` to control time passage
  - Create real `BreathingAnimationController` (tests actual timing logic)
  - Mock audio service to avoid flaky audio loading
  - Wrap `BreathingExerciseScreen` in `ProviderScope` with mocked providers
* **Test Flow**:
  ```dart
  testWidgets('Breathing phases auto-advance with correct timing', (WidgetTester tester) async {
    await tester.fakeAsync((async) {
      // 1. Start at intro phase, tap "Begin Breathing"
      // 2. Advance fake clock 5s → expect inhale → hold transition
      // 3. Advance another 2s → expect hold → exhale transition  
      // 4. Advance another 5s → expect exhale → success transition
      // 5. Verify final success state with Episode 3 navigation option
    });
  });
  ```
* **Assertions**: Verify phase-specific UI elements appear/disappear at correct timing intervals
* **Benefits**: Tests real animation timing but executes instantly, catches timing synchronization bugs

#### 9.2 Unit Test - BreathingController Logic
* Test file: `test/breathing_controller_test.dart` (new file)
* **Setup**: Test `BreathingController` in isolation without Flutter widgets
* **Test Cases**:
  ```dart
  group('BreathingController', () {
    test('progresses through phases in correct order', () {
      // Test: intro → inhale → hold → exhale → success
    });
    
    test('calculates progress correctly', () {
      // Test: progress goes from 0.0 → 1.0 across all phases
    });
    
    test('resets to initial state correctly', () {
      // Test: reset() returns to intro phase with clean state
    });
    
    test('handles audio loading states', () {
      // Test: isAudioLoaded flag updates correctly
    });
  });
  ```
* **Mocking**: Mock audio service dependencies using `mockito` or manual mocks
* **Benefits**: Fast unit tests focused on business logic without UI complexity

#### 9.3 Test Dependencies & Setup
* **Dependencies**: `fake_async: ^1.3.1` (already added), consider adding `mockito` for audio mocking
* **Mock Strategy**: Create mock audio service that simulates loading/playing without actual audio
* **Test Execution**: Both tests should run quickly (<1 second each) and be deterministic
* **Coverage Focus**: Core breathing exercise timing and state management logic

### Milestone 10 – Build & release (1 hr)
* Configure **app icon & splash screen** with `flutter_launcher_icons` and `flutter_native_splash`.  
* Add required microphone-usage description to **`Info.plist`**.  
* `flutter build apk --release`  
* `flutter build ios --release` (needs Xcode signing)
