import 'package:flutter/material.dart';

class TrendXLogo extends StatelessWidget {
  final double height;
  final bool isDark;
  
  const TrendXLogo({
    super.key,
    this.height = 32,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF212121);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Trend" Text
        Text(
          'Trend',
          style: TextStyle(
            fontSize: height * 0.5, // 40px for 80px height
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
        
        SizedBox(width: height * 0.1), // 8px gap
        
        // X Icon with Arrow (Custom Paint)
        SizedBox(
          width: height * 0.5, // 40px for 80px height
          height: height * 0.5,
          child: CustomPaint(
            painter: TrendXIconPainter(),
          ),
        ),
      ],
    );
  }
}

class TrendXIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    // Create gradient from electric blue to cyan
    final gradient = LinearGradient(
      colors: const [
        Color(0xFF2196F3), // Electric Blue
        Color(0xFF00BCD4), // Cyan
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
    
    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    
    final path = Path();
    
    // Draw X with upward arrow
    // Line 1: Bottom-left to top-right (with arrow)
    path.moveTo(size.width * 0.15, size.height * 0.85);
    path.lineTo(size.width * 0.85, size.height * 0.15);
    
    // Arrow head (top-right)
    path.moveTo(size.width * 0.85, size.height * 0.15);
    path.lineTo(size.width * 0.68, size.height * 0.22);
    
    path.moveTo(size.width * 0.85, size.height * 0.15);
    path.lineTo(size.width * 0.78, size.height * 0.32);
    
    // Line 2: Top-left to bottom-right (crossing line)
    path.moveTo(size.width * 0.15, size.height * 0.15);
    path.lineTo(size.width * 0.85, size.height * 0.85);
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(TrendXIconPainter oldDelegate) => false;
}
