import 'package:flutter/material.dart';

/// Responsive text widget that scales typography for different screen sizes
/// Phone-first design that works beautifully on tablets too
/// 
/// Flutter Learning Notes:
/// - MediaQuery: Access screen size and density information
/// - TextScaler: Handle system text scaling settings
/// - LayoutBuilder: React to available space constraints
/// - Extension methods: Add functionality to existing classes
class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textScaler,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get responsive text style based on screen size and constraints
        final responsiveStyle = _getResponsiveTextStyle(context, constraints);
        
        return Text(
          text,
          style: responsiveStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          textScaler: textScaler ?? _getResponsiveTextScaler(context),
        );
      },
    );
  }

  /// Calculate responsive text style based on context and constraints
  /// Flutter Learning: MediaQuery provides screen metrics for responsive design
  TextStyle _getResponsiveTextStyle(BuildContext context, BoxConstraints constraints) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final availableWidth = constraints.maxWidth;
    
    // Base style from widget or theme
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    
    // Calculate scale factor based on screen width
    final scaleFactor = _calculateScaleFactor(screenWidth, availableWidth);
    
    // Apply scaling to font size
    final scaledFontSize = (baseStyle.fontSize ?? 14.0) * scaleFactor;
    
    return baseStyle.copyWith(
      fontSize: scaledFontSize,
      // Adjust letter spacing proportionally for larger screens
      letterSpacing: (baseStyle.letterSpacing ?? 0.0) * scaleFactor,
    );
  }

  /// Calculate scale factor for different screen sizes
  /// Flutter Learning: Different scaling strategies for different screen types
  double _calculateScaleFactor(double screenWidth, double availableWidth) {
    // Phone-first breakpoints
    if (screenWidth <= 480) {
      // Small phones (iPhone SE, etc.)
      return 0.9;
    } else if (screenWidth <= 768) {
      // Regular phones (iPhone 14, etc.)
      return 1.0;
    } else if (screenWidth <= 1024) {
      // Small tablets (iPad mini, etc.)
      return 1.15;
    } else {
      // Large tablets (iPad Pro, etc.)
      return 1.3;
    }
  }

  /// Get responsive text scaler respecting user accessibility settings
  /// Flutter Learning: Always respect user's text size preferences
  TextScaler _getResponsiveTextScaler(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    // Respect user's text scaling preference but cap it for layout stability
    final userTextScale = mediaQuery.textScaler.scale(1.0);
    final cappedScale = userTextScale.clamp(0.8, 1.5);
    
    return TextScaler.linear(cappedScale);
  }
}

/// Pre-defined responsive text styles matching the design system
/// Flutter Learning: Create reusable style constants for consistency
class ResponsiveTextStyles {
  // Main heading for intro/success screens
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  // Secondary heading for phase instructions
  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.3,
  );

  // Body text for descriptions
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.4,
  );

  // Small text for disclaimers/hints
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
    height: 1.3,
  );

  // Phase labels inside breathing bubble
  static const TextStyle phaseLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF4A5FBB),
    letterSpacing: 0.5,
  );

  // Countdown numbers in breathing bubble
  static const TextStyle countdown = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4A5FBB),
  );
}

/// Convenient pre-built responsive text widgets
/// Flutter Learning: Create widget factories for common use cases
class ResponsiveTextWidgets {
  /// Main heading text (like "Take some moment to breathe...")
  static Widget heading(String text, {TextAlign? textAlign}) {
    return ResponsiveText(
      text,
      style: ResponsiveTextStyles.heading,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Subheading text (like "Inhale slowly for 5 seconds...")
  static Widget subheading(String text, {TextAlign? textAlign}) {
    return ResponsiveText(
      text,
      style: ResponsiveTextStyles.subheading,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Body text for longer descriptions
  static Widget body(String text, {TextAlign? textAlign}) {
    return ResponsiveText(
      text,
      style: ResponsiveTextStyles.body,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Caption text for small hints
  static Widget caption(String text, {TextAlign? textAlign}) {
    return ResponsiveText(
      text,
      style: ResponsiveTextStyles.caption,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Button text
  static Widget button(String text) {
    return ResponsiveText(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Extension on BuildContext for easy responsive measurements
/// Flutter Learning: Extensions add functionality to existing classes
extension ResponsiveContext on BuildContext {
  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding {
    final screenWidth = MediaQuery.of(this).size.width;
    
    if (screenWidth <= 480) {
      // Small phones
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    } else if (screenWidth <= 768) {
      // Regular phones
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    } else if (screenWidth <= 1024) {
      // Small tablets
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else {
      // Large tablets
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 32);
    }
  }

  /// Get responsive spacing for between elements
  double get responsiveSpacing {
    final screenWidth = MediaQuery.of(this).size.width;
    
    if (screenWidth <= 480) {
      return 16.0;
    } else if (screenWidth <= 768) {
      return 20.0;
    } else if (screenWidth <= 1024) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  /// Check if we're on a tablet-sized screen
  bool get isTablet {
    return MediaQuery.of(this).size.width > 768;
  }

  /// Check if we're on a large screen
  bool get isLargeScreen {
    return MediaQuery.of(this).size.width > 1024;
  }
}
