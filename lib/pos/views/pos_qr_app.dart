import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class PosQRAppScreen extends StatefulWidget {

  final PosScreenBloc screenBloc;
  final String businessId;
  final String businessName;
  final bool fromProductsScreen;

  PosQRAppScreen({
    this.screenBloc,
    this.businessId,
    this.businessName,
    this.fromProductsScreen = false,
  });

  @override
  createState() => _PosQRAppScreenState();
}

class _PosQRAppScreenState extends State<PosQRAppScreen> {

  bool isOpened = true;

  @override
  void initState() {
    if (widget.fromProductsScreen) {
      widget.screenBloc.add(RestoreQrCodeEvent());
    } else {
      widget.screenBloc.add(
        GenerateQRCodeEvent(
          businessId: widget.businessId,
          businessName: widget.businessName,
          avatarUrl: '$imageBase${widget.screenBloc.state.activeTerminal.logo}',
          id: widget.screenBloc.state.activeTerminal.id,
          url: '${Env.checkout}/pay/create-flow-from-qr/channel-set-id/${widget.screenBloc.state.activeTerminal.channelSet}',
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(PosScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: Appbar(Language.getPosTpmStrings('tpm.communications.qr.title')),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: <Widget>[
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    dynamic response = state.qrForm;
    List<Widget> widgets = [];
    widgets.add(
      Container(
        height: 64,
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
                Widget imageWidget = isOpened ? Container(
                    height: 300,
                    color: Colors.white,
                    child: state.qrImage != null ? Image.memory(state.qrImage, fit: BoxFit.fitHeight,) :Container()
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
                widgets.add(textWidget);
              }
            }
          }
        }
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: isOpened ? 300.0 + 64.0 * 3.0: 64.0,
        child: BlurEffectView(
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets.map((e) => e).toList(),
          ),
        ),
      ),
    );
  }
}

