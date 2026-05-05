import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import '../widgets/analysis_banner.dart';
import '../widgets/cta_button.dart';
import 'find_object_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroBanner(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '核心功能',
                        style: TextStyle(
                          fontSize: 14.3,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E2E33),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '六大专业工具，全方位解析命理',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const _FeatureGrid(),
                  const SizedBox(height: 10),
                  const AnalysisBanner(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned(
            left: 67,
            top: 47,
            width: 244,
            height: 148,
            child: Container(
              color: const Color(0xFFF7F0E9).withValues(alpha: 0.5),
            ),
          ),
          Positioned(
            left: 131,
            top: 154,
            width: 118,
            height: 82,
            child: Container(
              color: const Color(0xFFF5F0E9).withValues(alpha: 0.4),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00F8FAF8), Color(0xFFF8FAF8)],
                ),
              ),
            ),
          ),
          // Nav bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '六爻卜卦',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          '今日  ${_todayLabel()}  吉',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF7D8088),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _NavIconButton(icon: Icons.access_time_rounded),
                        const SizedBox(width: 8),
                        _NavIconButton(icon: Icons.person_outline_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 3 coins
          Positioned(
            top: 115,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 205,
                height: 68,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/images/coin_a.png',
                        width: 47,
                        height: 47,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/images/coin_a.png',
                        width: 47,
                        height: 47,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/images/coin_b.png',
                          width: 47,
                          height: 47,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // "寻物" + button row
          Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '寻物',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2E2E33),
                            letterSpacing: 1.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const SizedBox(
                          width: 132,
                          child: Text(
                            '专业易学工具，寻找丢失的物品，获取方位与指引',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF7D8088),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CtaButton(
                    label: '开始探索',
                    width: 162,
                    height: 40,
                    borderRadius: 8,
                    showArrow: true,
                    sparkles: true,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FindObjectScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$month/$day 巳时';
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF2E2E33)),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const List<Map<String, String>> features = [
    {
      'title': '占卜解答',
      'desc': '解答疑问，指引方向，洞察未来，趋吉避凶',
      'tag': '占卜\n解答',
      'img': 'assets/images/card_1.png',
    },
    {
      'title': '预测运势',
      'desc': '预测事业、财运、感情\n健康等运势',
      'tag': '预测\n运势',
      'img': 'assets/images/card_2.png',
    },
    {
      'title': '择日选时',
      'desc': '选择吉日吉时\n助力重要事项顺利进行',
      'tag': '择日\n选时',
      'img': 'assets/images/card_3.png',
    },
    {
      'title': '方向指引',
      'desc': '指引出行、决策方向\n为你的选择提供参考',
      'tag': '方向\n指引',
      'img': 'assets/images/card_4.png',
    },
    {
      'title': '问人寻人',
      'desc': '询问他人情况或寻找\n特定之人，获取信息',
      'tag': '问人\n寻人',
      'img': 'assets/images/card_5.png',
    },
    {
      'title': '其他杂占',
      'desc': '解决生活中各类疑问\n灵活应对各种需求',
      'tag': '其他\n杂占',
      'img': 'assets/images/card_6.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 162 / 104,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final f = features[index];
        return FeatureCard(
          title: f['title']!,
          description: f['desc']!,
          tag: f['tag']!,
          imagePath: f['img']!,
        );
      },
    );
  }
}
