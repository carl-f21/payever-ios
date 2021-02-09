import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_event.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

import 'checkout_connect_screen.dart';
import 'checkout_device_payment_screen.dart';
import 'checkout_qr_integration.dart';
import 'checkout_twillo_settings.dart';

class ConnectScreen extends StatefulWidget {
  final CheckoutScreenBloc screenBloc;

  ConnectScreen(this.screenBloc);

  @override
  ConnectScreenState createState() => ConnectScreenState(screenBloc);
}

class ConnectScreenState extends State<ConnectScreen> {
  final CheckoutScreenBloc screenBloc;

  ConnectScreenState(this.screenBloc);

  @override
  void initState() {
    screenBloc.add(GetConnectConfig());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenConnectInstallStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return Scaffold(
            appBar: Appbar(Language.getCommerceOSStrings('dashboard.apps.connect')),
              body: SafeArea(
                bottom: false,
                  child: BackgroundBase(true, body: _body(state))));
        },
      ),
    );
  }

  Widget _body(CheckoutScreenState state) {
    if (state.loadingConnect) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: Measurements.width,
          child: BlurEffectView(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(screenBloc.state.connectItems.length + 1, (index) {
                  if (index == screenBloc.state.connectItems.length) {
                    return Container(
                      height: 50,
                      child: SizedBox.expand(
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: CheckoutConnectScreen(
                                  checkoutScreenBloc: screenBloc,
                                  business: state.activeBusiness.id,
                                  category: 'communications',
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                '+ Add',
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    ChannelItem model = screenBloc.state.connectItems[index];
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Row(
                                  children: <Widget>[
                                    model.image,
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                    ),
                                    Flexible(
                                      child: Text(
                                        model.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Helvetica Neue',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  model.checkValue != null ? Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      value: isInstalled(model, state),
                                      onChanged: (val) {
                                        screenBloc.add(InstallCheckoutIntegrationEvent(integrationId: model.name));
                                      },
                                    ),
                                  ) : Container(),
                                  MaterialButton(
                                    onPressed:(){
                                      if (model.title.contains('QR')) {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutQRIntegrationScreen(
                                              screenBloc: screenBloc,
                                              title: 'QR',
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      } else if (model.title.contains('Device')) {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutDevicePaymentScreen(
                                              screenBloc: screenBloc,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      } else if (model.title.contains('Twilio')) {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutTwilioScreen(
                                              screenBloc: screenBloc,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                    },
                                    color: overlayBackground(),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 24,
                                    minWidth: 0,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      model.button,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'HelveticaNeueMed',
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.white70,
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isInstalled(ChannelItem item, CheckoutScreenState state) {
    return state.integrations.contains(item.name);
  }
}
