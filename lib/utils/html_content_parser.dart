import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';


class HtmlContentParser {
  final TextStyle defaultStyle;

  HtmlContentParser({TextStyle? style})
      : defaultStyle = style ?? const TextStyle();

  List<InlineSpan> parseHtmlToInlineSpans(
      String htmlContent, BuildContext context,
      {TextStyle? style}) {
    var document = html_parser.parse(htmlContent);

    return _buildInlineSpansFromHtml(document.body!, context,
        style: style ?? defaultStyle);
  }

  List<InlineSpan> _buildInlineSpansFromHtml(
      dom.Element element, BuildContext context,
      {TextStyle? style}) {
    RegExp pattern = RegExp(r'S\d+-[A-Z]+-\d+(-[IVXLCDM]+)?-[A-Z]+\d+');

    List<InlineSpan> spans = [];
    String text = ""; // Almacena el texto acumulado aquí

    for (var node in element.nodes) {
      if (node is dom.Element) {
        // Cuando encuentres un elemento especial (como una imagen), procesa el texto acumulado primero
        if (text.isNotEmpty) {
          spans.add(TextSpan(text: text, style: style));

          text = ""; // Restablece el acumulador de texto
        }

        switch (node.localName) {
          case 'img':
            spans.add(_buildImageSpan(node, context));
            break;
          case 'math':
            spans.add(_buildMathSpan(node, style));
            break;
          default:
            spans
                .addAll(_buildInlineSpansFromHtml(node, context, style: style));
            break;
        }
      } else if (node is dom.Text) {
        // Verifica si el texto del nodo contiene el patrón
        if (!pattern.hasMatch(node.text)) {
          // Acumula texto aquí
          // print([node,text,node is dom.Element]);

          text += "${_processText(node.text)} ";
        }
      }
    }

    // Después de salir del bucle, asegúrate de añadir cualquier texto restante
    if (text.isNotEmpty) {
      spans.add(TextSpan(text: text, style: style));
    }

    return spans;
  }

