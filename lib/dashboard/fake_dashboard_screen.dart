import 'dart:ui';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sub_view/dashboard_app_pos.dart';
import 'sub_view/dashboard_business_apps_view.dart';
import 'sub_view/dashboard_checkout_view.dart';
import 'sub_view/dashboard_connect_view.dart';
import 'sub_view/dashboard_contact_view.dart';
import 'sub_view/dashboard_products_view.dart';
import 'sub_view/dashboard_settings_view.dart';
import 'sub_view/dashboard_shop_view.dart';
import 'sub_view/dashboard_transactions_view.dart';
import 'sub_view/dashboard_tutorial_view.dart';

class FakeDashboardScreen extends StatefulWidget {

  final String wallpaper;
  final bool registered;
  double mainWidth = 0;

  FakeDashboardScreen({this.wallpaper = '', this.registered = false,});

  @override
  _FakeDashboardScreenState createState() => _FakeDashboardScreenState();
}

class _FakeDashboardScreenState extends State<FakeDashboardScreen> {
  DashboardScreenBloc screenBloc = DashboardScreenBloc();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoaded = false;
  String searchString = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  GlobalStateModel globalStateModel;
  bool _isPortrait;
  bool _isTablet;


  @override
  void initState() {
    screenBloc.add(AddStandardDataEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);
    SharedPreferences.getInstance().then((p) {
      Language.language = p.getString(GlobalUtils.LANGUAGE);
      Language(context);
    });
    _isPortrait = GlobalUtils.isPortrait(context);
    _isTablet = GlobalUtils.isTablet(context);
    Measurements.loadImages(context);

    if (widget.mainWidth == 0) {
      widget.mainWidth = _isTablet ? Measurements.width * 0.7 : Measurements.width;
    }

    return BlocBuilder<DashboardScreenBloc, DashboardScreenState>(
      bloc: screenBloc,
      builder: (BuildContext context, DashboardScreenState state) {
        return _showMain(context, state);
      },
    );
  }

  Widget _showMain(BuildContext context, DashboardScreenState state) {
    if (state.businessWidgets.isEmpty || state.currentWidgets.isEmpty) {
      return Container();
    }
    if (state.language != null) {
      Language.language = state.language;
      Language(context);
    }
    return Stack(
      children: <Widget>[
        _body(state),
        _blurBackGround(),
      ],
    );
  }

  Widget _blurBackGround() {
    if (GlobalUtils.theme == 'light') {
      return Stack(
        children: <Widget>[
          BlurEffectView(
            blur: 6.5,
            radius: 0,
            color: overlayBackground(),
          ),
          BlurryContainer(
            blur: 20,
            child: Container(),
            bgColor: overlayBackground(),
          ),
        ],
      );
    }
    return Stack(
      children: <Widget>[
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
        BlurryContainer(
          blur: 6.5,
          child: Container(),
          bgColor: Colors.transparent,
        ),
      ],
    );

  }
  Widget _body(DashboardScreenState state) {
    List<AppWidget> widgets = [];
    List<BusinessApps> businessApps = [];
    if (state.businessWidgets.length > 0) {
      widgets.addAll(state.currentWidgets);
      businessApps.addAll(state.businessWidgets);
      widgets.reversed.toList();
    } else {
//      return Container();
    }
    List<Widget> dashboardWidgets = [];
    // HEADER
//    dashboardWidgets.add(_headerView(state));
    // SEARCH BAR
    dashboardWidgets.add(SizedBox(height: 175,));
    dashboardWidgets.add(_searchBar(state));

    // TRANSACTIONS
    List<AppWidget> appWidgets =
        widgets.where((element) => element.type == 'transactions').toList();
    AppWidget appWidget;
    if (appWidgets.length > 0) {
      appWidget = appWidgets[0];
    }
    List bapps = businessApps
        .where((element) => element.code == 'transactions')
        .toList();
    BusinessApps businessApp;
    if (bapps.length > 0) {
      businessApp = bapps.first;
    }
    if (appWidget != null) {
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('transactions')) {
        notifications = state.notifications['transactions'];
      }
      dashboardWidgets.add(DashboardTransactionsView(
        appWidget: appWidget,
        businessApps: businessApp,
        isLoading: false,
        total: state.total,
        lastMonth: state.lastMonth,
        lastYear: state.lastYear,
        monthlySum: state.monthlySum,
        notifications: notifications,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
      ));
    }
    // Business Apps
    dashboardWidgets.add(DashboardBusinessAppsView(
      businessApps: state.businessWidgets,
      appWidgets: state.currentWidgets,
      isTablet: _isTablet,
    ));

