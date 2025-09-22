// Cupertino import not needed; Material covers everything used here
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:womensafteyhackfair/constants.dart';

class SafeWebView extends StatefulWidget {
  final String url;
  final String title;
  final int index;
  const SafeWebView({Key? key, required this.url, required this.title, required this.index})
      : super(key: key);

  @override
  State<SafeWebView> createState() => _SafeWebViewState();
}

class _SafeWebViewState extends State<SafeWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(imageSliders[widget.index]),
            ),
          )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
