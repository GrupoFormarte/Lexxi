import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/selectable_image_card.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';

class ExamGoalOption {
  final String id;
  final String imageAsset;
  final String label;

  const ExamGoalOption({
    required this.id,
    required this.imageAsset,
    required this.label,
  });
}

class SignupStep5ExamGoal extends StatefulWidget {
  const SignupStep5ExamGoal({super.key});

  @override
  State<SignupStep5ExamGoal> createState() => _SignupStep5ExamGoalState();
}

class _SignupStep5ExamGoalState extends State<SignupStep5ExamGoal> {
  static const List<ExamGoalOption> _options = [
    ExamGoalOption(
      id: 'saber11',
      imageAsset: 'assets/icon/pre-saber.png',
      label: 'Saber 11',
    ),
    ExamGoalOption(
      id: 'preUnal',
      imageAsset: 'assets/icon/pre-unal.png',
      label: 'Pre-UNAL',
    ),
    ExamGoalOption(
      id: 'preUdea',
      imageAsset: 'assets/icon/pre-udea.png',
      label: 'Pre-UDEA',
    ),
  ];

  String? _selectedId;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedId = context.read<RegisterBloc>().state.data.examGoal;
  }

  void _continue() {
    if (_selectedId == null) {
      setState(() => _error = 'Selecciona el examen que quieres conquistar');
      return;
    }

    setState(() => _error = null);

    context
        .read<RegisterBloc>()
        .add(RegisterExamGoalSubmitted(_selectedId!));
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepScaffold(
      currentStep: 4,
      totalSteps: 6,
      subtitle: '¿Cuál examen quieres conquistar?',
      onContinue: _continue,
      onBack: () => context
          .read<RegisterBloc>()
          .add(const RegisterStepBack()),
      errorMessage: _error,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _options
            .map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: SelectableImageCard(
                  imageAsset: option.imageAsset,
                  label: option.label,
                  selected: _selectedId == option.id,
                  onTap: () => setState(
                    () => _selectedId = option.id,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}