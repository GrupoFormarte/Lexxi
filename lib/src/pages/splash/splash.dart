import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthService _authService = getIt.get<AuthService>();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!_navigated) {
        _navigated = true;
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    User? dataUser;

    try {
      dataUser = await _authService.getUserLocal();
    } catch (_) {
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
        height: 100.h,
        child: Center(
          child: Lottie.asset(
            'assets/json/login.json',
            width: 250,
            repeat: true,
          ),
        ),
      ),
    );
  }
}