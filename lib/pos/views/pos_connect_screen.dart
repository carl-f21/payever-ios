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
import 'package:payever/pos/views/pos_qr_settings.dart';
import 'package:payever/pos/views/pos_twillo_settings.dart';
import 'package:payever/theme.dart';

import 'pos_device_payment_settings.dart';

Map<String, String> icons = {
  'device-payments': 'assets/images/device.svg',
  'qr': 'assets/images/qr-code.svg',
  'twilio': 'assets/images/twilio.svg',

};
class PosConnectScreen extends StatefulWidget {

  final PosScreenBloc screenBloc;
  final Business activeBusiness;

  PosConnectScreen({
    this.screenBloc,
    this.activeBusiness,
  });

  @override
  createState() => _PosConnectScreenState();
}

class _PosConnectScreenState extends State<PosConnectScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';

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

  Widget _appBar(PosScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                  child: SvgPicture.asset(
                    'assets/images/pos.svg',
                    color: Colors.white,
                    height: 16,
                    width: 24,
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            'Connect',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  Widget _body(PosScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: <Widget>[
              _toolBar(state),
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolBar(PosScreenState state) {
    return Container(
      height: 44,
      color: Colors.black87,
      child: Container(),
    );
  }

  Widget _getBody(PosScreenState state) {
    return _connectWidget(state);
  }

  Widget _connectWidget(PosScreenState state) {
    if (state.communications.length == 0) {
      widget.screenBloc.add(GetPosCommunications(businessId: widget.activeBusiness.id));
    }
    List<Communication> communications = state.communications;
    return Container(
      margin: EdgeInsets.all(12),
      child: BlurEffectView(
        radius: 12,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: (communications.length * 50).toDouble(),
              child: BlurEffectView(
                radius: 12,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              height: 50,
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            icons[communications[index].integration.name],
                                            height: 16,
                                            width: 16,
                                            color: iconColor(),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8),
                                          ),
                                          Expanded(
                                            child: Text(
                                              Language.getPosConnectStrings(communications[index].integration.displayOptions.title),
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (communications[index].integration.name == 'device-payments') {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                child: PosDevicePaymentSettings(
                                                  businessId: widget.activeBusiness.id,
                                                  screenBloc: widget.screenBloc,
                                                  installed: communications[index].installed,
                                                ),
                                                type: PageTransitionType.fade,
                                                duration: Duration(milliseconds: 500),
                                              ),
                                            );
                                        } else if (communications[index].integration.name == 'qr') {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                child: PosQRSettings(
                                                  businessId: widget.activeBusiness.id,
                                                  screenBloc: widget.screenBloc,
                                                  businessName: widget.activeBusiness.name,
                                                  installed: communications[index].installed,
                                                ),
                                                type: PageTransitionType.fade,
                                                duration: Duration(milliseconds: 500),
                                              ),
                                            );
                                        } else if (communications[index].integration.name == 'twilio') {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                child: PosTwilioScreen(
                                                  businessId: widget.activeBusiness.id,
                                                  screenBloc: widget.screenBloc,
                                                  businessName: widget.activeBusiness.name,
                                                  installed: communications[index].installed,
                                                ),
                                                type: PageTransitionType.fade,
                                                duration: Duration(milliseconds: 500),
                                              ),
                                            );
                                        }
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: overlayBackground()
                                        ),
                                        child: Center(
                                          child: Text(
                                            communications[index].installed ? 'Open': 'Install',
                                            style: TextStyle(
                                                fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.white30,
                            endIndent: 0,
                            indent: 0,
                          );
                        },
                        itemCount: state.communications.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }

  Widget showDevicePaymentSettings(PosScreenState state) {
    if (state.devicePaymentSettings == null) {
      widget.screenBloc.add(GetPosDevicePaymentSettings(businessId: widget.activeBusiness.id));
    }

    return  Container();
  }

  void showIntegrations(PosScreenState state) {
  }

  Widget showCommunications(PosScreenState state) {
    if (state.communications.length == 0) {
      widget.screenBloc.add(GetPosCommunications(businessId: widget.activeBusiness.id));
    }
    List<Communication> communications = state.communications;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: BlurEffectView(
        radius: 12,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                      height: 50,
                      child: Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              communications[index].integration.name,//displayOptions.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Switch(
                                  value: true,
                                  onChanged: (value) {
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 20,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black.withOpacity(0.4)
                                    ),
                                    child: Center(
                                      child: Text('Open',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.white30,
                    endIndent: 0,
                    indent: 0,
                  );
                },
                itemCount: state.integrations.length,
              ),
            ),
            communications.length > 0 ? Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.white30,
              endIndent: 0,
              indent: 0,
            ): Container(height: 0,),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: 50,
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 12,
                      ),
                      Padding(padding: EdgeInsets.only(left: 4),),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

