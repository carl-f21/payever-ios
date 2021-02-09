import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/pos/views/pos_connect_init_screen.dart';
import 'package:payever/pos/views/pos_connect_screen.dart';
import 'package:payever/pos/views/pos_create_terminal_screen.dart';
import 'package:payever/pos/views/pos_qr_app.dart';
import 'package:payever/pos/views/pos_setting_screen.dart';
import 'package:payever/pos/views/pos_switch_terminals_screen.dart';
import 'package:payever/pos/views/pos_twillo_settings.dart';
import 'package:payever/pos/views/products_screen/pos_products_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'pos_device_payment_settings.dart';

class PosInitScreen extends StatelessWidget {

  final DashboardScreenBloc dashboardScreenBloc;

  PosInitScreen({
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    return PosScreen(dashboardScreenBloc);
  }
}

class PosScreen extends StatefulWidget {

  final DashboardScreenBloc dashboardScreenBloc;
  List<ProductsModel>products = [];
  Business currentBusiness;

  PosScreen(this.dashboardScreenBloc) {
    if (dashboardScreenBloc.state.posProducts != null &&
        dashboardScreenBloc.state.posProducts.isNotEmpty)
      products.addAll(dashboardScreenBloc.state.posProducts);
    currentBusiness = dashboardScreenBloc.state.activeBusiness;
  }

  @override
  createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {

  static const platform = const MethodChannel('payever.flutter.dev/tapthephone');
  PosScreenBloc screenBloc;
  int selectedIndex = 0;
  PosProductsScreen posProductScreen;
  double mainWidth = 0;

  @override
  void initState() {
    screenBloc = PosScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    )
      ..add(PosScreenInitEvent(
          currentBusiness: widget.dashboardScreenBloc.state.activeBusiness,
          terminals: widget.dashboardScreenBloc.state.terminalList,
          activeTerminal: widget.dashboardScreenBloc.state.activeTerminal,
          defaultCheckout: widget.dashboardScreenBloc.state.defaultCheckout,
          channelSets: widget.dashboardScreenBloc.state.channelSets,
          products: widget.products
      ));

    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (mainWidth == 0) {
      mainWidth = GlobalUtils.isTablet(context) ? Measurements.width * 0.7 : Measurements.width;
    }

    return BlocListener(
      bloc: screenBloc,
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
        bloc: screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(PosScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title:
        Language.getWidgetStrings('widgets.pos.title'),
        icon: SvgPicture.asset(
          'assets/images/pos.svg',
          color: Colors.white,
          height: 20,
          width: 20,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: <Widget>[
              // _toolBar(state),
              Expanded(
                child: _body1(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body1(PosScreenState state) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          width: mainWidth,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (state.activeTerminal != null)
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            List<ProductsModel>products = [];
                            products.addAll(widget.products);
                            Navigator.push(
                              context,
                              PageTransition(
                                child: PosProductsScreen(
                                  state.businessId,
                                  screenBloc,
                                  products,
                                  widget.dashboardScreenBloc.state.posProductsInfo,),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Color(0xFFa3a9b8),
                                        Color(0xFF868a95),
                                      ]),
                                ),
                                child: Text(
                                  getDisplayName(state.activeTerminal.name),
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text(state.activeTerminal.name, style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20,),
                            ],
                          ),
                        ),
                      ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: PosSwitchTerminalsScreen(
                                screenBloc: screenBloc,
                              ),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/switch-terminal.svg', width: 24, height: 24,),
                            SizedBox(width: 12,),
                            Expanded(child: Text('Switch terminal', style: TextStyle(fontSize: 18),)),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: PosCreateTerminalScreen(
                                screenBloc: screenBloc,
                              ),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/add-terminal.svg', width: 24, height: 24,),
                            SizedBox(width: 12,),
                            Expanded(child: Text('Add new terminal', style: TextStyle(fontSize: 18),)),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              if (state.activeTerminal != null)
                Container(
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
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
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/qr-generator.svg',
                              width: 24,
                              height: 24,
                              color: iconColor(),
                            ),
                            SizedBox(width: 12,),
                            Expanded(child: Text('QR Generator', style: TextStyle(fontSize: 18),)),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              if (state.activeTerminal != null)
                Container(
                  decoration: BoxDecoration(
                    color: overlayBackground(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                          height: 61,
                          padding: EdgeInsets.only(left: 14, right: 14),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: PosSettingScreen(
                                    screenBloc: screenBloc,
                                  ),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        '${Env.cdnIcon}icon-comerceos-settings-not-installed.png',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12,),
                                Expanded(child: Text('Settings', style: TextStyle(fontSize: 18),)),
                                Icon(Icons.arrow_forward_ios, size: 20),
                              ],
                            ),
                          ),
                        ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: PosConnectInitScreen(
                                  screenBloc: screenBloc,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${Env.cdnIcon}icon-comerceos-connect-not-installed.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text('Connect', style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _connectWidget(PosScreenState state) {
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
                                          businessId: widget.currentBusiness.id,
                                          terminalId: state.activeTerminal.id,
                                        ): UninstallTerminalDevicePaymentEvent(
                                          payment: integrations[index].integration.name,
                                          businessId: widget.currentBusiness.id,
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
                                              businessId: widget.currentBusiness.id,
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
                                              businessId: widget.currentBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: widget.currentBusiness.name,
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
                                              businessId: widget.currentBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: widget.currentBusiness.name,
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
                          activeBusiness: widget.currentBusiness,
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

  Widget _settingsWidget(PosScreenState state) {
    return Container(
      padding: EdgeInsets.all(16),
      width: Measurements.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Business UUID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  widget.currentBusiness.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: overlayBackground(),
                child: Text(
                  state.businessCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  screenBloc.add(CopyBusinessEvent(businessId: widget.currentBusiness.id));
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Terminal UUID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  state.activeTerminal.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: overlayBackground(),
                child: Text(
                  state.terminalCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  screenBloc.add(CopyTerminalEvent(
                      businessId: widget.currentBusiness.id,
                      terminal: state.activeTerminal));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context, PosScreenState state) {
    return [
      if (state.activeTerminal != null)
        OverflowMenuItem(
          title: 'Switch terminal',
          onTap: () async {
            Navigator.push(
              context,
              PageTransition(
                child: PosSwitchTerminalsScreen(
                  screenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      OverflowMenuItem(
        title: 'Add new terminal',
        onTap: () async {
          Navigator.push(
            context,
            PageTransition(
              child: PosCreateTerminalScreen(
                screenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: PosCreateTerminalScreen(
                screenBloc: screenBloc,
                editTerminal: state.activeTerminal,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
    ];
  }
  get divider {
    return Divider(
      height: 0,
      indent: 50,
      thickness: 0.5,
      color: Colors.grey[500],
    );
  }

  Future<Null> _showNativeView() async {
    await platform.invokeMethod('showNativeView');
  }
}

