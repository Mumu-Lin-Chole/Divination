import 'dart:math' as math;

import 'package:flutter/material.dart';

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.label,
    required this.onTap,
    this.width,
    this.height = 52,
    this.borderRadius = 28,
    this.showArrow = false,
    this.sparkles = false,
    this.textStyle,
  });

  final String label;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final double borderRadius;
  final bool showArrow;
  final bool sparkles;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final labelStyle =
        textStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        );

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFF2C56D),
                  Color(0xFFE09A32),
                  Color(0xFFC98933),
                ],
                stops: [0, 0.52, 1],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC98933).withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (sparkles)
                  const Positioned.fill(
                    child: IgnorePointer(child: _SparkleLayer()),
                  ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: labelStyle),
                      if (showArrow) ...[
                        const SizedBox(width: 10),
                        Text(
                          '→',
                          style: labelStyle.copyWith(
                            fontSize: (labelStyle.fontSize ?? 17) + 6,
                            fontWeight: FontWeight.w300,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CtaButtonBar extends StatelessWidget {
  const CtaButtonBar({
    super.key,
    required this.child,
    this.horizontalPadding = 24,
    this.bottomSpacing = 45,
  });

  final Widget child;
  final double horizontalPadding;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        bottomSpacing,
      ),
      child: child,
    );
  }
}

class _SparkleLayer extends StatefulWidget {
  const _SparkleLayer();

  @override
  State<_SparkleLayer> createState() => _SparkleLayerState();
}

class _SparkleLayerState extends State<_SparkleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _sparkles = <_SparkleSpec>[
    _SparkleSpec(0.18, 0.58, 5.5, 0.0, 1.0),
    _SparkleSpec(0.34, 0.30, 4.5, 0.8, 1.25),
    _SparkleSpec(0.48, 0.18, 6.5, 1.5, 0.95),
    _SparkleSpec(0.66, 0.72, 4.5, 2.1, 1.35),
    _SparkleSpec(0.79, 0.46, 6.5, 2.7, 1.15),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Stack(
              children: [
                for (final sparkle in _sparkles)
                  Positioned(
                    left: width * sparkle.dx - sparkle.size / 2,
                    top: height * sparkle.dy - sparkle.size / 2,
                    child: _SparkleDot(
                      size: sparkle.size,
                      opacity:
                          0.28 +
                          0.72 *
                              ((math.sin(
                                        (_controller.value *
                                                math.pi *
                                                2 *
                                                sparkle.speed) +
                                            sparkle.phase,
                                      ) +
                                      1) /
                                  2),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SparkleDot extends StatelessWidget {
  const _SparkleDot({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: opacity * 0.85),
            blurRadius: size * 1.8,
            spreadRadius: size * 0.15,
          ),
        ],
      ),
    );
  }
}

class _SparkleSpec {
  const _SparkleSpec(this.dx, this.dy, this.size, this.phase, this.speed);

  final double dx;
  final double dy;
  final double size;
  final double phase;
  final double speed;
}
