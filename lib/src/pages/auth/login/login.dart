import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/login/bloc/login_bloc.dart';
import 'package:lexxi/aplication/auth/login/bloc/login_event.dart';
import 'package:lexxi/aplication/auth/login/bloc/login_state.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/design_system/typography.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/utils/whatsapp.dart';
import 'package:motion_toast/motion_toast.dart';

@RoutePage()
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  String email = '';
  String password = '';
  String? lastError;

  final FocusNode _currentFocusNode = FocusNode();
  final FocusNode _nextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      email = "coordinacionvirtual@grupoformarte.edu.co";
      password = "1010221676";
    }
  }

  @override
  void dispose() {
    _currentFocusNode.dispose();
    _nextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: ColorPalette.gradientBlueBackground,
        ),
        child: SafeArea(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                setState(() => lastError = state.message);
                MotionToast.error(
                  toastDuration: const Duration(seconds: 3),
                  description: Text(state.message),
                ).show(context);
                return;
              }

              if (state is LoginSuccess) {
                setState(() => lastError = null);

                context.read<DataUserProvider>().userViewModel = state.user;

                if (state.user.typeUser == 'student') {
                  context.router.replaceNamed('/all_programs');
                  return;
                }
                context.router.replaceNamed('/home');
              }
            },
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight =
                      constraints.maxHeight -
                      MediaQuery.of(context).viewInsets.bottom;
                  final illustrationHeight = (availableHeight * 0.32).clamp(
                    110.0,
                    220.0,
                  );

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 16,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: availableHeight - 32,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/logo_lexxi.png',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 90,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/lexxi.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: illustrationHeight,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/brujita@2x-8.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '¡Hola!',
                              textAlign: TextAlign.center,
                              style: AppTypography.displayLarge.copyWith(
                                color: AppColors.white,
                                fontSize: 32,
                                fontWeight: AppTypography.extraBold,
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              'Soy Lexxi, tu compañera en este viaje hacia tus metas.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildLabeledField(
                              label: 'Correo electrónico',
                              hintText: 'correo@ejemplo.com',
                              initialValue: email,
                              focusNode: _currentFocusNode,
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) => email = value,
                              onSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_nextFocusNode),
                            ),

                            const SizedBox(height: 14),
                            _buildLabeledField(
                              label: 'Número de documento',
                              hintText: '1023456789',
                              initialValue: password,
                              focusNode: _nextFocusNode,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => password = value,
                              onSubmitted: (_) => _submit(context),
                            ),

                            const SizedBox(height: 24),
                            if (isLoading)
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            else ...[
                              SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  text: 'INGRESAR',
                                  onPressed: () => _submit(context),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '¿Nuevo en Lexxi? ',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        context.router.pushNamed("/signUp"),
                                    child: const Text(
                                      'Crear cuenta',
                                      style: TextStyle(
                                        color: Color(0xFFFF8C00),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFFFF8C00),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 16),

                            if (lastError != null)
                              GestureDetector(
                                onTap: () async {
                                  launchWhatsAppUri(
                                    '+573183491375',
                                    'El usuario con el correo: $email, tiene el siguiente error:$lastError',
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.redAccent[100],
                                      child: const Icon(
                                        Icons.warning_amber_rounded,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Si persiste este error informar aquí",
                                      style: TextStyle(
                                        color: Colors.redAccent[100],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required String hintText,
    required String initialValue,
    required FocusNode focusNode,
    required bool obscureText,
    required TextInputType keyboardType,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          cursorColor: AppColors.blueDark,
          style: AppTypography.inputText.copyWith(
            color: AppColors.blueDark,
            fontSize: 16,
            fontWeight: AppTypography.semiBold,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.inputHint.copyWith(
              color: AppColors.blueDark.withOpacity(0.6),
              fontSize: 10,
              fontWeight: AppTypography.regular,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    context.read<LoginBloc>().add(
      LoginSubmitted(email: email, password: password),
    );
  }
}
