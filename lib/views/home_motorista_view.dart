import 'package:flutter/material.dart';

class HomeMotoristaView extends StatelessWidget {
  const HomeMotoristaView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Home Motorista – Em desenvolvimento",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
