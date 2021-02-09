import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/views/channels/channels_checkout_flow_screen.dart';
import 'package:payever/checkout/views/checkout_screen.dart';
import 'package:payever/checkout/views/workshop/create_edit_checkout_screen.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/edit_business_app_screen.dart';
import 'package:payever/dashboard/sub_view/dashboard_advertising_view.dart';
import 'package:payever/dashboard/sub_view/dashboard_mail_view.dart';
import 'package:payever/dashboard/sub_view/dashboard_studio_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/connect/views/connect_screen.dart';
import 'package:payever/contacts/views/contacts_screen.dart';
import 'package:payever/pos/views/pos_create_terminal_screen.dart';
import 'package:payever/pos/views/pos_screen.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/product_detail_screen.dart';
import 'package:payever/products/views/products_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/setting_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/shop/views/shop_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:payever/welcome/welcome_screen.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

class DashboardScreenInit extends StatelessWidget {
  final bool refresh;
  final bool registered;

  DashboardScreenInit({this.refresh = false, this.registered = false});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel =
        Provider.of<GlobalStateModel>(context, listen: true);

    return DashboardScreen(
      wallpaper: globalStateModel.currentWallpaper,
      refresh: globalStateModel.refresh,
      registered: registered,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String wallpaper;
  final bool refresh;
  final bool registered;
//  double mainWidth = 0;

  DashboardScreen({this.wallpaper, this.refresh, this.registered = false});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DashboardScreenBloc screenBloc;
  bool isLoaded = false;
  String searchString = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  GlobalStateModel globalStateModel;
  bool _isPortrait;
  bool _isTablet;

  @override
  void initState() {
    GlobalUtils.isBusinessMode = true;
    screenBloc = DashboardScreenBloc();
    screenBloc.add(DashboardScreenInitEvent(
        wallpaper: widget.wallpaper, isRefresh: widget.refresh));
    super.initState();
  }

  @override
  void didChangeDependencies() {
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

//    if (widget.mainWidth == 0) {
//      widget.mainWidth = _isTablet ? Measurements.width * 0.7 : Measurements.width;
//    }

    if (globalStateModel.refresh) {
      screenBloc.add(DashboardScreenInitEvent(wallpaper: widget.wallpaper));
      globalStateModel.setRefresh(false);
    }

    return BlocListener(
        bloc: screenBloc,
        listener: (BuildContext context, DashboardScreenState state) {
          String code = state.openAppCode;
          if (state.defaultCheckout != null
              && (code.contains('pos')
                  || code.contains('checkout'))) {
            if (code.contains('pos')) {
              Future.delayed(Duration(milliseconds: 100)).then((value) {
                  navigatePosApp();
              });
            } else {
              Future.delayed(Duration(milliseconds: 100)).then((value) {
                  navigateCheckoutApp();
              });
            }
            screenBloc.add(OpenAppEvent(openAppCode:''));
          } else if (state is DashboardScreenLogout) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: LoginInitScreen(),
                type: PageTransitionType.fade,
              ),
            );
          } else if (state is DashboardScreenSwitch) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                  child: SwitcherScreen(false),
                  type: PageTransitionType.fade,
                ));
          }
        },
        child: BlocBuilder<DashboardScreenBloc, DashboardScreenState>(
          bloc: screenBloc,
          builder: (BuildContext context, DashboardScreenState state) {
            return state.isInitialScreen
                ? _showLoading(state)
                : _showMain(context, state);
          },
        ));
  }

  Widget _showLoading(DashboardScreenState state) {
    print('wallpaper => ${widget.wallpaper}');
    return Stack(
      overflow: Overflow.visible,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: Container(
            child: CachedNetworkImage(
              imageUrl:
                  state.curWall != null ? state.curWall : widget.wallpaper,
              placeholder: (context, url) => Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: Measurements.height,
          width: Measurements.width,
          child: Container(
            child: Scaffold(
              key: formKey,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  height: Measurements.width * (_isTablet ? 0.05 : 0.1),
                  width: Measurements.width * (_isTablet ? 0.05 : 0.1),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showMain(BuildContext context, DashboardScreenState state) {
    if (state.language != null) {
      Language.language = state.language;
      Language(context);
    }
    return _body(state);
  }

  Widget _body(DashboardScreenState state) {
    if (state.language != null) {
      Language.language = state.language;
      Language(context);
    }

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
      dashboardWidgets.add(_transactionView(state, appWidget, businessApp));
    }
    // Business Apps
    dashboardWidgets.add(_businessAppsView(state));
    // Shop
    if (widgets.where((element) => element.type == 'shop').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'shop').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'shop')
          .toList()
          .first;
      dashboardWidgets.add(
        _shopView(state, appWidget, businessApp),
      );
    }
    // Point of Sale
    if (widgets.where((element) => element.type == 'pos').toList().length > 0) {
      appWidget =
          widgets.where((element) => element.type == 'pos').toList().first;
      businessApp =
          businessApps.where((element) => element.code == 'pos').toList().first;
      dashboardWidgets.add(_pointOfSaleView(state, appWidget, businessApp));
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
        dashboardWidgets.add(_checkoutView(state, appWidget, businessApp));
      }
    }

    // Mail
    if (widgets
            .where((element) => element.type == 'marketing')
            .toList()
            .length >
        0) {
      appWidget = widgets
          .where((element) => element.type == 'marketing')
          .toList()
          .first;
      businessApp = businessApps
          .where((element) => element.code == 'marketing')
          .toList()
          .first;
      dashboardWidgets.add(_mailView(state, appWidget, businessApp));
    }

    // Studio
    if (widgets.where((element) => element.type == 'studio').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'studio').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'studio')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'studio')
              .toList()
              .first
          : null;
//      dashboardWidgets.add(_studioView(state, appWidget, businessApp));
    }

    // Ads
    if (widgets.where((element) => element.type == 'ads').toList().length > 0) {
      appWidget =
          widgets.where((element) => element.type == 'ads').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'ads')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'ads')
              .toList()
              .first
          : null;
