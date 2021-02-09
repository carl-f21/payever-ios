import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/connect/checkout_connect_screen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

import 'checkout_payment_settings_screen.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final CheckoutScreenBloc screenBloc;

  PaymentOptionsScreen(this.screenBloc);

  @override
  _PaymentOptionsScreenState createState() =>
      _PaymentOptionsScreenState(screenBloc);
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  final CheckoutScreenBloc screenBloc;

  _PaymentOptionsScreenState(this.screenBloc);

  @override
  void initState() {
    screenBloc.add(GetPaymentConfig());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    bool _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {}
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return Scaffold(
            appBar: Appbar('Payment options'),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: _body(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(CheckoutScreenState state) {
    if (state.loadingPaymentOption)
      return Center(child: CircularProgressIndicator());


    List<ConnectModel> checkoutConnections = [];
    state.connections.forEach((checkoutIntegration) {
      bool isConnected = false;
      ConnectModel connectModel;
      state.connects.forEach((connect) {
        if (connect.integration.name == checkoutIntegration.integration &&
            connect.integration.category == 'payments') {
          isConnected = true;
          connectModel = connect;
        }
      });
      if (isConnected) {
        checkoutConnections.add(connectModel);
      }
    });

    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
          child: Container(
        width: GlobalUtils.mainWidth,
        child: BlurEffectView(
          child: SingleChildScrollView(
                  child: Column(
                    children:
                        List.generate(checkoutConnections.length + 1, (index) {
                      if (index == checkoutConnections.length) {
                        return Container(
                          height: 50,
                          width: Measurements.width,
                          child: SizedBox.expand(
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CheckoutConnectScreen(
                                      checkoutScreenBloc: screenBloc,
                                      business: state.activeBusiness.id,
                                      category: 'payments',
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
                        ConnectModel connectModel = checkoutConnections[index];
                        List list = state.checkoutConnections
                            .where((element) =>
                                element.integration ==
                                connectModel.integration.name)
                            .toList();
                        bool installed = false;
                        if (list.length > 0) {
                          installed = true;
                        }
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: Measurements.width,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      Language.getPosConnectStrings(connectModel
                                              .integration
                                              .displayOptions
                                              .title ??
                                          ''),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Helvetica Neue',
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: installed,
                                          onChanged: (val) {
                                            IntegrationModel integrationModel =
                                                state.connections.singleWhere(
                                                    (element) =>
                                                        element.integration ==
                                                        connectModel
                                                            .integration.name);
                                            val
                                                ? screenBloc.add(
                                                    InstallCheckoutPaymentEvent(
                                                        integrationModel:
                                                            integrationModel))
                                                : screenBloc.add(
                                                    UninstallCheckoutPaymentEvent(
                                                        integrationModel:
                                                            integrationModel));
                                          },
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child:
                                                  CheckoutPaymentSettingsScreen(
                                                checkoutScreenBloc: screenBloc,
                                                business:
                                                    state.activeBusiness.id,
                                                connectModel: connectModel,
                                              ),
                                              type: PageTransitionType.fade,
                                              duration:
                                                  Duration(milliseconds: 500),
                                            ),
                                          );
                                        },
                                        color: overlayBackground(),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        height: 24,
                                        minWidth: 0,
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                          Language.getConnectStrings(
                                              'actions.open'),
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
      )),
    );
  }
}
