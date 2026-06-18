import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class ScraperProgressLoader extends StatefulWidget {
  const ScraperProgressLoader({super.key});

  @override
  State<ScraperProgressLoader> createState() => _ScraperProgressLoaderState();
}

class _ScraperProgressLoaderState extends State<ScraperProgressLoader>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _waveController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    // Progress starts from 0% and slowly fills to 99% over 18 seconds (matching function execution time)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.99).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutSine,
      ),
    );

    // Wave animation runs continuously to simulate rippling liquid
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  String _getStatusMessage(double progress) {
    if (progress < 0.15) {
      return 'Connecting to scraping nodes...';
    } else if (progress < 0.35) {
      return 'Scraping Simplify GitHub listings...';
    } else if (progress < 0.55) {
      return 'Scraping LinkedIn & Handshake...';
    } else if (progress < 0.75) {
      return 'Parsing Greenhouse boards...';
    } else if (progress < 0.90) {
      return 'Evaluating job roles & visa fit...';
    } else {
      return 'Syncing database...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.scale(context, AppConstants.screenPadding),
        ),
        child: Container(
          padding: EdgeInsets.all(Responsive.scale(context, 24.0)),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x30FFFFFF) : const Color(0x10000000),
            borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusCard)),
            border: Border.all(
              color: isDark ? const Color(0x20FFFFFF) : const Color(0x15000000),
              width: 0.8,
            ),
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([_progressAnimation, _waveController]),
            builder: (context, child) {
              final progress = _progressAnimation.value;
              final percent = (progress * 100).toInt();
              final message = _getStatusMessage(progress);

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Liquid Container
                  Container(
                    width: Responsive.scale(context, 140.0),
                    height: Responsive.scale(context, 140.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0x1A000000) : const Color(0x05000000),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.5),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Stack(
                        children: [
                          // Liquid Wave Custom Paint
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _LiquidWavePainter(
                                progress: progress,
                                waveOffset: _waveController.value,
                                waveColor: AppColors.accent,
                              ),
                            ),
                          ),
                          // Percentage Text Overlay
                          Center(
                            child: Text(
                              '$percent%',
                              style: TextStyle(
                                fontSize: Responsive.scaleText(context, 26.0),
                                fontWeight: FontWeight.w900,
                                color: percent > 50 ? CupertinoColors.white : AppColors.textPrimary(context),
                                shadows: percent > 50
                                    ? [
                                        const Shadow(
                                          color: Color(0x50000000),
                                          offset: Offset(0, 1.5),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.scale(context, 24.0)),
                  // Primary Status Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTypography.body(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.scaleText(context, 15.0),
                    ),
                  ),
                  SizedBox(height: Responsive.scale(context, 8.0)),
                  // Subtext
                  Text(
                    'This might take a moment to sync all resources.',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption(context).copyWith(
                      fontSize: Responsive.scaleText(context, 12.0),
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LiquidWavePainter extends CustomPainter {
  final double progress;
  final double waveOffset;
  final Color waveColor;

  _LiquidWavePainter({
    required this.progress,
    required this.waveOffset,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Calculate water level (Y coordinate) from bottom to top based on progress
    final waterLevelY = size.height * (1.0 - progress);

    // Wave amplitude (height of the wave crest)
    final amplitude = size.height * 0.05;
    
    // Wave wavelength (horizontal length of one wave cycle)
    final wavelength = size.width;

    path.moveTo(0, waterLevelY);

    // Draw sine-wave across the width
    for (double x = 0; x <= size.width; x++) {
      // Calculate y offset based on sine function and horizontal offset
      final angle = (x / wavelength) * 2 * math.pi + (waveOffset * 2 * math.pi);
      final y = waterLevelY + math.sin(angle) * amplitude;
      path.lineTo(x, y);
    }

    // Close the path around the bottom of the container
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveOffset != waveOffset ||
        oldDelegate.waveColor != waveColor;
  }
}
