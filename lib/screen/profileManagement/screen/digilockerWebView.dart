// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class DigilockerWebView extends StatefulWidget {
//   final String url;
//
//   const DigilockerWebView({super.key, required this.url});
//
//   @override
//   State<DigilockerWebView> createState() => _DigilockerWebViewState();
// }
//
// class _DigilockerWebViewState extends State<DigilockerWebView> {
//   late final WebViewController controller;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (_) => setState(() => isLoading = true),
//           onPageFinished: (url) {
//             setState(() => isLoading = false);
//             print("ResultDIGILOCKER: $url");
//             // 🔥 Detect success / redirect
//             if (url.contains("success") || url.contains("status=completed")) {
//               final uri = Uri.parse(url);
//               final clientId = uri.queryParameters['client_id'];
//               Navigator.pop(context, clientId);
//               print("clientId: $clientId");
//             }
//             if (url.contains("failure") || url.contains("error")) {
//               Navigator.pop(context, false);
//             }
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Aadhaar Verification")),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: controller),
//           if (isLoading) const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigilockerWebView extends StatefulWidget {

  final String url;

  const DigilockerWebView({
    super.key,
    required this.url,
  });

  @override
  State<DigilockerWebView> createState() =>
      _DigilockerWebViewState();
}

class _DigilockerWebViewState
    extends State<DigilockerWebView> {

  late final WebViewController controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()

      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )

      ..setNavigationDelegate(

        NavigationDelegate(

          onPageStarted: (_) {
            setState(() {
              isLoading = true;
            });
          },

          onPageFinished: (url) {

            setState(() {
              isLoading = false;
            });

            debugPrint("Current URL => $url");

            /// 🔥 SUCCESS

            if (url.contains("success") ||
                url.contains("completed")) {

              Navigator.pop(context, true);
            }

            /// 🔥 FAILURE

            if (url.contains("failure") ||
                url.contains("error")) {

              Navigator.pop(context, false);
            }
          },
        ),
      )

      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Aadhaar Verification",
        ),
      ),

      body: Stack(
        children: [

          WebViewWidget(
            controller: controller,
          ),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}