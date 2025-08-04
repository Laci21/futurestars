import 'package:flutter/material.dart';

/// Complex gradient background with scenic overlay matching designs exactly
/// Creates the beautiful atmospheric background seen in all breathing exercise screens
/// 
/// Flutter Learning Notes:
/// - LinearGradient: Creates smooth color transitions
/// - Container decoration: Handles background styling
/// - Stack: Layering widgets (gradient + scenic overlay)
/// - Positioned: Precise element placement
/// - CustomPainter: For complex scenic shapes (trees, gazebo, etc.)
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    this.child,
  });

  /// Optional child widget to place on top of the background
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        // Main gradient matching the design exactly
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A5BB8), // Much brighter blue-purple top like design
            Color(0xFF3D4AA0), // Bright mid-blue
            Color(0xFF2E3770), // Medium blue
            Color(0xFF1A1D4A), // Darker blue
            Color(0xFF0B0E2A), // Very dark bottom
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Scenic overlay with atmospheric elements
          _buildScenicOverlay(),
          
          // Overlay mask for better text contrast
          _buildOverlayMask(),
          
          // Optional child content on top
          if (child != null) child!,
        ],
      ),
    );
  }

  /// Build the scenic overlay with trees, gazebo, and atmospheric elements
  Widget _buildScenicOverlay() {
    return Stack(
      children: [
        // Atmospheric mist/fog effect at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF8B98CF).withOpacity(0.4), // Misty bottom
                  const Color(0xFF8B98CF).withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Left side tree silhouettes
        Positioned(
          bottom: 0,
          left: 0,
          child: CustomPaint(
            size: const Size(150, 400),
            painter: _LeftTreesPainter(),
          ),
        ),

        // Right side tree silhouettes
        Positioned(
          bottom: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(120, 350),
            painter: _RightTreesPainter(),
          ),
        ),

        // Central gazebo/pavilion structure
        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Center(
            child: CustomPaint(
              size: const Size(180, 120),
              painter: _GazeboPainter(),
            ),
          ),
        ),

        // Wooden steps/platform
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: CustomPaint(
              size: const Size(200, 80),
              painter: _WoodenStepsPainter(),
            ),
          ),
        ),

        // Water reflection effect at very bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF4A5B8C).withOpacity(0.3),
                  const Color(0xFF2D3561).withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build overlay mask for better text contrast (fades illustration behind text areas)
  Widget _buildOverlayMask() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent, // No overlay at top (progress indicator area)
            const Color(0xFF2A3572).withOpacity(0.3), // Light overlay for text area
            const Color(0xFF1A1D4A).withOpacity(0.5), // Medium overlay for center text
            const Color(0xFF0F1438).withOpacity(0.3), // Light overlay for CTA area
            Colors.transparent, // Clear at bottom (keep illustration visible)
          ],
          stops: [0.0, 0.2, 0.5, 0.8, 1.0],
        ),
      ),
    );
  }
}

/// Custom painter for left side tree silhouettes
/// 
/// Flutter Learning: CustomPainter allows you to draw custom shapes
/// - override paint() method to define your drawing
/// - use Path for complex shapes
/// - use Paint for styling (color, stroke, etc.)
class _LeftTreesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F1235).withOpacity(0.8) // Dark silhouette
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Main tree trunk
    path.moveTo(30, size.height);
    path.lineTo(35, size.height - 80);
    path.lineTo(40, size.height - 120);
    path.lineTo(45, size.height - 160);
    
    // Tree canopy - organic curved shape
    path.quadraticBezierTo(60, size.height - 180, 80, size.height - 170);
    path.quadraticBezierTo(100, size.height - 160, 110, size.height - 140);
    path.quadraticBezierTo(120, size.height - 120, 115, size.height - 100);
    path.quadraticBezierTo(110, size.height - 80, 90, size.height - 70);
    path.quadraticBezierTo(70, size.height - 60, 50, size.height - 65);
    path.quadraticBezierTo(35, size.height - 70, 25, size.height - 90);
    path.quadraticBezierTo(20, size.height - 110, 25, size.height - 130);
    path.quadraticBezierTo(30, size.height - 150, 30, size.height);
    
    canvas.drawPath(path, paint);
    
    // Additional smaller trees/foliage
    final smallPath = Path();
    smallPath.moveTo(0, size.height);
    smallPath.quadraticBezierTo(15, size.height - 50, 25, size.height - 40);
    smallPath.quadraticBezierTo(35, size.height - 30, 30, size.height - 10);
    smallPath.lineTo(0, size.height);
    
    canvas.drawPath(smallPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for right side tree silhouettes
class _RightTreesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F1235).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Right side tree with different shape
    path.moveTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height - 60);
    path.quadraticBezierTo(size.width - 30, size.height - 100, size.width - 40, size.height - 120);
    path.quadraticBezierTo(size.width - 60, size.height - 140, size.width - 80, size.height - 130);
    path.quadraticBezierTo(size.width - 100, size.height - 120, size.width - 110, size.height - 100);
    path.quadraticBezierTo(size.width - 115, size.height - 80, size.width - 100, size.height - 60);
    path.quadraticBezierTo(size.width - 85, size.height - 40, size.width - 60, size.height - 30);
    path.quadraticBezierTo(size.width - 40, size.height - 20, size.width - 20, size.height - 25);
    path.lineTo(size.width, size.height);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for central gazebo/pavilion structure
class _GazeboPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()
      ..color = const Color(0xFF0A0D2A).withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    final lightPaint = Paint()
      ..color = const Color(0xFF1A1D4A).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final roofPaint = Paint()
      ..color = const Color(0xFF0F1438).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Gazebo base/platform (wider rectangular base)
    final baseRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.85),
      width: size.width * 0.9,
      height: size.height * 0.2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(baseRect, const Radius.circular(8)),
      lightPaint,
    );

    // Gazebo roof (more architectural, peaked)
    final roofPath = Path();
    roofPath.moveTo(size.width * 0.1, size.height * 0.4);
    roofPath.lineTo(size.width * 0.5, size.height * 0.1); // Peak
    roofPath.lineTo(size.width * 0.9, size.height * 0.4);
    roofPath.lineTo(size.width * 0.8, size.height * 0.5);
    roofPath.lineTo(size.width * 0.2, size.height * 0.5);
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);

    // Gazebo pillars/supports (more architectural)
    final pillarWidth = 6.0;
    final pillarHeight = size.height * 0.4;
    
    // Left pillar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3 - pillarWidth / 2,
          size.height * 0.5,
          pillarWidth,
          pillarHeight,
        ),
        const Radius.circular(2),
      ),
      lightPaint,
    );
    
    // Right pillar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.7 - pillarWidth / 2,
          size.height * 0.5,
          pillarWidth,
          pillarHeight,
        ),
        const Radius.circular(2),
      ),
      lightPaint,
    );

    // Center pillar for more structure
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.5 - pillarWidth / 2,
          size.height * 0.5,
          pillarWidth,
          pillarHeight,
        ),
        const Radius.circular(2),
      ),
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for wooden steps/platform
class _WoodenStepsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D3561).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw multiple step levels
    for (int i = 0; i < 4; i++) {
      final stepHeight = 12.0;
      final stepWidth = size.width - (i * 20);
      final stepY = size.height - (i * stepHeight);
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, stepY),
          width: stepWidth,
          height: stepHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
