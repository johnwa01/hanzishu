import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// WebView class's functionalities are replaced by WebViewController and WebViewWidget
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//import 'package:webview_flutter_module/constants/text_constants.dart';

class WebViewPage extends StatefulWidget {
  final String webUrl;
  final String parentPageName;
  WebViewPage(this.webUrl, this.parentPageName) ;
  //const WebViewScreen({Key? key}) : super(key: key);
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  //final Completer <WebViewController> _controller =
  //    Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
  //TODO:    WebView.platform = SurfaceAndroidWebView();
    }
    //controller = WebViewController()
    //  ..loadRequest(
    //    Uri.parse('https://flutter.dev'),
    //  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.parentPageName),
      ),
      body: SizedBox(width:30.0, height: 30.0),
      //TODO
      //body: WebView(
      //  initialUrl: widget.webUrl, //'https://flutter.dev',
      //),
    );
  }
}