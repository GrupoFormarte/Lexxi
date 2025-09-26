import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoAlertDialog extends StatefulWidget {
  final String videoUrl; // URL o ruta local del video
  final VoidCallback onButtonPressed;
  final bool urlLocal;

  const VideoAlertDialog({
    Key? key,
    required this.videoUrl,
    required this.onButtonPressed,
    this.urlLocal = true,
  }) : super(key: key);

  @override
  _VideoAlertDialogState createState() => _VideoAlertDialogState();
}

class _VideoAlertDialogState extends State<VideoAlertDialog> {
  late VideoPlayerController _videoController;
  bool _isVideoCompleted = false;
  int _counter = 5; // Duración del contador en segundos
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (widget.urlLocal) {
        _videoController = VideoPlayerController.asset(widget.videoUrl);
      } else {
        _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      }

      await _videoController.initialize();
      setState(() {});
      _videoController.play();

      _videoController.addListener(() {
        if (_videoController.value.hasError) {
          print('Error en el video: ${_videoController.value.errorDescription}');
          // Opcional: Puedes mostrar un mensaje de error al usuario aquí
        }

        if (_videoController.value.position >= _videoController.value.duration &&
            !_videoController.value.isPlaying) {
          setState(() {
            _isVideoCompleted = true;
          });
          _startCounter();
        }
      });
    } catch (e) {
      print('Error al inicializar el video: $e');
      // Opcional: Muestra un diálogo de error o realiza otra acción
    }
  }

  void _startCounter() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        _timer?.cancel();
        widget.onButtonPressed();
        // Navigator.of(context).pop(); // Asegúrate de cerrar el diálogo
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Video Player
          AspectRatio(
            aspectRatio: _videoController.value.isInitialized
                ? _videoController.value.aspectRatio
                : 16 / 9,
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : const Center(child: CircularProgressIndicator()),
          ),
          // Espacio entre el video y el botón
          const SizedBox(height: 20),
          // Botón con contador que aparece al finalizar el video
          if (_isVideoCompleted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _counter > 0
                    ? null
                    : () {
                        widget.onButtonPressed();
                        Navigator.of(context).pop();
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _counter > 0
                    ? Text('Continuar en $_counter segundos')
                    : const Text('Continuar'),
              ),
            ),
        ],
      ),
    );
  }
}