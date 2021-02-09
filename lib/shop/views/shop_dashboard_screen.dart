import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';

class ShopDashboardScreen extends StatefulWidget {

  final ShopDetailModel activeShop;
  const ShopDashboardScreen(this.activeShop);

  @override
  _ShopDashboardScreenState createState() => _ShopDashboardScreenState(activeShop);
}

class _ShopDashboardScreenState extends State<ShopDashboardScreen> {

  final ShopDetailModel activeShop;
  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  _ShopDashboardScreenState(this.activeShop);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar('Your shop'),
        body: _body());
  }

  Widget _body() {
    if (activeShop == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          // _toolbar(),
          Container(
              padding: EdgeInsets.all(0.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()
          ),
          Expanded(
            child: InAppWebView(
              initialUrl: 'https://${activeShop.accessConfig.internalDomain}.new.payever.shop',
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
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                setState(() {
                  this.url = url;
                });
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

  Widget _toolbar() {
    return Container(
      height: 50,
      color: Color(0xFF222222),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'Your Shop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  if (activeShop != null) {
                    _launchURL('https://${activeShop.accessConfig.internalDomain}.new.payever.shop');
                  }
                },
                height: 32,
                color: overlayBackground().withOpacity(1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 8),
              // ),
              // PopupMenuButton<OverflowMenuItem>(
              //   child: Material(
              //     color: overlayBackground().withOpacity(1),
              //     shape: CircleBorder(),
              //     child: Icon(
              //       Icons.more_horiz,
              //       size: 32,
              //     ),
              //   ),
              //   offset: Offset(0, 100),
              //   onSelected: (OverflowMenuItem item) => item.onTap(),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   color: overlayBackground().withOpacity(1),
              //   itemBuilder: (BuildContext context) {
              //     return dashboardPopup(context, state)
              //         .map((OverflowMenuItem item) {
              //       return PopupMenuItem<OverflowMenuItem>(
              //         value: item,
              //         child: Text(
              //           item.title,
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w300,
              //           ),
              //         ),
              //       );
              //     }).toList();
              //   },
              // ),
              Padding(
                padding: EdgeInsets.only(right: 16),
              )
            ],
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // List<OverflowMenuItem> dashboardPopup(BuildContext context, ShopScreenState state) {
  //   return [
  //     OverflowMenuItem(
  //       title: 'Edit',
  //       onTap: () async {
  //       },
  //     ),
  //   ];
  // }
}

