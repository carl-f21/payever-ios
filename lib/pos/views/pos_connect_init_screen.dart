import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/pos/pos_state.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/pos/models/pos.dart';
import 'package:payever/pos/views/pos_connect_screen.dart';
import 'package:payever/pos/views/pos_device_payment_settings.dart';
import 'package:payever/pos/views/pos_qr_app.dart';
import 'package:payever/pos/views/pos_twillo_settings.dart';
import 'package:payever/settings/widgets/app_bar.dart';

import '../../theme.dart';

class PosConnectInitScreen extends StatefulWidget {
  final PosScreenBloc screenBloc;

  const PosConnectInitScreen({this.screenBloc});

  @override
  _PosConnectInitScreenState createState() => _PosConnectInitScreenState(screenBloc);
}

class _PosConnectInitScreenState extends State<PosConnectInitScreen> {
  final PosScreenBloc screenBloc;

  _PosConnectInitScreenState(this.screenBloc);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, PosScreenState state) async {

      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: Appbar('Setting'),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: _getBody(state),
              ),
            ),
          );
        },
      ),
    );

  }

  Widget _getBody(PosScreenState state) {
    List<Communication> integrations = state.integrations;
    List<String> terminalIntegrations = state.terminalIntegrations;
    return Center(
      child: Container(
        width: Measurements.width,
        padding: EdgeInsets.only(left: 16, right: 16),
        height: (state.integrations.length * 50).toDouble() + 50,
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
                                Language.getPosConnectStrings(integrations[index].integration.displayOptions.title),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      value: terminalIntegrations.contains(integrations[index].integration.name),
                                      onChanged: (value) {
                                        screenBloc.add(value ? InstallTerminalDevicePaymentEvent(
                                          payment: integrations[index].integration.name,
                                          businessId: screenBloc.state.activeBusiness.id,
                                          terminalId: state.activeTerminal.id,
                                        ): UninstallTerminalDevicePaymentEvent(
                                          payment: integrations[index].integration.name,
                                          businessId: screenBloc.state.activeBusiness.id,
                                          terminalId: state.activeTerminal.id,
                                        ));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (state.integrations[index].integration.name == 'device-payments') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosDevicePaymentSettings(
                                              businessId: screenBloc.state.activeBusiness.id,
                                              screenBloc: screenBloc,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                      else if (state.integrations[index].integration.name == 'qr') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosQRAppScreen(
                                              businessId: screenBloc.state.activeBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: screenBloc.state.activeBusiness.name,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      } else if (state.integrations[index].integration.name == 'twilio') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosTwilioScreen(
                                              businessId: screenBloc.state.activeBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: screenBloc.state.activeBusiness.name,
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
                                          Language.getCommerceOSStrings('actions.open'),
                                          style: TextStyle(
                                            fontSize: 10,
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
              integrations.length > 0 ? Divider(
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
                    Navigator.push(
                      context,
                      PageTransition(
                        child: PosConnectScreen(
                          activeBusiness: screenBloc.state.activeBusiness,
                          screenBloc: screenBloc,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
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
      ),
    );
  }
}
