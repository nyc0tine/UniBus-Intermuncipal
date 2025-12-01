import 'package:flutter/material.dart';

void main() {
  runApp(const UniBus());
}

class UniBus extends StatelessWidget {
  const UniBus({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unibus Intermunicipal',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF4D61B0, {
          50: Color(0xFFF3F5FC),
          100: Color(0xFFE3E9F7),
          200: Color(0xFFCDD9F1),
          300: Color(0xFFB7C9EB),
          400: Color(0xFFA6BBE5),
          500: Color(0xFF4D61B0),
          600: Color(0xFF4659AA),
          700: Color(0xFF3D4DA3),
          800: Color(0xFF35419C),
          900: Color(0xFF273088),
        }),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Unibus Intermunicipal!'),
        ),
      ),
    );
  }
}
