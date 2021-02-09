import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_event.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/connect/checkout_connect_screen.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

import 'channels_checkout_flow_screen.dart';
import 'checkout_channel_shopsystem_screen.dart';
import 'checkout_channelset_screen.dart';
import 'checkout_link_edit_screen.dart';

class ChannelsScreen extends StatefulWidget {
  final CheckoutScreenBloc screenBloc;

  ChannelsScreen(this.screenBloc);

  @override
  _ChannelsScreenState createState() => _ChannelsScreenState(screenBloc);
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final CheckoutScreenBloc screenBloc;

  _ChannelsScreenState(this.screenBloc);

  @override
  void initState() {
    screenBloc.add(GetChannelConfig());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {}
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return Scaffold(
            appBar: Appbar(Language.getWidgetStrings('widgets.checkout.channels')),
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
    if (state.loadingChannel) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: GlobalUtils.mainWidth,
          child: BlurEffectView(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(widget.screenBloc.state.channelItems.length + 1, (index) {
                  if (index == widget.screenBloc.state.channelItems.length) {
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
                                  category: 'shopsystems',
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
                    ChannelItem model = widget.screenBloc.state.channelItems[index];
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
                                      value: model.checkValue,
                                      onChanged: (val) {

                                      },
                                    ),
                                  ) : Container(),
                                  MaterialButton(
                                    onPressed: () {
                                      if (model.title == 'Pay by Link') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: ChannelCheckoutFlowScreen(
                                              checkoutScreenBloc:screenBloc,
                                              openUrl:
                                              'https://checkout.payever.org/pay/create-flow/channel-set-id/${state.channelSet.id}',
                                            ),
                                            type: PageTransitionType.fade,
                                          ),
                                        );
                                      }
                                      else if (model.title == 'Point of Sale') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutChannelSetScreen(
                                              checkoutScreenBloc: screenBloc,
                                              business: state.activeBusiness.id,
                                              category: 'pos',
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                      else if (model.title == 'Shop') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutChannelSetScreen(
                                              checkoutScreenBloc: screenBloc,
                                              business: state.activeBusiness.id,
                                              category: 'shop',
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                      else if (model.title == 'Mail') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutChannelSetScreen(
                                              checkoutScreenBloc: screenBloc,
                                              business: state.activeBusiness.id,
                                              category: 'marketing',
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                      else if (model.button == 'Edit') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutLinkEditScreen(
                                              screenBloc: screenBloc,
                                              title: model.title,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                      else {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: CheckoutChannelShopSystemScreen(
                                              checkoutScreenBloc: screenBloc,
                                              business: state.activeBusiness.id,
                                              connectModel: model.model,
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
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    height: 24,
                                    minWidth: 0,
                                    padding:
                                    EdgeInsets.only(left: 8, right: 8),
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
}
