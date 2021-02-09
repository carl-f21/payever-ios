import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/views/connect/checkout_twillo_add_phonenumber.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/pos/views/pos_twillo_add_phonenumber.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

class CheckoutTwilioScreen extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;

  CheckoutTwilioScreen({
    this.screenBloc,
  });

  @override
  createState() => _CheckoutTwilioScreenState();
}

class _CheckoutTwilioScreenState extends State<CheckoutTwilioScreen> {

  int isOpened = 0;

  @override
  void initState() {
      widget.screenBloc.add(
        GetCheckoutTwilioSettings(),
      );
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
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(CheckoutScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: Appbar('Twilio'),
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

  Widget _getBody(CheckoutScreenState state) {
    dynamic response = state.twilioForm;
    List<Widget> widgets = [];

    if (response != null) {
      if (response is Map) {
        dynamic form = response['form'];
        String id = '';
        if (form['actionContext'] != null) {
          if (form['actionContext']['id'] != null) {
            id = form['actionContext']['id'];
          }
        }
        String contentType = form['contentType'] != null ? form['contentType'] : '';
        dynamic content = form['content'] != null ? form['content']: null;
        if (content != null) {
          List contentData = content[contentType];
          for (int i = 0 ; i < contentData.length; i++) {
            dynamic data = contentData[i];
            if (data['data'] != null) {
              List<dynamic> list = data['data'];
              Widget section = Container(
                height: 56,
                color: overlayBackground(),
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (isOpened == i) {
                          isOpened = -1;
                        } else {
                          isOpened = i;
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/twilio.svg',
                                width: 16,
                                height: 16,
                                color: iconColor(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                              ),
                              Expanded(
                                child: Text(
                                  Language.getPosTpmStrings(data['title']),
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
                        Icon(
                          isOpened == i ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              widgets.add(section);
              if (isOpened == i) {
                for(dynamic w in list) {
                  if (w[0]['type'] == 'text') {
                    Widget textWidget = Container(
                      height: 64,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                w[0]['value'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                              ),
                              Text(
                                w[1]['value'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              String sid = '';
                              if (w[2]['actionData'] != null) {
                                dynamic actionData = w[2]['actionData'];
                                sid = actionData['sid'] ?? '';
                              }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context)
                                  {
                                    return new CupertinoAlertDialog(
                                      title: Column(
                                        children: <Widget>[
                                          Icon(Icons.warning),
                                          Text(
                                              Language.getPosTpmStrings('tpm.communications.twilio.are_you_sure')
                                          ),
                                        ],
                                      ),
                                      content: Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Text(
                                          Language.getPosTpmStrings('tpm.communications.twilio.confirm_remove_number'),
                                        ),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: new Text(
                                              Language.getPosTpmStrings('tpm.communications.twilio.no'),
                                              style: TextStyle(
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            }
                                        ),
                                        CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: new Text(
                                              Language.getPosTpmStrings('tpm.communications.twilio.yes'),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.screenBloc.add(RemoveCheckoutPhoneNumberSettings(
                                                id: id,
                                                action: 'remove-number',
                                                sid: sid,
                                              ));
                                            }
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                            height: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: overlayBackground(),
                            child: Text(
                              Language.getPosTpmStrings(w[2]['text']),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    widgets.add(textWidget);
                  }
                }
                if (data['operation'] != null) {
                  Widget textWidget = Container(
                    height: 56,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        minWidth: 0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: CheckoutTwilioAddPhoneNumber(
                                screenBloc: widget.screenBloc,
                                id: id,
                              ),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        color: overlayBackground(),
                        child: Text(
                          Language.getPosTpmStrings(data['operation']['text']),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                  widgets.add(textWidget);
                }
              }
            } else if (data['fieldset'] != null) {
              List<dynamic> list = data['fieldset'];
              Widget section = Container(
                height: 56,
                color: overlayBackground(),
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (isOpened == i) {
                          isOpened = -1;
                        } else {
                          isOpened = i;
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.vpn_key,
                                size: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                              ),
                              Expanded(
                                child: Text(
                                  Language.getPosTpmStrings(data['title']),
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
                        Icon(
                          isOpened == i ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              widgets.add(section);
              if (isOpened == i) {
                for(int j = 0; j < list.length; j++) {
                  dynamic w = list[j];
                  if (w['type'].contains('input')) {
                    Map<String, dynamic> valueList = {};
                    if (data['fieldsetData'] != null) {
                      valueList = data['fieldsetData'];
                    }
                    String value = '';
                    if (valueList.containsKey(w['name'])) {
                      value = valueList[w['name']];
                    }
                    Widget inputWidget = Container(
                      height: 64,
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(fontSize: 16),
                          onChanged: (val) {

                          },
                          initialValue: value,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
//                            hintText: Language.getPosTpmStrings(w['inputSettings']['placeholder']),
//                            hintStyle: TextStyle(
//                              color: Colors.white.withOpacity(0.5),
//                            ),
                            labelText: Language.getPosTpmStrings(w['fieldSettings']['label']),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 0.5),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: w['type'] == 'input-password',
                        ),
                      ),
                    );
                    widgets.add(inputWidget);
                    widgets.add(Divider(height: 0, thickness: 0.5, color: Color(0xFF888888),));
                  }
                }
                if (data['operation'] != null) {
                  Widget textWidget = Container(
                    height: 56,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        minWidth: 0,
                        onPressed: () {
                        },
                        color: overlayBackground(),
                        child: Text(
                          Language.getPosTpmStrings(data['operation']['text']),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                  widgets.add(textWidget);
                }
              }
            }
          }
        }
      }
    }
    return Center(
      child: Wrap(
        runSpacing: 16,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: BlurEffectView(
                blur: 15,
                radius: 12,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widgets.map((e) => e).toList(),
                ),
              ),
            ),
          ]
      ),
    );
  }
}

