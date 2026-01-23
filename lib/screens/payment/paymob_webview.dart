import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymobWebView extends StatefulWidget {
  final String paymentToken;
  final String iframeId;
  final VoidCallback onPaymentSuccess;

  const PaymobWebView({
    super.key,
    required this.paymentToken,
    required this.iframeId,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymobWebView> createState() => _PaymobWebViewState();
}

class _PaymobWebViewState extends State<PaymobWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final String url =
        "https://accept.paymob.com/api/acceptance/iframes/${widget.iframeId}?payment_token=${widget.paymentToken}";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // Check for success keywords in redirect URL
            if (url.contains("success=true") ||
                url.contains("txn_response_code=00")) {
              widget.onPaymentSuccess();
              Navigator.pop(context);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
