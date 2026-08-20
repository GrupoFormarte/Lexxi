import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/src/global/design_system/color_palette.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';

class SignupStep1Name extends StatefulWidget {
  const SignupStep1Name({super.key});

  @override
  State<SignupStep1Name> createState() => _SignupStep1NameState();
}

class _SignupStep1NameState extends State<SignupStep1Name> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegisterBloc>().state.data;
    _controller = TextEditingController(text: data.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Cuéntanos tu nombre para continuar');
      return;
    }
    setState(() => _error = null);
    context.read<RegisterBloc>().add(RegisterNameSubmitted(name));
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepScaffold(
      currentStep: 0,
      totalSteps: 6,
      title: 'Empecemos con lo básico',
      imageAsset: 'assets/icon/bruja-icon.png',
      subtitle: '¿Cuál es tu nombre?',
      description: 'Esto para personalizar tu experiencia.',
      onContinue: _continue,
      onBack: () => context.router.maybePop(),
      content: TextField(
        controller: _controller,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(color: ColorPalette.primary),
        cursorColor: ColorPalette.primary,
        decoration: InputDecoration(
          hintText: 'Escribe tu nombre',
          hintStyle: TextStyle(color: ColorPalette.primary.withOpacity(0.4)),
          errorText: _error,
          errorStyle: const TextStyle(color: Colors.redAccent),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
        ),
      ),
    );
  }
}