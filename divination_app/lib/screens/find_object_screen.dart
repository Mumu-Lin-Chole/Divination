import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/cta_button.dart';
import '../widgets/permission_dialog.dart';
import 'shaking_screen.dart';
import 'camera_screen.dart';

class FindObjectScreen extends StatefulWidget {
  const FindObjectScreen({super.key});

  @override
  State<FindObjectScreen> createState() => _FindObjectScreenState();
}

class _FindObjectScreenState extends State<FindObjectScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;
  XFile? _pickedImage;
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _handleCamera() async {
    // final status = await Permission.camera.status;

    // if (!mounted) return;
    // if (status.isDenied || status.isPermanentlyDenied) {
    //   await PermissionDialog.showCameraPermission(context);
    //   return;
    // }
    // final imagePath = await Navigator.push<String>(
    //   context,
    //   MaterialPageRoute(builder: (_) => const CameraScreen()),
    // );
    // if (imagePath != null && mounted) {
    //   setState(() => _pickedImage = XFile(imagePath));
    // }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );
  }

  Future<void> _handleVoice() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) return;
    }
    // Voice input UI feedback only — speech recognition requires GitHub-accessible packages
    setState(() => _isListening = !_isListening);
    if (_isListening) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _isListening = false);
    }
  }

  void _startDivination() {
    final text = _textController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ShakingScreen(objectDescription: text, objectImage: _pickedImage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF6),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHint(),
              const SizedBox(height: 8),
              CtaButton(
                label: '开始摇卦',
                width: double.infinity,
                height: 48,
                borderRadius: 24,
                showShadow: false,
                onTap: _startDivination,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _FindObjectBackground()),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildNavBar(context),
                  const SizedBox(height: 6),
                  _buildSubtitle(),
                  const SizedBox(height: 20),
                  _buildOracleVisual(),
                  const SizedBox(height: 24),
                  _buildInputCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22,
                color: Color(0xFF201C1A),
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 40),
              child: Text(
                '寻物',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1C1A),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _GoldenLine(),
        SizedBox(width: 14),
        Text(
          '玄机卜卦·指引寻回',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFC98E39),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(width: 14),
        _GoldenLine(),
      ],
    );
  }

  Widget _buildOracleVisual() {
    return SizedBox(
      height: 334,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: SizedBox(
                width: 294,
                height: 248,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 286,
                      height: 286,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFFE9B8).withValues(alpha: 0.34),
                            const Color(0xFFFFF3D8).withValues(alpha: 0.14),
                            const Color(0x00FFF3D8),
                          ],
                          stops: const [0.0, 0.58, 1.0],
                        ),
                      ),
                    ),
                    Container(
                      width: 228,
                      height: 228,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(
                            0xFFF0D79E,
                          ).withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFFFAEF).withValues(alpha: 0.88),
                            const Color(0xFFFFF5E3).withValues(alpha: 0.46),
                            const Color(0x00FFF5E3),
                          ],
                          stops: const [0.0, 0.58, 1.0],
                        ),
                      ),
                    ),
                    _pickedImage != null
                        ? _buildUploadedPreview()
                        : Image.asset(
                            'assets/images/turtle.png',
                            width: 176,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(left: 8, top: 104, child: _SidePill(label: '静心专注')),
          const Positioned(right: 8, top: 104, child: _SidePill(label: '卦定吉凶')),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: SizedBox(
                width: 264,
                height: 92,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 10,
                      child: Image.asset(
                        'assets/images/coin_b.png',
                        width: 72,
                        height: 72,
                      ),
                    ),
                    Positioned(
                      left: 96,
                      top: 22,
                      child: Image.asset(
                        'assets/images/coin_b.png',
                        width: 72,
                        height: 72,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 10,
                      child: Image.asset(
                        'assets/images/coin_b.png',
                        width: 72,
                        height: 72,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedPreview() {
    return SizedBox(
      width: 154,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(_pickedImage!.path),
              width: 136,
              height: 136,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 34),
                SizedBox(height: 8),
                Text(
                  '上传成功',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      width: double.infinity,
      height: 162,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 13.5,
            offset: const Offset(0, 5.4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: '请详细描述您丢失的物品及其特征...',
                  hintStyle: TextStyle(
                    color: Color(0xFF8F8B83),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2E2E33),
                  height: 1.65,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _InputActionButton(
                  icon: Icons.camera_alt_outlined,
                  onTap: _handleCamera,
                ),
                const SizedBox(width: 10),
                _InputActionButton(
                  icon: _isListening
                      ? Icons.mic_rounded
                      : Icons.mic_none_rounded,
                  onTap: _handleVoice,
                  active: _isListening,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Column(
          children: [
            const Text(
              '认真默念心中所想，而后点击起爻',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFFB87821),
              ),
            ),
            const SizedBox(height: 4),
            Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFFB87821),
                size: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FindObjectBackground extends StatelessWidget {
  const _FindObjectBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFCF8), Color(0xFFFBF1E2)],
              ),
            ),
          ),
        ),
        Positioned(
          top: -90,
          left: -70,
          child: _GlowOrb(
            size: 230,
            color: const Color(0xFFFFF0CB).withValues(alpha: 0.55),
          ),
        ),
        Positioned(
          top: 130,
          right: -110,
          child: _GlowOrb(
            size: 300,
            color: const Color(0xFFFFE9BF).withValues(alpha: 0.50),
          ),
        ),
        Positioned(
          bottom: -120,
          left: -80,
          child: _GlowOrb(
            size: 280,
            color: const Color(0xFFFFEFD1).withValues(alpha: 0.42),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}

class _GoldenLine extends StatelessWidget {
  const _GoldenLine();

  @override
  Widget build(BuildContext context) {
    return Container(width: 26, height: 1, color: const Color(0xFFD6A154));
  }
}

class _SidePill extends StatelessWidget {
  const _SidePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD8B16B).withValues(alpha: 0.72),
        ),
      ),
      child: Text(
        label.split('').join('\n'),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          height: 1.45,
          color: Color(0xFF96836B),
        ),
      ),
    );
  }
}

class _InputActionButton extends StatelessWidget {
  const _InputActionButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF3E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? const Color(0xFFD26D3F) : const Color(0xFFC98933),
        ),
      ),
    );
  }
}
