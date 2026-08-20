import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_state.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';

class SignupStep6Credentials extends StatefulWidget {
  const SignupStep6Credentials({super.key});

  @override
  State<SignupStep6Credentials> createState() => _SignupStep6CredentialsState();
}

class _SignupStep6CredentialsState extends State<SignupStep6Credentials> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  String? _fieldError;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegisterBloc>().state.data;
    _emailController = TextEditingController(text: data.email);
    _passwordController = TextEditingController(text: data.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegex.hasMatch(email);
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_isEmailValid(email)) {
      setState(() => _fieldError = 'Ingresa un correo válido');
      return;
    }
    if (password.length < 6) {
      setState(
        () => _fieldError = 'La contraseña debe tener al menos 6 caracteres',
      );
      return;
    }
    setState(() => _fieldError = null);

    context.read<RegisterBloc>().add(
      RegisterCredentialsSubmitted(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {}
      },
      builder: (context, state) {
        final isLoading = state.status == RegisterStatus.loading;
        final error =
            _fieldError ??
            (state.status == RegisterStatus.failure
                ? state.errorMessage
                : null);

        return SignupStepScaffold(
          currentStep: 5,
          totalSteps: 6,
          imageAsset: 'assets/signup/step6_credentials.png',
          title: 'Configura tu acceso',
          continueLabel: 'Crear cuenta',
          isLoading: isLoading,
          onContinue: _submit,
          onBack: () =>
              context.read<RegisterBloc>().add(const RegisterStepBack()),
          errorMessage: error,
          content: Column(
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
