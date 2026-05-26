import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'divination_hexagram_screen.dart';

class DivinationMeditationScreen extends StatefulWidget {
  final String question;
  final String gender;
  final int year;
  final int month;
  final int day;
  final String timePeriod;
  final String timeRange;

  const DivinationMeditationScreen({
    super.key,
    required this.question,
    required this.gender,
    required this.year,
    required this.month,
    required this.day,
    required this.timePeriod,
    required this.timeRange,
  });

  @override
  State<DivinationMeditationScreen> createState() =>
      _DivinationMeditationScreenState();
}

class _DivinationMeditationScreenState
    extends State<DivinationMeditationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  StreamSubscription? _accelSubscription;
  bool _isReady = false;
  bool _canShake = false;
  final List<int> _lines = List.filled(6, 0);
  int _completedLines = 0;
  DateTime _lastShake = DateTime.now();
  static const double _shakeThreshold = 12.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _accelSubscription?.cancel();
    super.dispose();
  }

  void _onReady() {
    setState(() {
      _isReady = true;
      _canShake = true;
    });
    _startShakeListening();
  }

  void _startShakeListening() {
    _accelSubscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      final now = DateTime.now();
      if (magnitude > _shakeThreshold &&
          now.difference(_lastShake).inMilliseconds > 600 &&
          _completedLines < 6 &&
          _canShake) {
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
        _accelSubscription?.cancel();
        _navigateToResult();
      }
    });
  }

  void _navigateToResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DivinationHexagramScreen(
          question: widget.question,
          gender: widget.gender,
          year: widget.year,
          month: widget.month,
          day: widget.day,
          timePeriod: widget.timePeriod,
          timeRange: widget.timeRange,
          lines: List<int>.from(_lines),
        ),
      ),
    );
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
              const Spacer(),
              _buildCircleDiagram(),
              const Spacer(),
              if (!_isReady) _buildReadyButton(),
              if (_isReady) _buildShakeHint(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: Color(0xFF2E2E33),
                ),
              ),
            ),
          ),
          const Text(
            '静心',
            style: TextStyle(
              fontFamily: 'SourceHanSerifSC',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleDiagram() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = _isReady ? 1.0 : 0.97 + 0.03 * _pulseController.value;
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 284,
            height: 284,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outermost ring
                Container(
                  width: 284,
                  height: 284,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF0D79E).withValues(alpha: 0.56),
                      width: 1,
                    ),
                  ),
                ),
                // Warm glow
                Container(
                  width: 256,
                  height: 256,
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
                // Middle ring
                Container(
                  width: 214,
                  height: 214,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF0D79E).withValues(alpha: 0.84),
                    ),
                  ),
                ),
                // Inner circle
                Container(
                  width: 193,
                  height: 193,
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
                // Center text
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '静心凝神',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD19140),
                        height: 1.58,
                      ),
                    ),
                    Text(
                      '心念所问之事',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD19140),
                        height: 1.58,
                      ),
                    ),
                    Text(
                      '默念三次',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD19140),
                        height: 1.58,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF1C66E), Color(0xFFD48A16)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6.7,
                offset: const Offset(0, 5.4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _onReady,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              '我已准备好',
              style: TextStyle(
                fontFamily: 'SourceHanSerifSC',
                fontSize: 17.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShakeHint() {
    return Column(
      children: [
        // Progress
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '已起爻 ',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8F8B83),
                ),
              ),
              TextSpan(
                text: '$_completedLines / 6',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFD19140),
                ),
              ),
              const TextSpan(
                text: '爻',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8F8B83),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '摇晃手机完成起卦',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFC98933),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
