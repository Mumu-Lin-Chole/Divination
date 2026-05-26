import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isFlashOn = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) return;
    await _setupController(_cameras![_selectedCameraIndex]);
  }

  Future<void> _setupController(CameraDescription camera) async {
    // Dispose old controller first to avoid conflict
    await _controller?.dispose();
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } on CameraException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('相机初始化失败')));
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isFlashOn) {
      await _controller!.setFlashMode(FlashMode.off);
    } else {
      await _controller!.setFlashMode(FlashMode.torch);
    }
    setState(() => _isFlashOn = !_isFlashOn);
  }

  Future<void> _toggleCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _setupController(_cameras![_selectedCameraIndex]);
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }
    setState(() => _isTakingPicture = true);
    try {
      final XFile file = await _controller!.takePicture();
      if (mounted) {
        Navigator.of(context).pop(file.path);
      }
    } on CameraException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('拍照失败')));
      }
    } finally {
      if (mounted) setState(() => _isTakingPicture = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller != null && _controller!.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                _buildCameraPreview(),
                _buildTopBar(),
                _buildInfoBadge(),
                _buildFocusFrame(),
                _buildBottomTabs(),
                _buildBottomControls(),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: Color(0xFFD19140)),
            ),
    );
  }

  Widget _buildCameraPreview() {
    return ClipRRect(
      child: Transform.scale(scale: 1.0, child: CameraPreview(_controller!)),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 94,
          child: Stack(
            children: [
              Positioned(
                left: 16,
                top: 15,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: _iconClose(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 12,
                child: Center(
                  child: Text(
                    '拍照',
                    style: TextStyle(
                      fontFamily: 'SourceHanSerifSC',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                  onTap: () {
                    // TODO: open album
                  },
                  child: Row(
                    children: [
                      _iconAlbum(),
                      const SizedBox(width: 3),
                      const Text(
                        '相册',
                        style: TextStyle(
                          fontFamily: 'SourceHanSerifSC',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF777983),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge() {
    return Positioned(
      top: 109,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(119, 121, 131, 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '请将物品置于取景框内保持光线充足，图像清晰',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFocusFrame() {
    return Center(
      child: SizedBox(
        width: 257,
        height: 257,
        child: Stack(
          children: [
            // Outer border
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Grid lines - vertical
            _buildGridLine(isVertical: true, position: 85.5),
            _buildGridLine(isVertical: true, position: 171.5),
            // Grid lines - horizontal
            _buildGridLine(isVertical: false, position: 85.5),
            _buildGridLine(isVertical: false, position: 171.5),
            // Center crosshair
            Positioned(
              left: 118,
              top: 116,
              child: Container(
                width: 21,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            Positioned(
              left: 127.5,
              top: 106.5,
              child: Container(
                width: 2,
                height: 21,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridLine({required bool isVertical, required double position}) {
    if (isVertical) {
      return Positioned(
        left: position,
        top: 0,
        bottom: 0,
        child: Container(width: 1, color: Colors.white.withValues(alpha: 0.22)),
      );
    }
    return Positioned(
      left: 0,
      right: 0,
      top: position,
      child: Container(height: 1, color: Colors.white.withValues(alpha: 0.22)),
    );
  }

  Widget _buildBottomTabs() {
    return Positioned(
      left: 0,
      right: 0,
      top: 623,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '拍照',
                style: TextStyle(
                  fontFamily: 'SourceHanSerifSC',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD19140),
                ),
              ),
              const SizedBox(height: 1),
              Container(width: 21, height: 2, color: const Color(0xFFD6A24B)),
            ],
          ),
          const SizedBox(width: 24),
          const Text(
            '扫描',
            style: TextStyle(
              fontFamily: 'SourceHanSerifSC',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC8C0B6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      top: 678,
      child: SizedBox(
        height: 65,
        child: Stack(
          children: [
            // Flash button
            Positioned(
              left: 46,
              top: 8,
              child: GestureDetector(
                onTap: _toggleFlash,
                child: Column(
                  children: [
                    Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: const Color(0xFF777983),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '闪光灯',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF777983),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Camera flip button
            Positioned(
              right: 46,
              top: 8,
              child: GestureDetector(
                onTap: _toggleCamera,
                child: Column(
                  children: [
                    const Icon(
                      Icons.flip_camera_android,
                      color: Color(0xFF777983),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '翻转',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF777983),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Capture button
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isTakingPicture ? null : _takePicture,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomPaint(painter: _CaptureButtonPainter()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Icon helpers ----

  Widget _iconClose() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _CloseIconPainter()),
    );
  }

  Widget _iconAlbum() {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _AlbumIconPainter()),
    );
  }
}

// ---- Painters ----

class _CaptureButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer ring
    final outerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius - 2.5, outerPaint);

    // Inner white circle
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 8, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CloseIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AlbumIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF777983)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = RRect.fromRectAndRadius(
      Offset(0, size.height * 0.125) & Size(size.width, size.height * 0.75),
      const Radius.circular(2),
    );
    canvas.drawRRect(rect, paint);

    // Mountain shape inside
    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.875);
    path.lineTo(size.width * 0.45, size.height * 0.4);
    path.lineTo(size.width * 0.75, size.height * 0.875);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
