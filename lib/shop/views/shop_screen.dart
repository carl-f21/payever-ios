import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/create_shop_screen.dart';
import 'package:payever/shop/views/shop_dashboard_screen.dart';
import 'package:payever/shop/views/edit/shop_edit_screen.dart';
import 'package:payever/shop/views/shop_setting_screen.dart';
import 'package:payever/shop/views/switch_shop_screen.dart';
import 'package:payever/shop/views/themes/theme_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

class ShopInitScreen extends StatelessWidget {

  final List<ShopModel> shopModels;
  final ShopModel activeShop;
  final DashboardScreenBloc dashboardScreenBloc;

  ShopInitScreen({
    this.shopModels,
    this.activeShop,
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ShopScreen(
      globalStateModel: globalStateModel,
      shopModels: shopModels,
      activeShop: activeShop,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ShopScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final List<ShopModel> shopModels;
  final ShopModel activeShop;
  final DashboardScreenBloc dashboardScreenBloc;

  ShopScreen({
    this.globalStateModel,
    this.shopModels,
    this.activeShop,
    this.dashboardScreenBloc,
  });

  @override
  createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  ShopScreenBloc screenBloc;
  int selectedIndex = 0;
  double mainWidth = 0;

  @override
  void initState() {
    super.initState();
    screenBloc = ShopScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    )..add(ShopScreenInitEvent(
        currentBusinessId: widget.globalStateModel.currentBusiness.id,
      ));
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
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return Scaffold(
            appBar: MainAppbar(
              dashboardScreenBloc: widget.dashboardScreenBloc,
              dashboardScreenState: widget.dashboardScreenBloc.state,
              title: Language.getWidgetStrings('widgets.store.title'),
              icon: SvgPicture.asset(
                'assets/images/shopicon.svg',
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
                    if (state.activeShop != null)
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: ShopDashboardScreen(state.activeShop),
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
                                  getDisplayName(state.activeShop.name),
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text(state.activeShop.name, style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20,),
                            ],
                          ),
                        ),
                      ),
                    divider,
                    if (state.activeShop != null)
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            PageTransition(
                              child: SwitchShopScreen(
                                businessId: widget.globalStateModel.currentBusiness.id,
                                screenBloc: screenBloc,
                              ),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                          if (result == 'refresh') {
                            screenBloc.add(
                                ShopScreenInitEvent(
                                  currentBusinessId: widget.globalStateModel.currentBusiness.id,
                                )
                            );
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/shop-switch.svg', width: 24, height: 24,),
                            SizedBox(width: 12,),
                            Expanded(child: Text('Switch shop', style: TextStyle(fontSize: 18),)),
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
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            PageTransition(
                              child: CreateShopScreen(
                                businessId: widget.globalStateModel.currentBusiness.id,
                                screenBloc: screenBloc,
                                fromDashBoard: true,
                              ),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                          if (result == 'refresh') {
                            screenBloc.add(
                                ShopScreenInitEvent(
                                  currentBusinessId: widget.globalStateModel.currentBusiness.id,
                                )
                            );
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/shop-add-new.svg', width: 24, height: 24,),
                            SizedBox(width: 12,),
                            Expanded(child: Text('Add new shop', style: TextStyle(fontSize: 18),)),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    if (state.activeShop != null)
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, PageTransition(
                            child: ShopEditScreen(screenBloc),
                            type: PageTransitionType.fade,
                          ));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/shop-edit.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'Edit',
                              style: TextStyle(fontSize: 18),
                            )),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              if (state.activeShop != null)
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
                                child: ShopSettingScreen(screenBloc),
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
                              Expanded(child: Text(Language.getPosStrings('info_boxes.terminal.panels.settings.title'), style: TextStyle(fontSize: 18),)),
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
                                child: ThemesScreen(
                                  dashboardScreenBloc: widget.dashboardScreenBloc,
                                  screenBloc: screenBloc,
                                  globalStateModel: widget.globalStateModel,
                                  activeShop: widget.activeShop,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/shop-themes.svg', width: 24, height: 24,),
                              SizedBox(width: 12,),
                              Expanded(child: Text(Language.getPosStrings('info_boxes.terminal.panels.themes.title'), style: TextStyle(fontSize: 18),)),
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

  get divider {
    return Divider(
      height: 0,
      indent: 50,
      thickness: 0.5,
      color: Colors.grey[500],
    );
  }

}

