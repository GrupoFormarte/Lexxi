import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class DualTimerDisplayBlurred extends StatefulWidget {
  final String baseTimeFormatted; // Ej: "2:25"
  final int index;
  final void Function(int elapsedSeconds)? onTick;

  const DualTimerDisplayBlurred({
    Key? key,
    required this.baseTimeFormatted,
    required this.index,
    this.onTick,
  }) : super(key: key);

  @override
  State<DualTimerDisplayBlurred> createState() =>
      _DualTimerDisplayBlurredState();
}

class _DualTimerDisplayBlurredState extends State<DualTimerDisplayBlurred> {
  late int targetSeconds;
  int elapsedSeconds = 0;
  late Timer _timer;

  int _parseTimeToSeconds(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    return (minutes * 60 + seconds);
  }

  @override
  void initState() {
    super.initState();
    final baseTimeInSeconds = _parseTimeToSeconds(widget.baseTimeFormatted);
    targetSeconds = baseTimeInSeconds * widget.index;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsedSeconds++;
      });

      // Emitir el tiempo transcurrido si se asignó un callback
      if (widget.onTick != null) {
        widget.onTick!(elapsedSeconds);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final bool isExceeded = elapsedSeconds > targetSeconds;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 40,
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              // Cronómetro en tiempo real
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isExceeded
                        ? Colors.redAccent.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    formatTime(elapsedSeconds),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: isExceeded ? Colors.redAccent : Colors.white,
                    ),
                  ),
                ),
              ),
              // Tiempo objetivo
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    formatTime(targetSeconds),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: ColorPalette.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
