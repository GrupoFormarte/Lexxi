import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_state.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/design_system/color_palette.dart';
import 'package:lexxi/src/pages/auth/signup/steps/signup_step1_name.dart';
import 'package:lexxi/src/pages/auth/signup/steps/signup_step2_birthday.dart';
import 'package:lexxi/src/pages/auth/signup/steps/signup_step3_location.dart';
import 'package:lexxi/src/pages/auth/signup/steps/signup_step4_referral.dart';
import 'package:lexxi/src/pages/auth/signup/steps/signup_step5_exam_goal.dart';
import 'package:lexxi/src/pages/auth/signup/steps/signup_step6_credentials.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_loading_overlay.dart';

@RoutePage()
class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: const _SignUpWizard(),
    );
  }
}

class _SignUpWizard extends StatelessWidget {
  const _SignUpWizard();

  static const List<Widget> _steps = [
    SignupStep1Name(),
    SignupStep2Birthday(),
    SignupStep3Location(),
    SignupStep4Referral(),
    SignupStep5ExamGoal(),
    SignupStep6Credentials(),
  ];

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
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == RegisterStatus.success) {
              context.router.replaceNamed('/login');
            }
          },
          builder: (context, state) {
            if (state.status == RegisterStatus.loading) {
              return const SignupLoadingOverlay();
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey(state.step),
                child: _steps[state.step],
              ),
            );
          },
        ),
      ),
    );
  }
}
