import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


class AstronautScreen extends StatefulWidget {
  const AstronautScreen({super.key});

  @override
  _AstronautScreenState createState() => _AstronautScreenState();
}

class _AstronautScreenState extends State<AstronautScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller; // Controlador para la animación general
  late AnimationController _twinkleController; // Controlador para el parpadeo de estrellas
  late Animation<double> _animation; // Animación para la posición del astronauta
  late double screenWidth;
  List<Star> stars = [];
  List<ShootingStar> shootingStars = [];
  Timer? shootingStarTimer;

  @override
  void initState() {
    super.initState();

    // Iniciar el AnimationController para la animación general
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Iniciar el AnimationController para el parpadeo de estrellas con mayor duración
    _twinkleController = AnimationController(
      duration: const Duration(seconds: 6), // Aumentamos la duración para parpadeo más suave
      vsync: this,
    )..repeat();

    // Definir la animación de posición horizontal del astronauta
    _animation = Tween<double>(begin: -100, end: 1000).animate(_controller);

    // Generar estrellas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateStars();
    });

    // Iniciar el timer para crear estrellas fugaces aleatoriamente cada 5 segundos
    shootingStarTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _createShootingStar();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _twinkleController.dispose();
    shootingStarTimer?.cancel();
    super.dispose();
  }

  // Generar estrellas con posiciones y factores de parpadeo aleatorios
  void _generateStars() {
    final size = MediaQuery.of(context).size;
    final Random random = Random();
    setState(() {
      stars = List.generate(150, (index) {
        return Star(
          position: Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          ),
          radius: random.nextDouble() * 1.5 + 0.5, // Tamaño aleatorio
          twinkleFactor: random.nextDouble() * 2 * pi, // Factor aleatorio para parpadeo
        );
      });
    });
  }

  // Crear una estrella fugaz
  void _createShootingStar() {
    final size = MediaQuery.of(context).size;
    final Random random = Random();
    double startX = random.nextDouble() * size.width * 0.8; // Iniciar en el 80% izquierdo
    double startY = random.nextDouble() * size.height * 0.5; // Iniciar en la mitad superior
    double speed = 300 + random.nextDouble() * 200; // Velocidad entre 300 y 500
    double angle = pi / 4; // 45 grados hacia abajo

    setState(() {
      shootingStars.add(ShootingStar(
        position: Offset(startX, startY),
        speed: speed,
        angle: angle,
        length: 100 + random.nextDouble() * 50, // Longitud del rastro
        color: Colors.white.withOpacity(0.8),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double xPosition = (_animation.value % (screenWidth + 200)) - 100;
          double yPosition = size.height / 2 +
              sin(_animation.value / 50) * 100; // Movimiento vertical sinusoidal

          // Actualizar las estrellas fugaces
          const deltaTime = 1 / 60; // Asumiendo 60 FPS
          for (var shootingStar in shootingStars) {
            shootingStar.update(deltaTime);
          }

          // Eliminar estrellas fugaces que han salido de la pantalla
          shootingStars.removeWhere((shootingStar) =>
              shootingStar.position.dx > size.width ||
              shootingStar.position.dy > size.height);

          return Stack(
            children: [
              // Fondo del cielo estrellado
              CustomPaint(
                size: size,
                painter:
                    StarrySkyPainter(stars, _twinkleController, shootingStars),
              ),
              // Astronauta flotando
              Positioned(
                left: xPosition,
                top: yPosition,
                child: Transform.rotate(
                  angle: sin(_animation.value / 30) / 5, // Pequeña rotación para efecto de flotación
                  child: Image.asset(
                    'assets/astronauta.png',
                    width: 80,
                    height: 120,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Clase para representar una estrella
class Star {
  final Offset position;
  final double radius;
  final double twinkleFactor;

  Star({
    required this.position,
    required this.radius,
    required this.twinkleFactor,
  });
}

// Clase para representar una estrella fugaz
class ShootingStar {
  Offset position;
  final double speed;
  final double angle;
  final double length;
  final Color color;

  ShootingStar({
    required this.position,
    required this.speed,
    required this.angle,
    required this.length,
    required this.color,
  });

  // Actualiza la posición de la estrella fugaz
  void update(double deltaTime) {
    final dx = speed * cos(angle) * deltaTime;
    final dy = speed * sin(angle) * deltaTime;
    position = Offset(position.dx + dx, position.dy + dy);
  }
}

// Pintor para el cielo estrellado
class StarrySkyPainter extends CustomPainter {
  final List<Star> stars;
  final Animation<double> twinkleAnimation;
  final List<ShootingStar> shootingStars;

  StarrySkyPainter(
      this.stars, this.twinkleAnimation, this.shootingStars)
      : super(repaint: twinkleAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Dibujar las estrellas
    for (final star in stars) {
      // Calcular la opacidad para el parpadeo más suave
      double opacity = 0.5 +
          0.5 *
              sin(twinkleAnimation.value * 2 * pi / 6 + star.twinkleFactor);
      // Ajustamos el denominador de 6 para una frecuencia más baja (parpadeo más suave)
      paint.color = Colors.white.withOpacity(opacity.clamp(0.0, 1.0));

      canvas.drawCircle(star.position, star.radius, paint);
    }

    // Dibujar las estrellas fugaces
    for (final shootingStar in shootingStars) {
      paint.color = shootingStar.color;
      paint.strokeWidth = 2.0;
      paint.strokeCap = StrokeCap.round;

      // Calcular el punto final del rastro
      final endX =
          shootingStar.position.dx - shootingStar.length * cos(shootingStar.angle);
      final endY =
          shootingStar.position.dy - shootingStar.length * sin(shootingStar.angle);
      final endPosition = Offset(endX, endY);

      canvas.drawLine(shootingStar.position, endPosition, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarrySkyPainter oldDelegate) {
    return true;
  }
}