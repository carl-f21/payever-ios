import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/welcome/welcome_bloc.dart';
import 'package:payever/blocs/welcome/welcome_event.dart';
import 'package:payever/blocs/welcome/welcome_state.dart';
import 'package:payever/checkout/views/checkout_screen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/views/connect_screen.dart';
import 'package:payever/dashboard/dashboard_screen.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/pos/views/pos_screen.dart';
import 'package:payever/products/views/products_screen.dart';
import 'package:payever/settings/views/setting_screen.dart';
import 'package:payever/shop/views/shop_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/views/transactions_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class WelcomeScreen extends StatefulWidget {
  final BusinessApps businessApps;
  final Business business;
  final DashboardScreenBloc dashboardScreenBloc;

  WelcomeScreen({
    this.business,
    this.businessApps,
    this.dashboardScreenBloc,
  });

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();

}

class _WelcomeScreenState extends State<WelcomeScreen> {

  WelcomeScreenBloc screenBloc;
  @override
  void initState() {
    screenBloc = WelcomeScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc
    );
    if (!widget.businessApps.installed)
      screenBloc.add(WelcomeScreenInitEvent(businessId: widget.business.id, uuid: widget.businessApps.microUuid,));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, WelcomeScreenState state) async {
        if (state is WelcomeScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is WelcomeScreenStateSuccess) {
          GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context, listen: false);
          globalStateModel.setRefresh(GlobalUtils.isBusinessMode);
          Widget businessApp;
          if (widget.businessApps.code.contains('transaction')) {
            businessApp = TransactionScreenInit(dashboardScreenBloc: widget.dashboardScreenBloc);
          } else if (widget.businessApps.code.contains('shop')) {
            businessApp = ShopInitScreen(dashboardScreenBloc: widget.dashboardScreenBloc);
          } else if (widget.businessApps.code.contains('pos')) {
            businessApp = PosInitScreen(
              dashboardScreenBloc: widget.dashboardScreenBloc,
            );
          } else if (widget.businessApps.code.contains('connect')) {
            businessApp = ConnectInitScreen(dashboardScreenBloc: widget.dashboardScreenBloc);
          } else if (widget.businessApps.code.contains('checkout')) {
            businessApp = CheckoutInitScreen(dashboardScreenBloc: widget.dashboardScreenBloc);
          } else if (widget.businessApps.code.contains('products')) {
            businessApp = ProductsInitScreen(dashboardScreenBloc: widget.dashboardScreenBloc);
          } else if (widget.businessApps.code.contains('setting')) {
            businessApp = SettingInitScreen(dashboardScreenBloc: widget.dashboardScreenBloc);
          } else if (widget.businessApps.code.contains('commerceos')) {
            businessApp = DashboardScreenInit(refresh: true);
          }

          if (businessApp != null) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: businessApp,
                type: PageTransitionType.fade,
              ),
            );
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: BlocBuilder<WelcomeScreenBloc, WelcomeScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, WelcomeScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(WelcomeScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BackgroundBase(
        true,
        body: SafeArea(
          bottom: false,
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.businessApps.code != 'products' ? '${Env.cdnIcon}icon-comerceos-${widget.businessApps.code}-not-installed.png': '${Env.cdnIcon}icon-comerceos-product-not-installed.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Text(
                        Language.getWelcomeStrings('welcome.${widget.businessApps.code}.title'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Text(
                        Language.getWelcomeStrings('welcome.${widget.businessApps.code}.message'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        width: Measurements.width * 0.7,
                        child: MaterialButton(
                          onPressed: () {
                            screenBloc.add(ToggleEvent(businessId: widget.business.id, type: widget.businessApps.code,));
//                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          color: overlayButtonBackground(),
                          child: state.isLoading ? SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(iconColor()),
                              strokeWidth: 2,
                            ),
                            height: 24.0,
                            width: 24.0,
                          ) : Text(
                            Language.getWelcomeStrings('welcome.get-started'),
                            style: TextStyle(
                              color: iconColor(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        width: Measurements.width * 0.6,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text: 'Hereby I confirm the ',
                                style: new TextStyle(
                                  fontSize: 12,
                                  color: iconColor(),
                                ),
                              ),
                              new TextSpan(
                                text: 'terms',
                                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: iconColor()),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () { launch(Language.getWelcomeStrings('welcome.${widget.businessApps.code}.terms_link'));
                                  },
                              ),
                              new TextSpan(
                                text: ' and ',
                                style: new TextStyle(fontSize: 12, color: iconColor()),
                              ),
                              new TextSpan(
                                text: 'pricing',
                                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: iconColor()),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () { launch(Language.getWelcomeStrings('welcome.${widget.businessApps.code}.pricing_link'));
                                  },
                              ),
                              new TextSpan(
                                text: ' of the payever ',
                                style: new TextStyle(fontSize: 12, color: iconColor()),
                              ),
                              new TextSpan(
                                text: Language.getCommerceOSStrings(widget.businessApps.dashboardInfo.title),
                                style: TextStyle(
                                  color: iconColor(),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}