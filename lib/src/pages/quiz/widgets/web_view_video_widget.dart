import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewVideoWidget extends StatefulWidget {
  final String url;

  const WebViewVideoWidget({required this.url, super.key});

  @override
  _WebViewVideoWidgetState createState() => _WebViewVideoWidgetState();
}

class _WebViewVideoWidgetState extends State<WebViewVideoWidget> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 900,
      
      child: WebViewWidget(controller: _controller));
  }
}