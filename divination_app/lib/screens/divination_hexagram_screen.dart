import 'package:flutter/material.dart';
import '../widgets/cta_button.dart';

class DivinationHexagramScreen extends StatefulWidget {
  final String question;
  final String gender;
  final int year;
  final int month;
  final int day;
  final String timePeriod;
  final String timeRange;
  final List<int> lines;

  const DivinationHexagramScreen({
    super.key,
    required this.question,
    required this.gender,
    required this.year,
    required this.month,
    required this.day,
    required this.timePeriod,
    required this.timeRange,
    required this.lines,
  });

  @override
  State<DivinationHexagramScreen> createState() =>
      _DivinationHexagramScreenState();
}

class _DivinationHexagramScreenState extends State<DivinationHexagramScreen> {
  bool _showPopup = false;

  static const _lineLabels = ['初爻', '二爻', '三爻', '四爻', '五爻', '上爻'];
  static const _liuQinLabels = [
    '父母丑土  世',
    '子孙亥水',
    '兄弟卯木',
    '官鬼午火',
    '兄弟申金',
    '父母戌土  应',
  ];
  static const _yaoLabels = ['阴爻', '阳爻', '阴爻', '阴爻', '阳爻', '阴爻'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 7),
                          _buildSubtitle(),
                          const SizedBox(height: 14),
                          _buildHexagramCircle(),
                          const SizedBox(height: 24),
                          _buildProgressSection(),
                          const SizedBox(height: 30),
                          _buildHexagramDetail(),
                          const SizedBox(height: 24),
                          _buildBottomButton(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showPopup) _buildPopup(),
        ],
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
            '占卜解答',
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

  Widget _buildSubtitle() {
    return const Text(
      '——        玄机卜卦 · 指引寻回        ——',
      style: TextStyle(
        fontFamily: 'SourceHanSerifSC',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Color(0xFFD19140),
      ),
    );
  }

  Widget _buildHexagramCircle() {
    return SizedBox(
      width: 284,
      height: 284,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
          Image.asset(
            'assets/images/turtle.png',
            width: 116,
            height: 144,
            fit: BoxFit.contain,
          ),
          // Side pills
          Positioned(
            right: -26,
            top: 54,
            child: _SidePill(label: '卦定吉凶'),
          ),
          Positioned(
            left: -26,
            top: 54,
            child: _SidePill(label: '静心专注'),
          ),
          // Hint badge
          Positioned(
            bottom: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '点击龟甲',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD19140),
                      ),
                    ),
                    TextSpan(
                      text: '或',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF777983),
                      ),
                    ),
                    TextSpan(
                      text: '摇晃手机',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD19140),
                      ),
                    ),
                    TextSpan(
                      text: '起爻',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF777983),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Coins
          Positioned(
            bottom: -16,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 252,
                height: 84,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 26,
                      child: Image.asset(
                        'assets/images/coin_b.png',
                        width: 58,
                        height: 58,
                      ),
                    ),
                    Positioned(
                      left: 97,
                      top: 26,
                      child: Image.asset(
                        'assets/images/coin_b.png',
                        width: 58,
                        height: 58,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/images/coin_b.png',
                        width: 58,
                        height: 58,
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

  Widget _buildProgressSection() {
    return SizedBox(
      height: 78,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '已起爻 ',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8F8B83),
                      ),
                    ),
                    const TextSpan(
                      text: '6 / 6',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD19140),
                      ),
                    ),
                    const TextSpan(
                      text: '爻',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8F8B83),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 24,
            child: Row(
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 56,
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD19140).withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD19140),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _lineLabels[i],
                        style: const TextStyle(
                          fontFamily: 'SourceHanSerifSC',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF777983),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHexagramDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: SizedBox(
        height: 170,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return Text(
                    _lineLabels[5 - i],
                    style: const TextStyle(
                      fontFamily: 'SourceHanSerifSC',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC8C0B6),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (displayIndex) {
                  final dataIndex = 5 - displayIndex;
                  final value = widget.lines[dataIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: value == 1 ? _buildYangLine() : _buildYinLine(),
                  );
                }),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return Text(
                    _yaoLabels[i],
                    style: const TextStyle(
                      fontFamily: 'SourceHanSerifSC',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD19140),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 72,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return Text(
                    _liuQinLabels[i],
                    style: const TextStyle(
                      fontFamily: 'SourceHanSerifSC',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD19140),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYangLine() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildYinLine() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: CtaButton(
        label: '查看卦象',
        width: 210,
        height: 35,
        borderRadius: 24,
        onTap: () => setState(() => _showPopup = true),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPopup() {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          // Dim overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showPopup = false),
              child: Container(
                color: Colors.black.withValues(alpha: 0.56),
              ),
            ),
          ),
          // Popup card
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 295,
                padding: const EdgeInsets.only(top: 32, bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF8),
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFDF8), Color(0xFFFBF2E6)],
                  ),
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
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => setState(() => _showPopup = false),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFF0D79E)),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Color(0xFFC8C0B6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Divider text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 26,
                          height: 1,
                          color: const Color(0xFFD6A154),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '乾卦',
                            style: TextStyle(
                              fontFamily: 'SourceHanSerifSC',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8F8B83),
                            ),
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 1,
                          color: const Color(0xFFD6A154),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Hexagram name
                    const Text(
                      '天泽履',
                      style: TextStyle(
                        fontFamily: 'SourceHanSerifSC',
                        fontSize: 21.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17.5),
                        border: Border.all(color: const Color(0xFFEFE2D0)),
                      ),
                      child: const Text(
                        '第10卦 · 上上卦',
                        style: TextStyle(
                          fontFamily: 'SourceHanSerifSC',
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8F7F6C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Hexagram lines
                    SizedBox(
                      height: 127,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (i) {
                                return Text(
                                  _lineLabels[5 - i],
                                  style: const TextStyle(
                                    fontFamily: 'SourceHanSerifSC',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFC8C0B6),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 86,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (displayIndex) {
                                final dataIndex = 5 - displayIndex;
                                final value = widget.lines[dataIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child:
                                      value == 1
                                          ? Container(
                                              height: 3,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
                                                ),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
                                                      ),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Container(
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [Color(0xFFF2C56D), Color(0xFFC98933)],
                                                      ),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 22,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (i) {
                                return Text(
                                  _yaoLabels[i],
                                  style: const TextStyle(
                                    fontFamily: 'SourceHanSerifSC',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD19140),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 72,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (i) {
                                return Text(
                                  _liuQinLabels[i],
                                  style: const TextStyle(
                                    fontFamily: 'SourceHanSerifSC',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD19140),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 乾宫 badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '乾宫',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFC99136),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // View button
                    SizedBox(
                      width: 210,
                      height: 35,
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
                          onPressed: () {
                            // TODO: navigate to detailed interpretation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            '查看卦象',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
}

class _SidePill extends StatelessWidget {
  const _SidePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label.split('').join('\n'),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          height: 1.4,
          color: Color(0xFF8F8B83),
          fontFamily: 'SourceHanSerifSC',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
