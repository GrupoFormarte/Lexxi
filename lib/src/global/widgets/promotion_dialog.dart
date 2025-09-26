import 'package:flutter/material.dart';
import 'package:lexxi/domain/promotion/model/promotion.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:video_player/video_player.dart';

Future<void> showPromotionDialog(
  BuildContext context, {
  required PromotionModel promotion,
  required VoidCallback onClik,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return Center(
        child: PromotionDialog(
          promotion: promotion,
          onClik: onClik,
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: child,
        ),
      );
    },
  );
}

class PromotionDialog extends StatefulWidget {
  final PromotionModel promotion;
  final VoidCallback onClik;

  const PromotionDialog({
    Key? key,
    required this.promotion,
    required this.onClik,
  }) : super(key: key);

  @override
  _PromotionDialogState createState() => _PromotionDialogState();
}

class _PromotionDialogState extends State<PromotionDialog> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.promotion.fileType == 'video' &&
        widget.promotion.fileUrl.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.promotion.fileUrl),
      )..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = width * (9 / 16);

    return AlertDialog(
      backgroundColor: AppColors.blueDark, // Fondo azul oscuro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        widget.promotion.title,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.promotion.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.promotion.description,
                  style: const TextStyle(color: AppColors.greyLight),
                ),
              ),
            if (widget.promotion.fileType == 'image' &&
                widget.promotion.fileUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.promotion.fileUrl,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            if (widget.promotion.fileType == 'video' &&
                _controller != null &&
                _controller!.value.isInitialized)
              SizedBox(
                width: width,
                height: height,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            if (widget.promotion.fileType == 'none')
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'No hay contenido multimedia disponible.',
                  style: TextStyle(color: AppColors.greyLight),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.gradientAction, // Gradiente del botón
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: widget.onClik,
            child: Text(
              widget.promotion.buttonText,
              style: const TextStyle(
                color: AppColors.blueDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}