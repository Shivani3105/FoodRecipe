import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:url_launcher/url_launcher.dart'; // for opening link on web
import 'package:webview_flutter/webview_flutter.dart'; // for mobile platforms

class RecipeView extends StatefulWidget {
  final String url;

  const RecipeView(this.url, {super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String finalUrl;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Convert 'http' to 'https' if needed
    if (widget.url.contains('http://')) {
      finalUrl = widget.url.replaceAll('http://', 'https://');
    } else {
      finalUrl = widget.url;
    }

    if (kIsWeb) {
      // Launch URL in external browser for web
      WidgetsBinding.instance.addPostFrameCallback((_) {
        launchUrl(
          Uri.parse(finalUrl),
          mode: LaunchMode.externalApplication,
        );
      });
    } else {
      // Setup WebViewController for mobile
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(finalUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Food Recipe App'),
      ),
      body: kIsWeb
          ? const Center(
              child: Text("Opening recipe in a new tab..."),
            )
          : WebViewWidget(controller: _controller),
    );
  }
}
