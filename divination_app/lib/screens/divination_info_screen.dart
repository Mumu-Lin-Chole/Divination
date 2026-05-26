import 'package:flutter/material.dart';
import 'divination_meditation_screen.dart';

class DivinationInfoScreen extends StatefulWidget {
  final String question;

  const DivinationInfoScreen({super.key, required this.question});

  @override
  State<DivinationInfoScreen> createState() => _DivinationInfoScreenState();
}

class _DivinationInfoScreenState extends State<DivinationInfoScreen> {
  String _gender = '男';
  int _year = 1995;
  int _month = 5;
  int _day = 19;
  String _timePeriod = '午时';
  String _timeRange = '11:00-13:00';

  static const _timePeriods = [
    {'period': '子时', 'range': '23:00-01:00'},
    {'period': '丑时', 'range': '01:00-03:00'},
    {'period': '寅时', 'range': '03:00-05:00'},
    {'period': '卯时', 'range': '05:00-07:00'},
    {'period': '辰时', 'range': '07:00-09:00'},
    {'period': '巳时', 'range': '09:00-11:00'},
    {'period': '午时', 'range': '11:00-13:00'},
    {'period': '未时', 'range': '13:00-15:00'},
    {'period': '申时', 'range': '15:00-17:00'},
    {'period': '酉时', 'range': '17:00-19:00'},
    {'period': '戌时', 'range': '19:00-21:00'},
    {'period': '亥时', 'range': '21:00-23:00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EF),
      body: SafeArea(
        child: Column(
          children: [
            _buildNavBar(context),
            const SizedBox(height: 0),
            _buildSubtitle(),
            const SizedBox(height: 48),
            _buildForm(),
            const Spacer(),
            _buildBottomButtons(),
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
            '补充信息',
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
      '——        补充信息可提升解读准确性        ——',
      style: TextStyle(
        fontFamily: 'SourceHanSerifSC',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Color(0xFFD19140),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gender
          const Text(
            '性别',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8F8B83),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _GenderButton(
                label: '男',
                selected: _gender == '男',
                onTap: () => setState(() => _gender = '男'),
              ),
              const SizedBox(width: 31),
              _GenderButton(
                label: '女',
                selected: _gender == '女',
                onTap: () => setState(() => _gender = '女'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Birth date
          const Text(
            '出生日期',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8F8B83),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 13.5,
                    offset: const Offset(0, 5.4),
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  Text(
                    '$_year    年     $_month    月     $_day    日',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A5522),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                    color: Color(0xFFC8C0B6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Birth time
          const Text(
            '出生时间',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8F8B83),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 13.5,
                    offset: const Offset(0, 5.4),
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  Text(
                    '$_timePeriod            $_timeRange',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A5522),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                    color: Color(0xFFC8C0B6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_year, _month, _day),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFD19140),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _year = picked.year;
        _month = picked.month;
        _day = picked.day;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('选择出生时辰'),
          children: _timePeriods.map((t) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, t),
              child: Text(
                '${t['period']}  ${t['range']}',
                style: TextStyle(
                  color:
                      _timePeriod == t['period']
                          ? const Color(0xFFD19140)
                          : const Color(0xFF7A5522),
                  fontWeight:
                      _timePeriod == t['period']
                          ? FontWeight.w700
                          : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timePeriod = picked['period']!;
        _timeRange = picked['range']!;
      });
    }
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
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
                  '上一步',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8F7F6C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 42,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DivinationMeditationScreen(
                          question: widget.question,
                          gender: _gender,
                          year: _year,
                          month: _month,
                          day: _day,
                          timePeriod: _timePeriod,
                          timeRange: _timeRange,
                        ),
                      ),
                    );
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
                    '继续',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 42,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD19140) : const Color(0xFFF2E7D3),
          borderRadius: BorderRadius.circular(21),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF7A5522),
          ),
        ),
      ),
    );
  }
}