  InlineSpan _buildImageSpan(
    dom.Element imgNode,
    BuildContext context,
  ) {
    String? src = imgNode.attributes['src'];
    final token = generateToken(16);
    final imageProvider = src!.startsWith('data:image')
        ? MemoryImage(base64.decode(src.split(',')[1]))
        : NetworkImage(src) as ImageProvider<Object>;

    Widget viewImage = Positioned(
      bottom: 5,
      right: 5,
      child: GestureDetector(
        onTap: () {
          // Cuando se toca el icono de zoom, se muestra la imagen en una pantalla con zoom
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: Hero(
                tag: token,
                child: Container(
                  child: PhotoView(
                    imageProvider: imageProvider,
                  ),
                ),
              ),
            ),
          ));
        },
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: const Icon(Icons.zoom_in, color: AppColors.green, size: 30),
        ),
      ),
    );
    if (src.startsWith('data:image')) {
      Uint8List bytes = base64.decode(src.split(',')[1]);
      return WidgetSpan(
        child: Stack(
          children: [
            Hero(
              tag: token,
              child: SizedBox(
                width: 100.w,
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            viewImage
          ],
        ),
      );
    } else {
      return WidgetSpan(
        child: Stack(
          children: [
            Hero(
              tag: token,
              child: SizedBox(
                width: 100.w,
                child: Image.network(
                  src,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            viewImage
          ],
        ),
      );
    }
    return const TextSpan(text: '');
  }

  String generateToken(int length) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final rand = Random.secure();
    return List.generate(length, (_) => charset[rand.nextInt(charset.length)])
        .join();
  }

// Ejemplo de uso:

  InlineSpan _buildMathSpan(dom.Element mathNode, TextStyle? style) {
    String latex = _convertMathMLToLatex2(mathNode.outerHtml);
    return WidgetSpan(
      child: TeXView(
        child: TeXViewDocument(latex),
        style: const TeXViewStyle(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  String _processText(String text) {
    // Asegúrate de que hay un espacio después de los puntos.
    String processedText = text.replaceAll(RegExp(r'\.([A-Za-z])'), '. \$1');
    // Asegúrate de que no hayan espacios antes de los puntos y comas.
    processedText = processedText.replaceAll(RegExp(r'\s+\.'), '.');
    processedText = processedText.replaceAll(RegExp(r'\s+\,'), ',');
    // Elimina espacios extra entre palabras.
    processedText = processedText.replaceAll(RegExp(r'\s+'), ' ');
    // Reemplaza los saltos de línea correctos después de los puntos.
    // processedText = processedText.replaceAll('. ', '.\n');
    return processedText.trim();
  }

  String convertElement(dom.Node node) {
    if (node is dom.Element) {
      switch (node.localName) {
        case 'mn': // Números
          return node.text;
        case 'mo': // Operadores
          return ' ${node.text.trim()} ';
        case 'mi': // Identificadores (como variables)
          return node.text;
        case 'mfenced': // Agrupación con paréntesis
          return '\\left( ${convertChildrenToLatex(node)} \\right)';
        case 'mfrac': // Fracciones
          var fracChildren = node.children;
          if (fracChildren.length != 2) return '';
          return '\\frac{${convertElement(fracChildren[0])}}{${convertElement(fracChildren[1])}}';
        case 'msqrt': // Raíz cuadrada
          return '\\sqrt{${convertChildrenToLatex(node)}}';
        case 'msup': // Superíndice
          var supChildren = node.children;
          if (supChildren.length != 2) return '';
          return '{${convertElement(supChildren[0])}}^{${convertElement(supChildren[1])}}';
        case 'msub': // Subíndice
          var subChildren = node.children;
          if (subChildren.length != 2) return '';
          return '{${convertElement(subChildren[0])}}_{${convertElement(subChildren[1])}}';
        case 'mover': // Sobreescrito
          var overChildren = node.children;
          if (overChildren.length != 2) return '';
          return '{${convertElement(overChildren[0])}}\\overline{${convertElement(overChildren[1])}}';
        case 'munder': // Subrayado
          var underChildren = node.children;
          if (underChildren.length != 2) return '';
          return '{${convertElement(underChildren[0])}}\\underline{${convertElement(underChildren[1])}}';
        case 'mrow': // Agrupación de elementos
          return convertChildrenToLatex(node);
        case 'mtext': // Texto
          return '\\text{${node.text}}';
        case 'mtable': // Tablas o matrices
          return '\\begin{matrix}${convertChildrenToLatex(node)}\\end{matrix}';
        case 'mtr': // Filas de una matriz
          return '${convertChildrenToLatex(node)}\\\\'; // Doble backslash para nueva línea en LaTeX
        case 'mtd': // Elemento de una fila en una matriz
          return '${convertElement(node.firstChild!)}&'; // Ampersand para separar elementos en LaTeX
        case 'msum': // Sumatoria
          var sumChildren = node.children;
          return '\\sum_{${convertElement(sumChildren[0])}}^{${convertElement(sumChildren[1])}}{ ${convertElement(sumChildren[2])} }';
        case 'mint': // Integral
          var intChildren = node.children;
          return '\\int_{${convertElement(intChildren[0])}}^{${convertElement(intChildren[1])}}{ ${convertElement(intChildren[2])} }\\,dx';
        case 'mlim': // Límites
          var limChildren = node.children;
          return '\\lim_{${convertElement(limChildren[0])}\\to ${convertElement(limChildren[1])}}{ ${convertElement(limChildren[2])} }';
        case 'mvector': // Vectores
          return '\\begin{bmatrix}${convertChildrenToLatex(node)}\\end{bmatrix}';
        case 'mintegral': // Integral indefinida
          return '\\int {${convertChildrenToLatex(node)}}\\,dx';
        case 'msummary': // Notación de series
          return '\\sum {${convertChildrenToLatex(node)}}';
        case 'mproduct': // Productos
          return '\\prod {${convertChildrenToLatex(node)}}';
        case 'munion': // Unión
          return '\\bigcup {${convertChildrenToLatex(node)}}';
        case 'mintersect': // Intersección
          return '\\bigcap {${convertChildrenToLatex(node)}}';
        case 'minfinity': // Infinito
          return '\\infty';
        case 'mstyle': // Estilos matemáticos
          return '{${convertChildrenToLatex(node)}}'; // Ajusta para aplicar estilos específicos si es necesario
        case 'mspace': // Espacios
          // Puedes ajustar el espacio basado en los atributos, por ejemplo 'width'
          return '\\,';
        case 'mroot': // Raíz enésima
          var rootChildren = node.children;
          if (rootChildren.length != 2) return '';
          return '\\sqrt[${convertElement(rootChildren[1])}]{${convertElement(rootChildren[0])}}';
        case 'maction': // Interactividad, ignorado en LaTeX
          return convertChildrenToLatex(node);
        case 'merror': // Error, normalmente no se representa
          return '\\text{Error}';
        case 'mpadded': // Espaciado ajustado, ignorado en LaTeX
          return convertChildrenToLatex(node);
        case 'mphantom': // Elementos invisibles
          return '\\phantom{${convertChildrenToLatex(node)}}';
        case 'mmultiscripts': // Scripts pre y post, como en tensores
          // La implementación detallada dependerá de cómo esté estructurado tu MathML
          return convertChildrenToLatex(node);
        // ... y así sucesivamente para otros nodos que puedas necesitar ...
        // case 'mspace': // Espacios y saltos de línea
        //   if (node.attributes['linebreak'] == 'newline') {
        //     return '\\\\'; // Salto de línea en LaTeX
        //   }
        //   return ' '; // Espacio regular si no es un salto de línea
        // Agrega aquí más casos para otros tipos de elementos MathML
        default:
          return convertChildrenToLatex(node);
      }
    } else if (node is dom.Text) {
      return node.text;
    }
    return '';
  }

  String convertChildren(dom.Element element) {
    return element.children.map(convertElement).join('');
  }

  // ---

  // Implementación de la conversión de MathML a LaTeX
  String _convertMathMLToLatex2(String mathml) {
    var document = html_parser.parse(mathml);
    var mathElement = document.querySelector('math');
    if (mathElement == null) return '';
    return convertElement(mathElement);
  }

  String convertMathMLElementToLatex(dom.Node node) {
    if (node is dom.Element) {
      String latex = '';
      for (var child in node.nodes) {
        // Usar 'nodes' en lugar de 'children' para incluir nodos de texto
        latex += convertElement(child);
      }
      return latex;
    } else if (node is dom.Text) {
      return node.text;
    }
    return '';
  }

  String convertChildrenToLatex(dom.Element element) {
    return element.children.map((child) => convertElement(child)).join('');
  }

  String convertSubscriptToLatex(dom.Element element) {
    return '_{${element.children.map(convertMathMLElementToLatex).join()}}';
  }

  String convertSuperscriptToLatex(dom.Element element) {
    return '^{${element.children.map(convertMathMLElementToLatex).join()}}';
  }

  String convertMathMLToLatex(String htmlContent) {
    var document = html_parser.parse(htmlContent);
    var mathElements = document.getElementsByTagName('math');

    if (mathElements.isNotEmpty) {
      return convertMathMLElementToLatex(mathElements.first);
    }
    return '';
  }

  parseHtmlToWidgets(String resptextov, {required TextStyle style2}) {}
}
