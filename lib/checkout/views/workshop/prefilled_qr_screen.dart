import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/theme.dart';

// ignore: must_be_immutable
class PrefilledQRCodeScreen extends StatefulWidget {
  final String title;
  final dynamic qrForm;
  final dynamic qrImage;
  PrefilledQRCodeScreen({this.title, this.qrForm, this.qrImage,});

  _PrefilledQRCodeScreenState createState() => _PrefilledQRCodeScreenState();
}

class _PrefilledQRCodeScreenState extends State<PrefilledQRCodeScreen> {
  bool isOpened = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Center(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {           
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody() {
    dynamic response = widget.qrForm;
    List<Widget> widgets = [];
    widgets.add(
      Container(
        height: 64,
        color: overlayBackground(),
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              setState(() {
                isOpened = !isOpened;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/qr-code.svg',
                      height: 20,
                      width: 20,
                      color: iconColor(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text(
                      Language.getPosTpmStrings('tpm.communications.qr.title'),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                Icon(
                  isOpened ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (response != null) {
      if (response is Map) {
        dynamic form = response['form'];
        String contentType = form['contentType'] != null ? form['contentType'] : '';
        dynamic content = form['content'] != null ? form['content']: null;
        if (content != null) {
          dynamic data = content[contentType][0];
          if (data['data'] != null) {
            List<dynamic> list = data['data'];
            for(dynamic w in list) {
              if (w[0]['type'] == 'image') {
                Widget imageWidget = widget.qrImage != null ? (isOpened ? Container(
                    height: 300,
                    color: Colors.white,
                    child:  Image.memory(widget.qrImage, fit: BoxFit.fitHeight,)):Container()
                ): Container();
                widgets.add(imageWidget);
              } else if (w[0]['type'] == 'text') {
                Widget textWidget = isOpened ? Container(
                  height: 64,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Language.getPosTpmStrings(w[0]['value']),
                      ),
                      MaterialButton(
                        minWidth: 0,
                        onPressed: () {
                        },
                        height: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        color: overlayBackground(),
                        child: Text(
                          Language.getPosTpmStrings(w[1]['text']),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ): Container();
                if (isOpened) widgets.add(Divider(height: 0, color: Colors.grey, thickness: 0.5,));
                widgets.add(textWidget);
              }
            }
          }
        }
      }
    }

    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgets.map((e) => e).toList(),
            ),
          ),
        ),
      ),
    );
  }
}