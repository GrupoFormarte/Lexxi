import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 20,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/lexxi.png'),
        ),
      ),
    );
  }
}
