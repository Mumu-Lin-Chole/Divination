import 'package:flutter/material.dart';

class AnalysisBanner extends StatelessWidget {
  const AnalysisBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFCF8F1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFCF8F1),
                      Color(0xFFFFFAF3),
                      Color(0xFFFFF1DA),
                      Color(0xFFFFE2B0),
                    ],
                    stops: [0.0, 0.42, 0.76, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -54,
              top: -66,
              child: Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD98F).withValues(alpha: 0.82),
                      const Color(0xFFFFE7B8).withValues(alpha: 0.42),
                      const Color(0x00FFE7B8),
                    ],
                    stops: const [0.0, 0.48, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -8,
              top: -18,
              bottom: -8,
              width: 250,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/analysis_book.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFFCF8F1),
                      const Color(0xFFFCF8F1).withValues(alpha: 0.94),
                      const Color(0xFFFCF8F1).withValues(alpha: 0.44),
                      const Color(0x00FCF8F1),
                    ],
                    stops: const [0.0, 0.42, 0.65, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 18,
              right: 112,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '专业易学解析',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD18F34),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '传承千年智慧，科学分析解读',
                    style: TextStyle(
                      fontSize: 10.6,
                      height: 1.35,
                      color: Color(0xFF8E7A61),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _BannerTag(icon: Icons.menu_book_outlined, label: '专业算法'),
                      _BannerTag(icon: Icons.image_outlined, label: '精准分析'),
                      _BannerTag(icon: Icons.shield_outlined, label: '隐私安全'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerTag extends StatelessWidget {
  const _BannerTag({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFFD19140)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9.2,
              color: Color(0xFFD19140),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
