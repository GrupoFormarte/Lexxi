import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/src/global/design_system/color_palette.dart';

@RoutePage()
class SignupSuccessPage extends StatefulWidget {
  final String imageBase64;

  const SignupSuccessPage({
    super.key,
    required this.imageBase64,
  });

  @override
  State<SignupSuccessPage> createState() => _SignupSuccessPageState();
}

class _SignupSuccessPageState extends State<SignupSuccessPage> {
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();

    _imageBytes = base64Decode(widget.imageBase64);

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.router.replaceNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: ColorPalette.gradientBlueBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(
                    _imageBytes,
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    '¡Registro exitoso!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Tu cuenta ha sido creada correctamente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Te estamos llevando al inicio de sesión...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}