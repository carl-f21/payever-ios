import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_event.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';

import 'enable_password_screen.dart';
import 'external_domain_screen.dart';
import 'local_domain_screen.dart';

class ShopSettingScreen extends StatefulWidget {
  final ShopScreenBloc screenBloc;

  const ShopSettingScreen(this.screenBloc);

  @override
  _ShopSettingScreenState createState() => _ShopSettingScreenState(screenBloc);
}

class _ShopSettingScreenState extends State<ShopSettingScreen> {
  final ShopScreenBloc screenBloc;

  _ShopSettingScreenState(this.screenBloc);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {

        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return Scaffold(
            appBar: Appbar(Language.getPosStrings('info_boxes.terminal.panels.settings.title'),),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: Column(
                    children: <Widget>[
                      // _toolBar(state),
                      Expanded(
                        child: _body(state),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _body(ShopScreenState state) {
    return Container(
      width: GlobalUtils.mainWidth,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: BlurEffectView(
          child: Wrap(
            children: <Widget>[
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Language.getWidgetStrings('widgets.store.live-status'),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: state.activeShop.accessConfig.isLive,
                        onChanged: (value) {
                          AccessConfig config = state.activeShop.accessConfig;
                          config.isLive = value;
                          screenBloc.add(
                            UpdateShopSettings(
                              businessId: state.activeBusiness.id,
                              shopId: state.activeShop.id,
                              config: config,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        Language.getWidgetStrings('Payever Domain'),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${state.activeShop.accessConfig.internalDomain}.new.payever.shop',
                            ),
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: LocalDomainScreen(
                                    screenBloc: screenBloc,
                                    businessId: state.activeBusiness.id,
                                    detailModel: state.activeShop,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Text(
                                Language.getSettingsStrings('actions.edit')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        Language.getWidgetStrings('Own Domain'),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            state.activeShop.accessConfig.ownDomain != null
                                ? '${state.activeShop.accessConfig.ownDomain}.new.payever.shop'
                                : '',
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ExternalDomainScreen(
                                    screenBloc: screenBloc,
                                    businessId: state.activeBusiness.id,
                                    detailModel: state.activeShop,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Text(
                                Language.getSettingsStrings('actions.edit')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        Language.getWidgetStrings('Password'),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            state.activeShop.accessConfig.isLocked ? 'Enabled': 'Disabled',
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EnablePasswordScreen(
                                    screenBloc: screenBloc,
                                    businessId: state.activeBusiness.id,
                                    detailModel: state.activeShop,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Text(
                                Language.getSettingsStrings('actions.edit')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

