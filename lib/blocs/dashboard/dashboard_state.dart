import 'package:flutter/cupertino.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/shop/models/models.dart';

class DashboardScreenState {
  final bool isLoading;
  final bool isInitialScreen;
  final bool isPosLoading;
  final List<BusinessApps> businessWidgets;
  final List<Business> businesses;
  final Business activeBusiness;
  final User user;
  final AuthUser authUser;
  final FetchWallpaper wallpaper;
  final CurrentWallpaper currentWallpaper;
  final Terminal activeTerminal;
  final ShopModel activeShop;
  final List<Terminal> terminalList;
  final double total;
  final List<AppWidget> currentWidgets;
  final List<Month> lastYear;
  final List<double> monthlySum;
  final List<Day> lastMonth;
  final List<Tutorial> tutorials;
  final List<Widget> activeWid;
  final List<ProductsModel> posProducts;
  final Info posProductsInfo;
  final String language;
  final String curWall;
  final List<Business> searchBusinesses;
  final List<Collection> searchTransactions;
  final List<Products> lastSalesRandom;
  final List<ConnectModel> connects;
  final List<ShopModel> shops;
  final Map<String, List<NotificationModel>> notifications;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;
  final String installBusinessAppId;
  final List<ChannelSet>channelSets;
  final MyWallpaper personalWallpaper;
  final String openAppCode;

  DashboardScreenState({
    this.isLoading = false,
    this.isInitialScreen = true,
    this.isPosLoading = true,
    this.businessWidgets = const [],
    this.businesses = const [],
    this.currentWidgets = const [],
    this.activeBusiness,
    this.user,
    this.authUser,
    this.wallpaper,
    this.currentWallpaper,
    this.total = 0,
    this.terminalList,
    this.activeTerminal,
    this.posProducts = const [],
    this.posProductsInfo,
    this.lastYear = const [],
    this.monthlySum = const [],
    this.lastMonth = const [],
    this.tutorials = const [],
    this.activeWid = const [],
    this.language,
    this.curWall,
    this.searchBusinesses = const [],
    this.searchTransactions = const [],
    this.lastSalesRandom,
    this.connects,
    this.shops = const [],
    this.activeShop,
    this.notifications = const {},
    this.checkouts = const [],
    this.defaultCheckout,
    this.installBusinessAppId = '',
    this.channelSets,
    this.personalWallpaper,
    this.openAppCode = '',
  });

  List<Object> get props => [
    this.isLoading,
    this.businessWidgets,
    this.isPosLoading,
    this.businesses,
    this.currentWidgets,
    this.activeBusiness,
    this.user,
    this.authUser,
    this.wallpaper,
    this.currentWallpaper,
    this.total,
    this.terminalList,
    this.activeTerminal,
    this.posProducts,
    this.posProductsInfo,
    this.lastYear,
    this.monthlySum,
    this.lastMonth,
    this.tutorials,
    this.activeWid,
    this.isInitialScreen,
    this.language,
    this.curWall,
    this.searchBusinesses,
    this.searchTransactions,
    this.lastSalesRandom,
    this.connects,
    this.shops,
    this.activeShop,
    this.notifications,
    this.checkouts,
    this.defaultCheckout,
    this.installBusinessAppId,
    this.channelSets,
    this.personalWallpaper,
    this.openAppCode,
  ];

  DashboardScreenState copyWith({
    bool isLoading,
    bool isInitialScreen,
    bool isPosLoading,
    List<BusinessApps> businessWidgets,
    List<AppWidget> currentWidgets,
    List<Business> businesses,
    Business activeBusiness,
    User user,
    AuthUser authUser,
    FetchWallpaper wallpaper,
    CurrentWallpaper currentWallpaper,
    Terminal activeTerminal,
    List<Terminal> terminalList,
    double total,
    List<Month> lastYear,
    List<double> monthlySum,
    List<Day> lastMonth,
    List<Tutorial> tutorials,
    List<Widget> activeWid,
    List<ProductsModel> posProducts,
    Info posProductsInfo,
    String language,
    String curWall,
    List<Business> searchBusinesses,
    List<Collection> searchTransactions,
    List<Products> lastSalesRandom,
    List<ConnectModel> connects,
    List<ShopModel> shops,
    ShopModel activeShop,
    Map<String, List<NotificationModel>> notifications,
    List<Checkout> checkouts,
    Checkout defaultCheckout,
    List<ChannelSet> channelSets,
    String installBusinessAppId,
    MyWallpaper personalWallpaper,
    String openAppCode,
  }) {
    return DashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
      isInitialScreen: isInitialScreen ?? this.isInitialScreen,
      isPosLoading: isPosLoading ?? this.isPosLoading,
      businessWidgets: businessWidgets ?? this.businessWidgets,
      currentWidgets: currentWidgets ?? this.currentWidgets,
      businesses: businesses ?? this.businesses,
      activeBusiness: activeBusiness ?? this.activeBusiness,
      user: user ?? this.user,
      authUser: authUser ?? this.authUser,
      wallpaper: wallpaper ?? this.wallpaper,
      currentWallpaper: currentWallpaper ?? this.currentWallpaper,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      terminalList: terminalList ?? this.terminalList,
      total: total ?? this.total,
      lastYear: lastYear ?? this.lastYear,
      monthlySum: monthlySum ?? this.monthlySum,
      lastMonth: lastMonth ?? this.lastMonth,
      tutorials: tutorials ?? this.tutorials,
      activeWid: activeWid ?? this.activeWid,
      language: language ?? this.language,
      curWall: curWall ?? this.curWall,
      searchBusinesses: searchBusinesses ?? this.searchBusinesses,
      searchTransactions: searchTransactions ?? this.searchTransactions,
      lastSalesRandom: lastSalesRandom ?? this.lastSalesRandom,
      connects: connects ?? this.connects,
      posProducts: posProducts ?? this.posProducts,
      posProductsInfo: posProductsInfo ?? this.posProductsInfo,
      shops: shops ?? this.shops,
      activeShop: activeShop ?? this.activeShop,
      notifications: notifications ?? this.notifications,
      checkouts: checkouts ?? this.checkouts,
      installBusinessAppId: installBusinessAppId ?? this.installBusinessAppId,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      channelSets: channelSets ?? this.channelSets,
      personalWallpaper: personalWallpaper ?? this.personalWallpaper,
      openAppCode: openAppCode ?? this.openAppCode,
    );
  }
}

class DashboardScreenSuccess extends DashboardScreenState {}

class DashboardScreenInitialFetchSuccess extends DashboardScreenState {
  List<AppWidget> widgetApps;
  DashboardScreenInitialFetchSuccess({this.widgetApps}) : super();
}

class DashboardScreenLogout extends DashboardScreenState {}
class DashboardScreenSwitch extends DashboardScreenState {}

class DashboardScreenFailure extends DashboardScreenState {
  final String error;

  DashboardScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'DashboardScreenFailure { error $error }';
  }
}
