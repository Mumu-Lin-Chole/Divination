import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const PermissionDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  static Future<void> showCameraPermission(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (_) => PermissionDialog(
        title: '允许访问相机',
        description: '拍摄或上传物品图片，能让占卜更准确地感知信息，为您提供更精确的指引。',
        icon: Icons.camera_alt_outlined,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 42),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 38),
            padding: const EdgeInsets.fromLTRB(28, 78, 28, 26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SourceHanSerifSC',
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E2E33),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SourceHanSerifSC',
                    fontSize: 14,
                    color: Color(0xFF9C988F),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: Color(0xFFE3D6C3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            '暂不允许',
                            style: TextStyle(
                              fontFamily: 'SourceHanSerifSC',
                              color: Color(0xFFAA9980),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFFF4C65D), Color(0xFFE29A19)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE0A33A,
                                ).withValues(alpha: 0.22),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await openAppSettings();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              '去设置',
                              style: TextStyle(
                                fontFamily: 'SourceHanSerifSC',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFBF2), Color(0xFFFFF0D3)],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.92),
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE2C48A).withValues(alpha: 0.30),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xFFD69535), size: 36),
            ),
          ),
        ],
      ),
    );
  }
}
