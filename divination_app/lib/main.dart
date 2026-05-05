import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const DivinationApp());
}

class DivinationApp extends StatelessWidget {
  const DivinationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '六爻卜卦',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC98933),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