    // Shop
    if (widgets.where((element) => element.type == 'shop').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'shop').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'shop')
          .toList()
          .first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('shops')) {
        notifications = state.notifications['shops'];
      }
      dashboardWidgets.add(
        DashboardShopView(
          businessApps: businessApp,
          appWidget: appWidget,
          shops: state.shops,
          shopModel: state.activeShop,
          isLoading: false,
          notifications: notifications,
        ),
      );
    }
    // Point of Sale
    if (widgets.where((element) => element.type == 'pos').toList().length > 0) {
      appWidget =
          widgets.where((element) => element.type == 'pos').toList().first;
      businessApp =
          businessApps.where((element) => element.code == 'pos').toList().first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('pos')) {
        notifications = state.notifications['pos'];
      }
      dashboardWidgets.add(DashboardAppPosView(
        isLoading: false,
        businessApps: businessApp,
        appWidget: appWidget,
        terminals: state.terminalList,
        activeTerminal: state.activeTerminal,
        notifications: notifications,
      ));
    }

    // Checkout
    if (widgets.where((element) => element.type == 'checkout').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'checkout').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'checkout')
          .toList()
          .first;
      if (appWidget != null) {
        List<NotificationModel> notifications = [];
        if (state.notifications.containsKey('checkout')) {
          notifications = state.notifications['checkout'];
        }
        dashboardWidgets.add(DashboardCheckoutView(
          businessApps: businessApp,
          appWidget: appWidget,
          notifications: notifications,
          checkouts: state.checkouts,
          defaultCheckout: state.defaultCheckout,
          openNotification: (NotificationModel model) {},
          deleteNotification: (NotificationModel model) {
            screenBloc.add(DeleteNotification(notificationId: model.id));
          },
        ));
      }
    }

    // Contacts
    if (widgets.where((element) => element.type == 'contacts').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'contacts').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'contacts')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'contacts')
              .toList()
              .first
          : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('contacts')) {
        notifications = state.notifications['contacts'];
      }
      dashboardWidgets.add(DashboardContactView(
        businessApps: businessApp,
        appWidget: appWidget,
        notifications: notifications,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
      ));
    }

    // Products
    if (widgets.where((element) => element.type == 'products').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'products').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'products')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'products')
              .toList()
              .first
          : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.keys.toList().contains('products')) {
        notifications = state.notifications['products'];
      }
      dashboardWidgets.add(
        DashboardProductsView(
          businessApps: businessApp,
          appWidget: appWidget,
          lastSales: state.lastSalesRandom,
          business: state.activeBusiness,
          notifications: notifications,
        ),
      );
    }

    // Connects
    if (widgets.where((element) => element.type == 'connect').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'connect').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'connect')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'connect')
              .toList()
              .first
          : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('connect')) {
        notifications = state.notifications['connect'];
      }
      dashboardWidgets.add(DashboardConnectView(
        businessApps: businessApp,
        appWidget: appWidget,
        notifications: notifications,
        connects: state.connects,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
      ));
    }

    // Settings
    if (widgets.where((element) => element.type == 'settings').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'settings').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'settings')
          .toList()
          .first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('settings')) {
        notifications = state.notifications['settings'];
      }
      dashboardWidgets.add(DashboardSettingsView(
          businessApps: businessApp,
          appWidget: appWidget,
          notifications: notifications,
          openNotification: (NotificationModel model) {},
          deleteNotification: (NotificationModel model) {
            screenBloc.add(DeleteNotification(notificationId: model.id));
          },
      ));
    }

    // Tutorials
    dashboardWidgets.add(DashboardTutorialView(
      tutorials: state.tutorials,
    ));

    // Paddings
    dashboardWidgets.add(Padding(
      padding: EdgeInsets.only(top: 24),
    ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: screenBloc,
        dashboardScreenState: state,
        title: Language.getCommerceOSStrings('registration.container.buttons.business'),
        icon: SvgPicture.asset(
          'assets/images/payeverlogo.svg',
          height: 16,
          width: 24,
        ),
        isClose: false,
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: BackgroundBase(
          false,
          backgroundColor: Colors.transparent,
          wallPaper: state.curWall,
          body: Container(
            alignment: Alignment.center,
            child: Container(
              width: widget.mainWidth,
              child: Stack(
                children: <Widget>[
                  Align(alignment: Alignment.center, child: _headerView(state)),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          itemCount: dashboardWidgets.length,
                          itemBuilder: (context, index) {
                            return dashboardWidgets[index];
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 8,
                              thickness: 8,
                              color: Colors.transparent,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerView(DashboardScreenState state) {
    return Column(
      children: [
        SizedBox(height: 60),
        Text(
          'Welcome undefined',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'grow your business',
          style: TextStyle(
            fontSize: 18,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 64),
        ),
      ],
    );
  }

  Widget _searchBar(DashboardScreenState state) {
    return BlurEffectView(
      radius: 12,
      isDashboard: true,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        height: 40,
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/search_place_holder.svg',
              color: iconColor(),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocus,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: Language.getTransactionStrings('form.filter.labels.search'),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      onChanged: (val) {
                        if (val.length > 0) {
                          if (searchString.length > 0) {
                            searchString = val;
                          } else {
                            setState(() {
                              searchString = val;
                            });
                          }
                        } else {
                          if (searchString.length == 0) {
                            searchString = val;
                          } else {
                            setState(() {
                              searchString = val;
                            });
                          }
                        }
                      },
                      onSubmitted: (val) async {
                        FocusScope.of(context).unfocus();
                        if (val.length == 0) {
                          return;
                        }
                        final result = await Navigator.push(
                          context,
                          PageTransition(
                            child: SearchScreen(
                              dashboardScreenBloc: screenBloc,
                              businessId: state.activeBusiness.id,
                              searchQuery: searchController.text,
                              appWidgets: state.currentWidgets,
                              activeBusiness: state.activeBusiness,
                              currentWall: state.curWall,
                            ),
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                        if ((result != null) && (result == 'changed')) {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                        } else {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                        }
                      },
                    ),
                  ),
                  searchController.text.isEmpty
                      ? Container()
                      : MaterialButton(
                          onPressed: () {
                            setState(() {
                              searchString = '';
                              searchController.text = searchString;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          shape: CircleBorder(
                            side: BorderSide.none,
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 20,
                          minWidth: 20,
                          child: SvgPicture.asset(
                            'assets/images/closeicon.svg',
                            width: 8,
                            color: iconColor(),
                          ),
                        ),
                  searchController.text.isEmpty
                      ? Container()
                      : MaterialButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final result = await Navigator.push(
                              context,
                              PageTransition(
                                child: SearchScreen(
                                  dashboardScreenBloc: screenBloc,
                                  businessId: state.activeBusiness.id,
                                  searchQuery: searchController.text,
                                  appWidgets: state.currentWidgets,
                                  activeBusiness: state.activeBusiness,
                                  currentWall: state.curWall,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                            if ((result != null) && (result == 'changed')) {
                              setState(() {
                                searchString = '';
                                searchController.text = searchString;
                                FocusScope.of(context).unfocus();
                              });
                            } else {
                              setState(() {
                                searchString = '';
                                searchController.text = searchString;
                                FocusScope.of(context).unfocus();
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: overlayBackground(),
                          elevation: 0,
                          minWidth: 0,
                          height: 20,
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
