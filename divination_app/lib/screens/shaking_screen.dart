import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../widgets/cta_button.dart';
import 'hexagram_result_screen.dart';

class ShakingScreen extends StatefulWidget {
  final String objectDescription;
  final dynamic objectImage;

  const ShakingScreen({
    super.key,
    required this.objectDescription,
    this.objectImage,
  });

  @override
  State<ShakingScreen> createState() => _ShakingScreenState();
}

class _ShakingScreenState extends State<ShakingScreen>
    with SingleTickerProviderStateMixin {
  final List<int?> _lines = List.filled(6, null); // null=未起, 0=阴爻, 1=阳爻
  int _completedLines = 0;
  bool _isComplete = false;
  StreamSubscription? _accelSubscription;
  DateTime _lastShake = DateTime.now();
  late AnimationController _pulseController;

  static const double _shakeThreshold = 12.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _startListening();
  }

  void _startListening() {
    _accelSubscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      final now = DateTime.now();
      if (magnitude > _shakeThreshold &&
          now.difference(_lastShake).inMilliseconds > 600 &&
          _completedLines < 6) {
        _lastShake = now;
        _castNextLine();
      }
    });
  }

  void _castNextLine() {
    if (_completedLines >= 6) return;
    final value = Random().nextInt(2);
    setState(() {
      _lines[_completedLines] = value;
      _completedLines++;
      if (_completedLines == 6) {
        _isComplete = true;
        _accelSubscription?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _lineLabel {
    const labels = ['初爻', '二爻', '三爻', '四爻', '五爻', '上爻'];
    if (_completedLines < 6) return '正在起${labels[_completedLines]}';
    return '卦象已成';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDF8), Color(0xFFFBF2E6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildNavBar(context),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildTurtleSection(),
                    const SizedBox(height: 24),
                    _buildHintText(),
                    const SizedBox(height: 24),
                    _buildHexagramLines(),
                    const Spacer(),
                    _buildProgressText(),
                    const SizedBox(height: 32),
                    if (_isComplete) _buildResultButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Color(0xFF2E2E33),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              '摇卦',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E33),
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildTurtleSection() {
    return GestureDetector(
      onTap: _completedLines < 6 ? _castNextLine : null,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = _isComplete
              ? 1.0
              : 0.97 + 0.03 * _pulseController.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 228,
                height: 228,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFE8B7).withValues(alpha: 0.32),
                      const Color(0xFFFFF4DB).withValues(alpha: 0.14),
                      const Color(0x00FFF4DB),
                    ],
                    stops: const [0.0, 0.58, 1.0],
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF0D79E).withValues(alpha: 0.84),
                  ),
                ),
              ),
              Container(
                width: 144,
                height: 144,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFFAEF).withValues(alpha: 0.82),
                      const Color(0xFFFFF4E0).withValues(alpha: 0.36),
                      const Color(0x00FFF4E0),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
              Image.asset(
                'assets/images/turtle.png',
                width: 116,
                height: 144,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintText() {
    return Column(
      children: [
        Text(
          _isComplete ? _lineLabel : '点击龟甲或摇晃手机起爻',
          style: TextStyle(
            fontSize: 14,
            color: _isComplete
                ? const Color(0xFFC98933)
                : const Color(0xFF7D8088),
            fontWeight: _isComplete ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (!_isComplete) ...[
          const SizedBox(height: 4),
          Text(
            _lineLabel,
            style: const TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
          ),
        ],
      ],
    );
  }

  Widget _buildHexagramLines() {
    const lineLabels = ['上爻', '五爻', '四爻', '三爻', '二爻', '初爻'];
    // Display from top (上爻=index5) to bottom (初爻=index0)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: List.generate(6, (displayIndex) {
          final dataIndex = 5 - displayIndex;
          final value = _lines[dataIndex];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    lineLabels[displayIndex],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7D8088),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _buildLine(value)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLine(int? value) {
    if (value == null) {
      // Not yet cast — show empty placeholder
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      );
    }
    if (value == 1) {
      // 阳爻 — solid line
      return Container(
        height: 8,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    } else {
      // 阴爻 — broken line
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildProgressText() {
    return Text(
      '已完成 $_completedLines/6 爻',
      style: const TextStyle(fontSize: 13, color: Color(0xFF7D8088)),
    );
  }

  Widget _buildResultButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CtaButton(
        label: '查看卦象解析',
        width: double.infinity,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => HexagramResultScreen(
                    lines: List<int>.from(_lines),
                    objectDescription: widget.objectDescription,
                  ),
            ),
          );
        },
      ),
    );
  }
}
