import 'package:flutter/material.dart';

/// Oracle character avatar matching the designs exactly
/// Shows the purple/blue circular character with glasses and purple hair
/// 
/// Flutter Learning Notes:
/// - CircleAvatar: Standard widget for circular profile images
/// - CustomPainter: For drawing complex character features
/// - Container decoration: For circular backgrounds and borders
/// - Stack: For layering character elements (background, face, glasses, hair)
class OracleAvatar extends StatelessWidget {
  const OracleAvatar({
    super.key,
    this.size = 60.0,
    this.showBorder = true,
  });

  /// Size of the avatar (diameter)
  final double size;
  
  /// Whether to show the decorative border
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Outer border ring like in design
        border: showBorder
            ? Border.all(
                color: const Color(0xFF6B7AAF).withOpacity(0.6),
                width: 2.0,
              )
            : null,
        // Subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1D4A).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          decoration: const BoxDecoration(
            // Background gradient for the avatar
            gradient: RadialGradient(
              colors: [
                Color(0xFF9B7CE6), // Brighter purple center to match design
                Color(0xFF7B5FE0), // Medium bright purple
                Color(0xFF5A4BCC), // Deeper purple edge
              ],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Oracle character illustration
              Positioned.fill(
                child: CustomPaint(
                  painter: _OracleCharacterPainter(size: size),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the Oracle character features
/// Flutter Learning: CustomPainter lets us draw pixel-perfect character art
class _OracleCharacterPainter extends CustomPainter {
  const _OracleCharacterPainter({required this.size});
  
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    // Scale factor for responsive drawing
    final scale = size / 60.0;
    
    // Draw hair (purple spiky/fluffy hair)
    _drawHair(canvas, canvasSize, scale);
    
    // Draw face (peach/orange skin tone)
    _drawFace(canvas, canvasSize, scale);
    
    // Draw glasses (large round glasses)
    _drawGlasses(canvas, canvasSize, scale);
    
    // Draw facial features
    _drawFacialFeatures(canvas, canvasSize, scale);
  }

  /// Draw the Oracle's purple hair
  void _drawHair(Canvas canvas, Size size, double scale) {
    final hairPaint = Paint()
      ..color = const Color(0xFF6B4E9D) // Purple hair
      ..style = PaintingStyle.fill;

    // Hair clumps around the head
    final hairPath = Path();
    
    // Top hair clump
    hairPath.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.25),
      width: size.width * 0.4 * scale,
      height: size.height * 0.3 * scale,
    ));
    
    // Left hair clump
    hairPath.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.25, size.height * 0.35),
      width: size.width * 0.25 * scale,
      height: size.height * 0.25 * scale,
    ));
    
    // Right hair clump
    hairPath.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.75, size.height * 0.35),
      width: size.width * 0.25 * scale,
      height: size.height * 0.25 * scale,
    ));
    
    canvas.drawPath(hairPath, hairPaint);
  }

  /// Draw the Oracle's face
  void _drawFace(Canvas canvas, Size size, double scale) {
    final facePaint = Paint()
      ..color = const Color(0xFFFFB366) // Peach/orange skin tone
      ..style = PaintingStyle.fill;

    // Main face oval
    final faceRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.55),
      width: size.width * 0.6 * scale,
      height: size.height * 0.5 * scale,
    );
    
    canvas.drawOval(faceRect, facePaint);
  }

  /// Draw the Oracle's glasses
  void _drawGlasses(Canvas canvas, Size size, double scale) {
    final glassesPaint = Paint()
      ..color = const Color(0xFF2D3561) // Dark blue frames
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale;
    
    final lensPaint = Paint()
      ..color = const Color(0xFF87CEEB).withOpacity(0.3) // Light blue lens tint
      ..style = PaintingStyle.fill;

    // Left lens
    final leftLens = Rect.fromCenter(
      center: Offset(size.width * 0.4, size.height * 0.5),
      width: size.width * 0.18 * scale,
      height: size.height * 0.18 * scale,
    );
    canvas.drawOval(leftLens, lensPaint);
    canvas.drawOval(leftLens, glassesPaint);

    // Right lens
    final rightLens = Rect.fromCenter(
      center: Offset(size.width * 0.6, size.height * 0.5),
      width: size.width * 0.18 * scale,
      height: size.height * 0.18 * scale,
    );
    canvas.drawOval(rightLens, lensPaint);
    canvas.drawOval(rightLens, glassesPaint);

    // Bridge between lenses
    canvas.drawLine(
      Offset(size.width * 0.49, size.height * 0.5),
      Offset(size.width * 0.51, size.height * 0.5),
      glassesPaint,
    );

    // Glasses reflection/shine effect
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // Small shine spots on each lens
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.38, size.height * 0.47),
        width: size.width * 0.05 * scale,
        height: size.height * 0.05 * scale,
      ),
      shinePaint,
    );
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.58, size.height * 0.47),
        width: size.width * 0.05 * scale,
        height: size.height * 0.05 * scale,
      ),
      shinePaint,
    );
  }

  /// Draw facial features (eyes, mouth, etc.)
  void _drawFacialFeatures(Canvas canvas, Size size, double scale) {
    // Eyes behind glasses (small dots)
    final eyePaint = Paint()
      ..color = const Color(0xFF1A1D4A)
      ..style = PaintingStyle.fill;

    // Left eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * 0.5),
        width: size.width * 0.04 * scale,
        height: size.height * 0.04 * scale,
      ),
      eyePaint,
    );

    // Right eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.5),
        width: size.width * 0.04 * scale,
        height: size.height * 0.04 * scale,
      ),
      eyePaint,
    );

    // Subtle smile
    final smilePaint = Paint()
      ..color = const Color(0xFFFF9A33) // Slightly darker orange for mouth
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.addArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.6),
        width: size.width * 0.15 * scale,
        height: size.height * 0.1 * scale,
      ),
      0, // Start angle
      3.14159, // End angle (half circle)
    );
    
    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Smaller version of Oracle avatar for compact spaces
/// Flutter Learning: Create variations for different use cases
class CompactOracleAvatar extends StatelessWidget {
  const CompactOracleAvatar({
    super.key,
    this.size = 40.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return OracleAvatar(
      size: size,
      showBorder: false, // No border in compact version
    );
  }
}
