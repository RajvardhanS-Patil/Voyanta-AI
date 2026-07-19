import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgAnimController;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnimController,
            builder: (context, child) {
              return CustomPaint(
                painter: _FloatingOrbsPainter(
                  progress: _bgAnimController.value,
                  isDark: isDark,
                ),
                size: Size.infinite,
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _FloatingOrbsPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _FloatingOrbsPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _Orb(
        0.15,
        0.2,
        120,
        isDark ? const Color(0xFF0D9488) : const Color(0xFF99F6E4),
      ),
      _Orb(
        0.75,
        0.3,
        90,
        isDark ? const Color(0xFF7C3AED) : const Color(0xFFDDD6FE),
      ),
      _Orb(
        0.5,
        0.7,
        140,
        isDark ? const Color(0xFF0EA5E9) : const Color(0xFFBAE6FD),
      ),
      _Orb(
        0.85,
        0.8,
        70,
        isDark ? const Color(0xFFEC4899) : const Color(0xFFFBCFE8),
      ),
    ];

    for (final orb in orbs) {
      final dx =
          orb.baseX * size.width + sin(progress * 2 * pi + orb.baseX * 10) * 30;
      final dy =
          orb.baseY * size.height + cos(progress * 2 * pi + orb.baseY * 8) * 25;

      final paint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                orb.color.withValues(alpha: isDark ? 0.25 : 0.18),
                orb.color.withValues(alpha: 0.0),
              ],
            ).createShader(
              Rect.fromCircle(center: Offset(dx, dy), radius: orb.radius),
            );

      canvas.drawCircle(Offset(dx, dy), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingOrbsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Orb {
  final double baseX, baseY, radius;
  final Color color;
  const _Orb(this.baseX, this.baseY, this.radius, this.color);
}