//      dashboardWidgets.add(_adsView(state, appWidget, businessApp));
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
      dashboardWidgets.add(_contactsView(state, appWidget, businessApp));
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
      dashboardWidgets.add(_productsView(state, appWidget, businessApp));
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
      dashboardWidgets.add(_connectView(state, appWidget, businessApp));
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
      dashboardWidgets.add(_settingView(state, appWidget, businessApp));
    }

    // Tutorials
    dashboardWidgets.add(_tutorialView(state, appWidget, businessApp));

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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: Container(
      //   width: 40,
      //   height: 40,
      //   margin: EdgeInsets.only(bottom: 44),
      //   alignment: Alignment.bottomLeft,
      //   child: RawMaterialButton(
      //     shape: CircleBorder(),
      //     elevation: 4,
      //     fillColor: overlayColor(),
      //     child: SvgPicture.asset(
      //       'assets/images/help.svg',
      //       width: 24,
      //       color: iconColor(),
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: BackgroundBase(
          false,
          backgroundColor: Colors.transparent,
          wallPaper: state.curWall,
          body: Container(
            alignment: Alignment.center,
            child: Container(
              width: GlobalUtils.mainWidth,
              child: Stack(
                children: <Widget>[
                  Align(alignment: Alignment.center, child: _headerView(state)),
                  RefreshIndicator(
                    onRefresh: () {
                      screenBloc
                          .add(DashboardScreenInitEvent(wallpaper: state.curWall));
                      return Future.delayed(Duration(seconds: 3));
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: dashboardWidgets.length,
                      itemBuilder: (context, index) {
                        return dashboardWidgets[index];
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 14,
                          thickness: 0,
                          color: Colors.transparent,
                        );
                      },
                    ),
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
          '${Language.getCommerceOSStrings('dashboard.welcome')} ${state.user.firstName ?? '${Language.getCommerceOSStrings('dashboard.undefined')}'},',
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
          Language.getCommerceOSStrings('dashboard.grow.your.business'),
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 54,
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
                        hintText: Language.getTransactionStrings('form.filter.labels.search').toUpperCase(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                        screenBloc.add(OpenAppEvent(openAppCode: ''));
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
                          screenBloc.add(DashboardScreenInitEvent(
                              wallpaper: globalStateModel.currentWallpaper));
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
                            screenBloc.add(OpenAppEvent(openAppCode: ''));
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
                              screenBloc.add(DashboardScreenInitEvent(
                                  wallpaper:
                                      globalStateModel.currentWallpaper));
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

  Widget _transactionView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('transactions')) {
      notifications = state.notifications['transactions'];
    }
    return DashboardTransactionsView(
      appWidget: appWidget,
      businessApps: businessApp,
      isLoading: state.isInitialScreen,
      total: state.total,
      lastMonth: state.lastMonth,
      lastYear: state.lastYear,
      monthlySum: state.monthlySum,
      onOpen: () {
        _navigateAppsScreen(
            state,
            TransactionScreenInit(
              dashboardScreenBloc: screenBloc,
            )
        );
      },
      onTapContinueSetup: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapGetStarted: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapLearnMore: () {},
      notifications: notifications,
      openNotification: (NotificationModel model) {},
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
    );
  }

  Widget _businessAppsView(DashboardScreenState state) {
    return DashboardBusinessAppsView(
      businessApps: state.businessWidgets,
      appWidgets: state.currentWidgets,
      openAppCode: state.openAppCode,
      isTablet: _isTablet,
      onTapEdit: () {
        _navigateAppsScreen(state, EditBusinessAppScreen(dashboardScreenBloc: screenBloc, globalStateModel: globalStateModel,));
      },
      onTapWidget: (BusinessApps aw) {
        if (aw.code.contains('transactions')) {
          _navigateAppsScreen(state, TransactionScreenInit(
            dashboardScreenBloc: screenBloc,
          ));
        } else if (aw.code.contains('pos')) {
          if (isLoadingData(state)) {
            screenBloc.add(OpenAppEvent(openAppCode: aw.code));
            return;
          }
          navigatePosApp();
        } else if (aw.code.contains('shop')) {
          _navigateAppsScreen(state, ShopInitScreen(
            dashboardScreenBloc: screenBloc,
          ));
        } else if (aw.code.contains('products')) {
          _navigateAppsScreen(state, ProductsInitScreen(
            dashboardScreenBloc: screenBloc,
          ));
        } else if (aw.code.contains('connect')) {
          _navigateAppsScreen(state, ConnectInitScreen(
            dashboardScreenBloc: screenBloc,
          ));
        } else if (aw.code.contains('contact')) {
          _navigateAppsScreen(state, ContactsInitScreen(
            dashboardScreenBloc: screenBloc,
          ));
        } else if (aw.code.contains('checkout')) {
          if (isLoadingData(state)) {
            screenBloc.add(OpenAppEvent(openAppCode: aw.code));
            return;
          }
          navigateCheckoutApp();
        } else if (aw.code.contains('settings')) {
          _navigateAppsScreen(state, SettingInitScreen(
            dashboardScreenBloc: screenBloc,
          ));
        }
      },
    );
  }

  Widget _shopView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('shops')) {
      notifications = state.notifications['shops'];
    }
    return DashboardShopView(
      businessApps: businessApp,
      appWidget: appWidget,
      shops: state.shops,
      shopModel: state.activeShop,
      isLoading: state.isLoading,
      onOpen: () {
        print('Open Shop');
        _navigateAppsScreen(state, ShopInitScreen(
          dashboardScreenBloc: screenBloc,
        ));
      },
      onTapEditShop: () {
        _navigateAppsScreen(state, ShopInitScreen(
          dashboardScreenBloc: screenBloc,
        ));
      },
      notifications: notifications,
      openNotification: (NotificationModel model) {
        if (model.app == 'products-aware' &&
            model.message.contains('newProduct')) {
          _navigateAppsScreen(state, ProductsInitScreen(
            dashboardScreenBloc: screenBloc,
          ));
        }
      },
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
      onTapGetStarted: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapContinueSetup: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapLearnMore: (url) {
        _launchURL(url);
      },
    );
  }

  Widget _pointOfSaleView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('pos')) {
      notifications = state.notifications['pos'];
    }
    return DashboardAppPosView(
      isLoading: state.isPosLoading,
      businessApps: businessApp,
      appWidget: appWidget,
      terminals: state.terminalList,
      activeTerminal: state.activeTerminal,
      onTapEditTerminal: () async {
        screenBloc.add(OpenAppEvent(openAppCode: ''));
        final result = await Navigator.push(
          context,
          PageTransition(
            child: PosCreateTerminalScreen(
              fromDashBoard: true,
              screenBloc: PosScreenBloc(
                dashboardScreenBloc: screenBloc,
              ),
              editTerminal: state.activeTerminal,
            ),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
          ),
        );
        if ((result != null) && (result == 'Terminal Updated')) {
          screenBloc.add(FetchPosEvent(business: state.activeBusiness));
        }
      },
      onTapOpen: () {
        navigatePosApp();
      },
      notifications: notifications,
      openNotification: (NotificationModel model) {
        if (model.app == 'products-aware' &&
            model.message.contains('newProduct')) {
          _navigateAppsScreen(
              state,
              ProductsInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              isDuration: true
          );
        }
      },
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
      onTapGetStarted: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapContinueSetup: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapLearnMore: (url) {
        _launchURL(url);
      },
    );
  }

  Widget _checkoutView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('checkout')) {
      notifications = state.notifications['checkout'];
    }
    return DashboardCheckoutView(
      businessApps: businessApp,
      appWidget: appWidget,
      notifications: notifications,
      checkouts: state.checkouts,
      defaultCheckout: state.defaultCheckout,
      openNotification: (NotificationModel model) {},
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
      onOpen: () {
        navigateCheckoutApp();
      },
      onTapGetStarted: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapContinueSetup: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapLinkOrManage: (bool isLink) {
        if (isLink) {
          List<ChannelSet> channelSets = state.channelSets;
          if (channelSets == null && channelSets.isEmpty) {
            return;
          }
          ChannelSet channelSet = channelSets.firstWhere((element) =>
          (element.checkout == state.defaultCheckout.id && element.type == 'link'));
          if (channelSet == null) {
            return;
          }
          String openUrl =
              '${Env.wrapper}/pay/create-flow/channel-set-id/${channelSet.id}';
          _navigateAppsScreen(
            state,
            ChannelCheckoutFlowScreen(
              checkoutScreenBloc: CheckoutScreenBloc(),
              openUrl: openUrl,
              fromDashboard: true,
            ),
          );
        } else {
          _navigateAppsScreen(
            state,
            CreateEditCheckoutScreen(
              businessId: state.activeBusiness.id,
              checkout: state.defaultCheckout,
              fromDashBoard: true,
              screenBloc: CheckoutSwitchScreenBloc(),
            ),
          );
        }
      },
    );
  }

  Widget _mailView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('marketing')){
      notifications = state.notifications['marketing'];
    }
    return DashboardMailView(
      businessApps: businessApp,
      appWidget: appWidget,
      notifications: notifications,
      openNotification: (NotificationModel model) {
      },
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
    );
  }

  Widget _studioView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('studio')){
      notifications = state.notifications['studio'];
    }
    return DashboardStudioView(
      businessApps: businessApp,
      appWidget: appWidget,
      notifications: notifications,
      openNotification: (NotificationModel model) {
      },
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
    );
  }

  Widget _adsView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('ads')){
      notifications = state.notifications['ads'];
    }
    return DashboardAdvertisingView(
      businessApps: businessApp,
      appWidget: appWidget,
      notifications: notifications,
      openNotification: (NotificationModel model) {
      },
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
    );
  }

  Widget _contactsView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('contacts')) {
      notifications = state.notifications['contacts'];
    }
    return DashboardContactView(
      businessApps: businessApp,
      appWidget: appWidget,
      notifications: notifications,
      openNotification: (NotificationModel model) {},
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
    );
  }

  Widget _productsView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.keys.toList().contains('products')) {
      notifications = state.notifications['products'];
    }
    return DashboardProductsView(
      businessApps: businessApp,
      appWidget: appWidget,
      lastSales: state.lastSalesRandom,
      business: state.activeBusiness,
      onOpen: () async {
        _navigateAppsScreen(state, ProductsInitScreen(
          dashboardScreenBloc: screenBloc,
        ));
      },
      onSelect: (Products product) async {
        ProductsModel productsModel = new ProductsModel();
        productsModel.id = product.id;
        productsModel.title = product.name;
        List<String> images = [];
        if (product.thumbnail != null) {
          images.add(product.thumbnail);
        }
        productsModel.images = images;
        productsModel.businessUuid = product.business;
        productsModel.price = product.price;
        productsModel.salePrice = product.salePrice;
        productsModel.uuid = product.uuid;

        Provider.of<GlobalStateModel>(context, listen: false)
            .setCurrentBusiness(state.activeBusiness);
        Provider.of<GlobalStateModel>(context, listen: false)
            .setCurrentWallpaper(state.curWall);
        screenBloc.add(OpenAppEvent(openAppCode: ''));
        final result = await Navigator.push(
          context,
          PageTransition(
            child: ProductDetailScreen(
              productsModel: productsModel,
              businessId: globalStateModel.currentBusiness.id,
              fromDashBoard: true,
              screenBloc:
              ProductsScreenBloc(dashboardScreenBloc: screenBloc),
            ),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
          ),
        );
        if ((result != null) && (result == 'Products Updated')) {}
      },
      notifications: notifications,
      openNotification: (NotificationModel model) {
        if (model.message.contains('missing')) {
          String productId = '';
          if (model.data != null) {
            if (model.data['productId'] != null) {
              productId = model.data['productId'];
            }
          }
          if (productId != '') {
            _navigateAppsScreen(
              state,
              ProductDetailScreen(
                productsModel: ProductsModel(id: productId),
                businessId: globalStateModel.currentBusiness.id,
                fromDashBoard: true,
                screenBloc:
                ProductsScreenBloc(dashboardScreenBloc: screenBloc),
              ),
              isDuration: true,
            );
          }
        }
      },
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
      onTapGetStarted: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapContinueSetup: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
    );
  }

  Widget _connectView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('connect')) {
      notifications = state.notifications['connect'];
    }
    return DashboardConnectView(
      businessApps: businessApp,
      appWidget: appWidget,
      notifications: notifications,
      connects: state.connects,
      openNotification: (NotificationModel model) {},
      deleteNotification: (NotificationModel model) {
        screenBloc.add(DeleteNotification(notificationId: model.id));
      },
      tapOpen: () {
        _navigateAppsScreen(
          state,
          ConnectInitScreen(
            dashboardScreenBloc: screenBloc,
          ),
          isDuration: true,
        );
      },
      onTapGetStarted: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapContinueSetup: (app) {
        _navigateAppsScreen(
            state,
            WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: app,
            )
        );
      },
      onTapLearnMore: (url) {
        _launchURL(url);
      },
    );
  }

  Widget _settingView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    List<NotificationModel> notifications = [];
    if (state.notifications.containsKey('settings')) {
      notifications = state.notifications['settings'];
    }
    return DashboardSettingsView(
        businessApps: businessApp,
        appWidget: appWidget,
        notifications: notifications,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
        onTapOpen: () {
          print(businessApp.setupStatus);
          if (businessApp.setupStatus == 'notStarted') {
            _navigateAppsScreen(state, WelcomeScreen(
              dashboardScreenBloc: screenBloc,
              business: state.activeBusiness,
              businessApps: businessApp,
            ));
          } else {
            _navigateAppsScreen(state, SettingInitScreen(
              dashboardScreenBloc: screenBloc,
            ));
          }
        },
        onTapOpenWallpaper: () async {
          _navigateAppsScreen(state, WallpaperScreen(
            globalStateModel: globalStateModel,
            setScreenBloc: SettingScreenBloc(
              dashboardScreenBloc: screenBloc,
              globalStateModel: globalStateModel,
            )..add(SettingScreenInitEvent(
              business: state.activeBusiness.id,
            )),
            fromDashboard: true,
          ));
        },
        onTapOpenLanguage: () {
          _navigateAppsScreen(state, LanguageScreen(
            globalStateModel: globalStateModel,
            settingBloc: SettingScreenBloc(
              dashboardScreenBloc: screenBloc,
              globalStateModel: globalStateModel,
            )..add(SettingScreenInitEvent(
              business: state.activeBusiness.id,
              user: state.user,
            )),
            fromDashboard: true,
          ));
        });
  }

  Widget _tutorialView(DashboardScreenState state, AppWidget appWidget, BusinessApps businessApp) {
    return DashboardTutorialView(
      tutorials: state.tutorials,
      onWatchTutorial: (Tutorial tutorial) {
        if (tutorial.urls.length > 0) {
          String lang = state.activeBusiness.defaultLanguage;
          List<Urls> urls = tutorial.urls
              .where((element) => element.language == lang)
              .toList();
          if (urls.length > 0) {
            _launchURL(urls.first.url);
          } else {
            _launchURL(tutorial.url);
          }
        } else {
          _launchURL(tutorial.url);
        }
      },
    );
  }

  void navigatePosApp() {
    _navigateAppsScreen(screenBloc.state, PosInitScreen(dashboardScreenBloc: screenBloc));
  }

  void navigateCheckoutApp() {
    _navigateAppsScreen(screenBloc.state, CheckoutInitScreen(dashboardScreenBloc: screenBloc));
  }

  _navigateAppsScreen(
      DashboardScreenState state, Widget widget, {bool isDuration = true}) {
    screenBloc.add(OpenAppEvent(openAppCode: ''));

    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentBusiness(state.activeBusiness);
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentWallpaper(state.curWall);
    Navigator.push(
      context,
      PageTransition(
        child: widget,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: isDuration ? 500 : 300),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isLoadingData(DashboardScreenState state) {
    if (state.activeBusiness == null || state.defaultCheckout == null) {
      return true;
    }
    return false;
  }
}
