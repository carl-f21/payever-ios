import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_event.dart';

class CheckoutFlowWebView extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final String checkoutUrl;
  CheckoutFlowWebView({this.checkoutScreenBloc, this.checkoutUrl});
  @override
  _CheckoutFlowState createState() => _CheckoutFlowState();
}

class _CheckoutFlowState extends State<CheckoutFlowWebView> {
  double progress = 0;
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(0.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()
          ),
          Expanded(
            child: InAppWebView(
              initialUrl: widget.checkoutUrl,
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                  widget.checkoutScreenBloc.add(GetOpenUrlEvent(url));
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                  widget.checkoutScreenBloc.add(GetOpenUrlEvent(url));
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
