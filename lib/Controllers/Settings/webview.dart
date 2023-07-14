// // ignore: must_be_immutable
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
//
// class InfoScreen extends StatelessWidget {
//   String? title, content;
//   static const String route = '/InfoScreen';
//   late BuildContext _buildContext;
//   var tempText =
//       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ";
//
//   InfoScreen({this.title, this.content});
//
//   @override
//   Widget build(BuildContext context) {
//     _buildContext = context;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//     return Container(
//       child: Scaffold(
//         // backgroundColor: primaryColor,
//         appBar: appBar(title: title),
//         body: body(),
//       ),
//     );
//   }
//
//   PreferredSizeWidget appBar({String? title = "WebView"}) {
//     return AppBar(
//       title: Text(title!),
//       centerTitle: false,
//       titleSpacing: 0,
//       // backgroundColor: Color(0x1a59a8a6),
//       elevation: 0,
//     );
//   }
//
//   Widget body() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 15),
//       child: WebViewExample(url: content,),
//     );
//   }
// }
//
// class WebViewExample extends StatefulWidget {
//   String? url = "https://flutter.dev";
//
//   WebViewExample({this.url});
//   @override
//   WebViewExampleState createState() => WebViewExampleState();
// }
//
// class WebViewExampleState extends State<WebViewExample> {
//   @override
//   void initState() {
//     super.initState();
//     // Enable virtual display.
//
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: WebView(
//         initialUrl: widget.url,
//       ),
//     );
//   }
// }
