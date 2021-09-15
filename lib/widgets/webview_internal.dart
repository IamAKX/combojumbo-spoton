import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewInternal extends StatefulWidget {
  const WebviewInternal({Key? key, required this.url}) : super(key: key);
  final String url;
  static const String WEBVIEW_ROUTE = '/webview';

  @override
  _WebviewInternalState createState() => _WebviewInternalState();
}

class _WebviewInternalState extends State<WebviewInternal> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: '${widget.url}',
          allowsInlineMediaPlayback: true,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
