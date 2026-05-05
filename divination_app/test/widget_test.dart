import 'package:flutter_test/flutter_test.dart';

import 'package:divination_app/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DivinationApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('六爻卜卦'), findsOneWidget);
    expect(find.text('开始探索'), findsOneWidget);
    expect(find.text('核心功能'), findsOneWidget);
  });
}
