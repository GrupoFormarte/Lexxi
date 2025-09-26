import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/pages/quiz/widgets/clickable_alert_widget.dart';

import 'audio_player_widget.dart';
import 'video_player_widget.dart';
import 'web_view_video_widget.dart';

class QuillRead extends StatefulWidget {
  final FleatherController controller;
  const QuillRead({
    super.key,
    required this.controller,
  });

  @override
  State<QuillRead> createState() => _QuillReadState();
}

class _QuillReadState extends State<QuillRead> {
  final FocusNode _focusNode = FocusNode();
  // Nodo de enfoque para el editor
  @override
  Widget build(BuildContext context) {
    final fleatherTheme = FleatherThemeData(
      bold: const TextStyle(
          fontWeight: FontWeight.bold, color: ColorPalette.white),
      italic: const TextStyle(
          fontStyle: FontStyle.italic, color: ColorPalette.white),
      underline: const TextStyle(
          decoration: TextDecoration.underline, color: ColorPalette.white),
      strikethrough: const TextStyle(
          decoration: TextDecoration.lineThrough, color: ColorPalette.white),
      link: const TextStyle(
          color: Colors.blueAccent, decoration: TextDecoration.underline),
      inlineCode: InlineCodeThemeData(
        style: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey[800],
          color: ColorPalette.white,
        ),
        radius: const Radius.circular(4),
      ),
      paragraph: TextBlockTheme(
        style: const TextStyle(color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 8, bottom: 0),
      ),
      heading1: TextBlockTheme(
        style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 24, bottom: 8),
      ),
      heading2: TextBlockTheme(
        style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 20, bottom: 6),
      ),
      heading3: TextBlockTheme(
        style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 18, bottom: 6),
      ),
      heading4: TextBlockTheme(
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 16, bottom: 6),
      ),
      heading5: TextBlockTheme(
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 14, bottom: 4),
      ),
      heading6: TextBlockTheme(
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 12, bottom: 4),
      ),
      lists: TextBlockTheme(
        style: const TextStyle(color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 8, bottom: 0),
      ),
      quote: TextBlockTheme(
        style: const TextStyle(
            color: ColorPalette.white, fontStyle: FontStyle.italic),
        spacing: const VerticalSpacing(top: 8, bottom: 8),
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white30, width: 4)),
        ),
      ),
      code: TextBlockTheme(
        style:
            const TextStyle(fontFamily: 'monospace', color: ColorPalette.white),
        spacing: const VerticalSpacing(top: 8, bottom: 8),
        decoration: BoxDecoration(color: Colors.grey[800]),
      ),
      horizontalRule: HorizontalRuleThemeData(
        height: 16.0, // Espaciado vertical total (altura del área)
        thickness: 1.0, // Grosor de la línea
        color: Colors.white54,
      ),
    );
    return FleatherTheme(
      data: fleatherTheme,
      child: FleatherField(
        controller: widget.controller,
        focusNode: _focusNode,
        showCursor:false,
        decoration: const InputDecoration(
            border: InputBorder.none, fillColor: ColorPalette.primary),
        readOnly: true,
        embedBuilder: _embedBuilder,
      ),
    );
  }

  @override
  void dispose() {
    // widget.controller.dispose();
    super.dispose();
  }

  Widget _embedBuilder(BuildContext context, EmbedNode node) {
    // Determinar el tipo de embed
    final type = node.value.type ?? node.value.data['_type'];

    late Widget embedWidget;

    if (type == 'image') {
      embedWidget = _buildImageEmbed(node.value.data);
    } else if (type == 'latex') {
      embedWidget = _buildLatexEmbed(node.value.data);
    } else if (type == 'video') {
      embedWidget = _buildVideoEmbed(node.value.data);
    } else if (type == 'video_link') {
      embedWidget = _buildVideoLinkEmbed(node.value.data);
    } else if (type == 'audio') {
      embedWidget = _buildAudioEmbed(node.value.data);
    } else {
      embedWidget = defaultFleatherEmbedBuilder(context, node);
    }
    return embedWidget;
  }

  Widget _buildImageEmbed(Map<String, dynamic> data) {
    ImageProvider? imageProvider;
    if (data['source_type'] == 'file' || data['source_type'] == 'url') {
      imageProvider = NetworkImage(data['source']);
    }

    if (imageProvider != null) {
      return InkWell(
        onTap: () {
          // Acción al tocar la imagen
        },
        child: Container(
          width: 500,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
      );
    } else {
      return const Text('Imagen no disponible');
    }
  }

  Widget _buildLatexEmbed(Map<String, dynamic> data) {
    return Center(
      child: Math.tex(
        data['latex'],
        // const TextStyle: const TextStyle(fontSize: 5.sp),
        mathStyle: MathStyle.display,
        options: MathOptions(color: Colors.white),
        onErrorFallback: (err) => Container(
          color: Colors.red,
          child: Text(err.messageWithType,
              style: const TextStyle(color: Colors.yellow)),
        ),
      ),
    );
  }

  Widget _buildVideoEmbed(Map<String, dynamic> data) {
    final source = data['source'];
    if (source != null && source is String && source.isNotEmpty) {
      return ClickableAlertWidget(
        child: VideoPlayerWidget(url: source),
      );
    } else {
      return const Text('Video no disponible');
    }
  }

  Widget _buildVideoLinkEmbed(Map<String, dynamic> data) {
    final url = data['source'];
    if (url != null && url is String && url.isNotEmpty) {
      return WebViewVideoWidget(url: url);
    } else {
      return const Text('Enlace de video no disponible');
    }
  }

  Widget _buildAudioEmbed(Map<String, dynamic> data) {
    final source = data['source'];
    final name = data['name'] ?? 'Audio';
    if (source != null && source is String && source.isNotEmpty) {
      return AudioPlayerWidget(
        audioData: source,
        fileName: name,
      );
    } else {
      return const Text('Audio no disponible');
    }
  }
}
