import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/src/global/widgets/rounded_date_picker.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';

class SignupStep2Birthday extends StatefulWidget {
  const SignupStep2Birthday({super.key});

  @override
  State<SignupStep2Birthday> createState() => _SignupStep2BirthdayState();
}

class _SignupStep2BirthdayState extends State<SignupStep2Birthday> {
  DateTime? _birthday;
  String? _error;

  @override
  void initState() {
    super.initState();
    _birthday = context.read<RegisterBloc>().state.data.birthday;
  }

  void _continue() {
    if (_birthday == null) {
      setState(() => _error = 'Selecciona tu fecha de nacimiento');
      return;
    }
    setState(() => _error = null);
    context.read<RegisterBloc>().add(RegisterBirthdaySubmitted(_birthday!));
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepScaffold(
      currentStep: 1,
      totalSteps: 6,
      imageAsset: 'assets/signup/bruja-cumple.png',
      subtitle: '¿Cuál es tu fecha de nacimiento?',
      description: 'Esto nos ayuda a confirmar que puedes usar la app.',
      onContinue: _continue,
      onBack: () => context.read<RegisterBloc>().add(const RegisterStepBack()),
      errorMessage: _error,
      content: RoundedDatePicker(
        hintText: "Fecha de nacimiento",
        width: double.infinity,
        initialDate: _birthday,
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now(),
        onDateSelected: (date) => setState(() {
          _birthday = date;
          _error = null;
        }),
        validator: (_) => null,
      ),
    );
  }
}
