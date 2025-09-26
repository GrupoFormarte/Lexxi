import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage() // Add this annotation to your routable pages
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthService _authService = getIt.get<AuthService>();
  bool _navigated = false; // bandera para que solo se ejecute una vez

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_navigated) return; // Evita ejecutar esto más de una vez
    _navigated = true;
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // try {
    // } catch (e) {
    // }
    await Future.delayed(const Duration(seconds: 1)); // simulación de carga
    User? dataUser;
    try {
      dataUser = await _authService.getUserLocal();
    } on Exception catch (e) {
      dataUser = null;
    }
    if (!mounted) return;
    if (dataUser == null) {
      context.router.replaceNamed('/login');
    } else if (dataUser.typeUser == 'student') {
      context.router.replaceNamed('/all_programs');
    } else {
      final userProvider = context.read<DataUserProvider>();
      userProvider.userViewModel = dataUser;
      context.router.replaceNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: SizedBox(
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 200, height: 50),
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo_lexxi.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: 200,
              height: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/lexxi.png'),
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
