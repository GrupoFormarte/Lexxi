import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/global/widgets/rounded_text_field.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/utils/whatsapp.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../aplication/auth/service/auth_service.dart';

@RoutePage() // Add this annotation to your routable pages
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService? _authService; // Obtiene el servicio de autenticación

  String? email, password;

  final FocusNode _currentFocusNode = FocusNode();
  final FocusNode _nextFocusNode = FocusNode();

  String? error;

  @override
  void initState() {
    _authService = getIt.get<AuthService>();

    if (kDebugMode) {
      // email = "desarrollador@grupoformarte.edu.co";
      // email = "millerjeison@gmail.com";
      // password = "1128430148";
      email = "direccioncali@grupoformarte.edu.co";
      password = "43996311";
      // password = "123456789";
      // email = "testapp50@grupoformarte.edu.co";
      // password = "423456789";

      // email = "vanesaw@gmail.com";
      // password = "e4414910";

      // email = "coordinacionvirtual@grupoformarte.edu.co";
      // password = "1010221676";
      // email = "es.restrepo@grupoformarte.edu.co";
      // password = "1058199219";
      // password = "Edinson4414910!";
      // email = "millerjeison@gmail.com";
      // password = "1128430148";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 300,
                        height: 50,
                        // decoration: const BoxDecoration(
                        //   image: DecorationImage(
                        //     image: AssetImage('assets/LOGO2.png'),
                        //     // fit: BoxFit.cover,
                        //   ),
                        // ),
                        margin: const EdgeInsets.all(40),
                      ),
                      Container(
                        width: 168.0,
                        height: 164.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/lexi_v.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      RoundedTextField(
                        focusNode: _currentFocusNode,
                        hintText: 'Correo',
                        width: 70.w,
                        onChanged: (value) {
                          email = value;
                        },
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_nextFocusNode);
                        },
                      ),
                      RoundedTextField(
                        focusNode: _nextFocusNode,
                        hintText: 'Número de documento',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        width: 70.w,
                        onChanged: (value) {
                          password = value;
                        },
                        onSubmitted: (_) {
                          _submit();
                        },
                      ),
                    ],
                  ),
                  GradientButton(
                    text: 'Ingresar',
                    onPressed: _submit,
                  ),
                  InkWell(
                    onTap: _register,
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                  ),
                  if (error != null)
                    GestureDetector(
                      onTap: () async {
                        launchWhatsAppUri('+573183491375',
                            'El usuario con el correo: $email, tiene el siguiente error:$error');
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
                            style: TextStyle(color: Colors.redAccent[100]),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    context.router.pushNamed("/signUp");
  }

  void _submit() async {
    // try {
    final validLogin = LoginModel(email!, password!);
    final userProvider = context.read<DataUserProvider>();

    if (!validLogin.isValid()) {
      MotionToast.error(
              toastDuration: const Duration(seconds: 3),
              description: const Text("Faltan campos por llenar"))
          .show(context);
      return;
    }

    final response = await _authService!.execute(validLogin);

    // final permision = json.decode(response!.typeUser!);

    if (response == null) {
      MotionToast.error(
              toastDuration: const Duration(seconds: 3),
              description: const Text("Correo o contraseña incorrectos"))
          .show(context);
      return;
    }

    userProvider.userViewModel = response;

    if (!mounted) return;

    if (response.typeUser == 'student') {
      context.router.replaceNamed('/all_programs');
      return;
    }
// all_programs
    context.router.replaceNamed('/home');
  }
}
