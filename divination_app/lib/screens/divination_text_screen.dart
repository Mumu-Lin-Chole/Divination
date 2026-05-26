import 'package:flutter/material.dart';
import 'divination_info_screen.dart';

class DivinationTextScreen extends StatefulWidget {
  const DivinationTextScreen({super.key});

  @override
  State<DivinationTextScreen> createState() => _DivinationTextScreenState();
}

class _DivinationTextScreenState extends State<DivinationTextScreen> {
  final TextEditingController _controller = TextEditingController();
  static const _maxLength = 100;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = _controller.text.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EF),
      body: SafeArea(
        child: Column(
          children: [
            _buildNavBar(context),
            const SizedBox(height: 0),
            _buildSubtitle(),
            const SizedBox(height: 48),
            _buildTextArea(),
            const SizedBox(height: 12),
            _buildCharCount(length),
            const Spacer(),
            _buildContinueButton(),
            const SizedBox(height: 10),
          ],
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
      '——        问题越具体 · 指引越清晰        ——',
      style: TextStyle(
        fontFamily: 'SourceHanSerifSC',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Color(0xFFD19140),
      ),
    );
  }

  Widget _buildTextArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: Container(
        height: 395,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(13.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 13.5,
              offset: const Offset(0, 5.4),
            ),
          ],
        ),
        child: Stack(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              maxLength: _maxLength,
              buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
              decoration: InputDecoration(
                hintText: '例如：\n我该不该换工作？\n感情能否有结果？\n这件事何时会有转机？',
                hintStyle: const TextStyle(
                  fontFamily: 'SourceHanSerifSC',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8F8B83),
                  height: 2.23,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(23, 30, 23, 30),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2E2E33),
                height: 2.23,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharCount(int length) {
    return Padding(
      padding: const EdgeInsets.only(right: 45),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '$length/$_maxLength',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFFC8C0B6),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DivinationInfoScreen(
                  question: _controller.text.trim(),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF2E7D3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: Color(0xFFEFE2D0), width: 0.5),
            ),
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.05),
          ),
          child: const Text(
            '继续',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8F7F6C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
