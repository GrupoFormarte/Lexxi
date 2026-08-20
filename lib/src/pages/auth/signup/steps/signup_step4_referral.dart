import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/selectable_chip.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';

class SignupStep4Referral extends StatefulWidget {
  const SignupStep4Referral({super.key});

  @override
  State<SignupStep4Referral> createState() => _SignupStep4ReferralState();
}

class _SignupStep4ReferralState extends State<SignupStep4Referral> {
  // ⚠️ Ajusta estas 6 opciones a las reales de tu diseño.
  static const List<String> _options = [
    'Instagram',
    'Facebook',
    'TikTok',
    'Google',
    'Un amigo',
    'Colegio',
  ];

  late Set<String> _selected;
  late final TextEditingController _otherController;
  String? _error;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegisterBloc>().state.data;
    _selected = data.referralOptions.toSet();
    _otherController = TextEditingController(text: data.referralOther);
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _toggle(String option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
      } else {
        _selected.add(option);
      }
    });
  }

  void _continue() {
    if (_selected.isEmpty && _otherController.text.trim().isEmpty) {
      setState(() => _error = 'Selecciona al menos una opción');
      return;
    }
    setState(() => _error = null);
    context.read<RegisterBloc>().add(
      RegisterReferralSubmitted(
        options: _selected.toList(),
        otherText: _otherController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepScaffold(
      currentStep: 3,
      totalSteps: 6,
      imageAsset: 'assets/signup/step4_referral.png',
      title: '¿Cómo nos conociste?',
      onContinue: _continue,
      onBack: () => context.read<RegisterBloc>().add(const RegisterStepBack()),
      errorMessage: _error,
      content: Column(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _options
                .map(
                  (option) => SelectableChip(
                    label: option,
                    selected: _selected.contains(option),
                    onTap: () => _toggle(option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _otherController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Otro (opcional)',
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
        ],
      ),
    );
  }
}
