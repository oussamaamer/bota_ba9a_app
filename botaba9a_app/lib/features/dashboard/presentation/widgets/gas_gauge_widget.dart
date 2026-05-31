import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Beautiful circular gas gauge with animated arc and color zones.
class GasGaugeWidget extends StatefulWidget {
  final double percentage;
  final String status;
  final double size;
  final int gasWeightGrams;

  const GasGaugeWidget({
    super.key,
    required this.percentage,
    required this.status,
    this.size = 200,
    this.gasWeightGrams = 0,
  });

  @override
  State<GasGaugeWidget> createState() => _GasGaugeWidgetState();
}

class _GasGaugeWidgetState extends State<GasGaugeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant GasGaugeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.percentage,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _GasGaugePainter(
              percentage: _animation.value,
              status: widget.status,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_animation.value.round()}%',
                    style: GoogleFonts.poppins(
                      fontSize: widget.size * 0.2,
                      fontWeight: FontWeight.w800,
                      color: _getStatusColor(widget.status),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.gasWeightGrams > 0
                        ? '${(widget.gasWeightGrams / 1000).toStringAsFixed(1)} kg'
                        : '-- kg',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: widget.size * 0.08,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'restants',
                    style: GoogleFonts.inter(
                      fontSize: widget.size * 0.06,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'full':
        return AppColors.gaugeFull;
      case 'good':
        return AppColors.gaugeGood;
      case 'attention':
        return AppColors.gaugeAttention;
      case 'low':
        return AppColors.gaugeLow;
      case 'critical':
        return AppColors.gaugeCritical;
      default:
        return AppColors.gaugeEmpty;
    }
  }
}

class _GasGaugePainter extends CustomPainter {
  final double percentage;
  final String status;

  _GasGaugePainter({required this.percentage, required this.status});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const startAngle = 135 * pi / 180; // Start at bottom-left
    const sweepAngle = 270 * pi / 180; // Sweep 270 degrees
    const strokeWidth = 14.0;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.gaugeBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Value arc with gradient
    if (percentage > 0) {
      final valueSweep = sweepAngle * (percentage / 100);

      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + valueSweep,
        colors: _getGradientColors(),
      );

      final valuePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        valueSweep,
        false,
        valuePaint,
      );

      // Glow effect at the tip
      final tipAngle = startAngle + valueSweep;
      final tipX = center.dx + radius * cos(tipAngle);
      final tipY = center.dy + radius * sin(tipAngle);

      final glowPaint = Paint()
        ..color = _getMainColor().withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(tipX, tipY), 10, glowPaint);
    }
  }

  List<Color> _getGradientColors() {
    if (percentage > 50) {
      return [AppColors.gaugeGood, AppColors.gaugeFull];
    } else if (percentage > 20) {
      return [AppColors.gaugeAttention, AppColors.gaugeGood];
    } else if (percentage > 10) {
      return [AppColors.gaugeLow, AppColors.gaugeAttention];
    }
    return [AppColors.gaugeCritical, AppColors.gaugeLow];
  }

  Color _getMainColor() {
    switch (status) {
      case 'full':
        return AppColors.gaugeFull;
      case 'good':
        return AppColors.gaugeGood;
      case 'attention':
        return AppColors.gaugeAttention;
      case 'low':
        return AppColors.gaugeLow;
      case 'critical':
        return AppColors.gaugeCritical;
      default:
        return AppColors.gaugeEmpty;
    }
  }

  @override
  bool shouldRepaint(covariant _GasGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.status != status;
  }
}
