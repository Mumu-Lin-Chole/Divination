import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.tag,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String tag;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.5),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 17.18,
            offset: const Offset(0, 6.68),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.5),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2E2E33),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _TagBadge(text: tag),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF777983),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  const _TagBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 7,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB32D24), width: 0.2),
        borderRadius: BorderRadius.circular(0.96),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 2.5,
            color: Color(0xFFA30101),
            height: 0.9,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
