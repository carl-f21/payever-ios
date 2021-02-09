import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/standard_data.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreenBloc extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  DashboardScreenBloc();
  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';
  SharedPreferences preferences;

  @override
  DashboardScreenState get initialState => DashboardScreenState();

  @override
  Stream<DashboardScreenState> mapEventToState(DashboardScreenEvent event) async* {
    preferences = await SharedPreferences.getInstance();
    if (event is DashboardScreenInitEvent) {
      yield* _checkVersion(event.wallpaper, event.isRefresh);
    } else if (event is DashboardScreenLoadDataEvent) {
      yield* _fetchInitialData();
    } else if (event is FetchMonthlyEvent) {
      yield* getDaily(event.business);
    } else if (event is FetchPosEvent) {
      yield* fetchPOSCard(event.business);
    } else if (event is FetchTutorials) {
      yield* getTutorials(event.business);
    } else if (event is FetchProducts) {
      yield* getProductsPopularMonthRandom(event.business);
    } else if (event is FetchConnects) {
      yield* getConnects(event.business);
    } else if (event is FetchShops) {
      yield* getShops(event.business);
    } else if (event is FetchNotifications) {
      yield* fetchNotifications();
    } else if (event is DeleteNotification) {
      yield* deleteNotification(event.notificationId);
    } else if (event is WatchTutorials) {
      yield* watchTutorial(event.tutorial);
    } else if (event is UpdateTheme) {

    } else if(event is BusinessAppInstallEvent) {
      yield* installBusinessApp(event.businessApp);
    } else if(event is WidgetInstallEvent) {
      yield* installWidget(event.appWidget);
    } else if(event is AddStandardDataEvent) {
      yield state.copyWith(
        currentWidgets: StandardData.currentWidgets,
        businessWidgets: StandardData.businessWidgets,
        businesses: StandardData.businesses,
        activeBusiness: StandardData.activeBusiness,
        user: StandardData.user,
        curWall: 'https://payever.azureedge.net/images/commerceos-background.jpg'
      );
    } else if (event is UpdateBusinessUserWallpaperEvent) {
      yield state.copyWith(
          activeBusiness: event.business,
          user: event.user,
          authUser: event.authUser,
          curWall: event.curWall,
          personalWallpaper: event.personalWallpaper);
    } else if (event is OpenAppEvent) {
      yield state.copyWith(openAppCode: event.openAppCode);
    }
  }

  Stream<DashboardScreenState> _checkVersion(String wallpaper, bool refresh) async* {
    try {
      yield state.copyWith(curWall: wallpaper);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      var environment = await api.getEnv();
      if (environment is Map) {
        Env.map(environment);
      } else {
        add(DashboardScreenInitEvent(wallpaper: wallpaper, isRefresh: true));
      }
//      var v = await api.getVersion();
//      Version vv = Version.map(v);
//      print("version:$version");
//      print("_version:${vv.minVersion}");
//      print("compare:${version.compareTo(vv.minVersion)}");

//      if (version.compareTo(vv.minVersion) < 0) {
//        print('Not Supported Version');
//      }else{
        if (refresh) {
          yield* loadData();
        } else {
          yield* _fetchInitialData();
        }
//      }
    } catch (error) {
      print(error.toString());
      if (error.toString().contains('SocketException')) {
        add(DashboardScreenInitEvent(wallpaper: wallpaper, isRefresh: true));
      } else {
        yield DashboardScreenLogout();
      }
    }
  }

  Stream<DashboardScreenState> _reLogin() async* {
    if (DateTime.now().difference(DateTime.parse(preferences.getString(GlobalUtils.LAST_OPEN))).inHours < 720) {
      try {
        var refreshTokenLogin = await api.login(
          preferences.getString(GlobalUtils.EMAIL),
          preferences.getString(GlobalUtils.PASSWORD),
        );
        Token tokenData = Token.map(refreshTokenLogin);
        preferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
        GlobalUtils.setCredentials(tokenData: tokenData);
        yield* _fetchInitialData();
      } catch (error) {
        if (error.toString().contains('SocketException')) {
          Future.delayed(Duration(milliseconds: 1500)).then((value) async =>
              _reLogin());
        } else {
          GlobalUtils.clearCredentials();
          yield DashboardScreenLogout();
        }
      }
    } else {
      GlobalUtils.clearCredentials();
      yield DashboardScreenLogout();
    }
  }

  Stream<DashboardScreenState> loadData() async* {
    String rfTokenString = preferences.getString(GlobalUtils.REFRESH_TOKEN) ?? '';
    dynamic interval = Measurements.parseJwt(rfTokenString)['exp'] * 1000;
    if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(interval)).inHours < 1) {
      try {
        dynamic refreshToken = await api.refreshToken(
          rfTokenString,
          preferences.getString(GlobalUtils.FINGERPRINT),
        );
        if (refreshToken != null) {
          if (refreshToken is Map) {
            Token token = Token.map(refreshToken);
            yield* _fetchInitialDataRenew(token, true);
          } else {
            yield* _reLogin();
          }
        } else {
          yield* _reLogin();
        }
      } catch (e) {
        print('Refresh Token Error = > $e');
        if (e.toString().contains('SocketException')) {
          yield* loadData();
        } else {
          yield* _reLogin();
        }
      }
    } else {
      yield* _reLogin();
    }
  }

  Stream<DashboardScreenState> _fetchInitialData() async* {
    try {
      List<BusinessApps> businessWidgets = [];
      List<AppWidget> widgetApps = [];
      List<Business> businesses = [];
      Business activeBusiness;
      FetchWallpaper fetchWallpaper;
      String language;
      String currentWallpaper;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String refreshToken = preferences.getString(GlobalUtils.REFRESH_TOKEN) ?? '';
      String accessToken = preferences.getString(GlobalUtils.TOKEN) ?? '';
      GlobalUtils.activeToken = Token(accessToken: accessToken, refreshToken: refreshToken);

      dynamic user = await api.getUser(accessToken);
      User tempUser = User.map(user);

      yield state.copyWith(user: tempUser);
      if (tempUser.language != sharedPreferences.getString(GlobalUtils.LANGUAGE)) {
        language = tempUser.language;
        // TODO:// setLanguage
      }

      dynamic businessObj = await api.getBusinesses(accessToken);
      businesses.clear();
      businessObj.forEach((item) {
        businesses.add(Business.map(item));
      });
      if (businesses != null) {
        for (Business b in businesses) {
          if (b.active) {
            activeBusiness = b;
            if (activeBusiness.themeSettings.theme != changeThemeBloc.state.theme) {
            if (activeBusiness.themeSettings.theme == 'dark') {
              BlocProvider.of<ChangeThemeBloc>(GlobalUtils.currentContext)..add(DarkTheme());
            } else if (activeBusiness.themeSettings.theme == 'light') {
              BlocProvider.of<ChangeThemeBloc>(GlobalUtils.currentContext)..add(LightTheme());
            } else {
              BlocProvider.of<ChangeThemeBloc>(GlobalUtils.currentContext)..add(DefaultTheme());
            }
            }
          }
        }
      }

      if (activeBusiness != null) {
        dynamic wallpaperObj = await api.getWallpaper(
            activeBusiness.id, accessToken);
        FetchWallpaper fetchWallpaper = FetchWallpaper.map(wallpaperObj);
        sharedPreferences.setString(
            GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
        currentWallpaper = '$wallpaperBase${fetchWallpaper.currentWallpaper.wallpaper}';
        dynamic widgetAppsObj = await api.getWidgets(
          sharedPreferences.getString(GlobalUtils.BUSINESS),
          accessToken,
        );
        widgetApps.clear();
        widgetAppsObj.forEach((item) {
          widgetApps.add(AppWidget.map(item));
        });

        dynamic businessAppsObj = await api.getBusinessApps(
          sharedPreferences.getString(GlobalUtils.BUSINESS),
          accessToken,
        );
        businessWidgets.clear();
        businessAppsObj.forEach((item) {
          businessWidgets.add(BusinessApps.fromMap(item));
        });
      }
      MyWallpaper personalWallpaper;
      dynamic wallPaperObj = await api.getWallpaperPersonal(accessToken);
      if (wallPaperObj is Map) {
        personalWallpaper = MyWallpaper.fromMap(wallPaperObj);
      }

      yield state.copyWith(
        isInitialScreen: false,
        isLoading: false,
        businesses: businesses,
        currentWidgets: widgetApps,
        activeBusiness: activeBusiness,
        businessWidgets: businessWidgets,
        wallpaper: fetchWallpaper,
        currentWallpaper: fetchWallpaper != null ? fetchWallpaper.currentWallpaper: null,
        curWall: currentWallpaper,
        language: language,
        personalWallpaper: personalWallpaper,
      );

      if (activeBusiness != null) {
        add(FetchMonthlyEvent(business: activeBusiness));
      }
    } catch (error) {
      yield DashboardScreenLogout();
    }
  }

  Stream<DashboardScreenState> _fetchInitialDataRenew(Token token, bool renew) async* {
    GlobalUtils.activeToken = token;
    if (!renew) {
      GlobalUtils.activeToken.refreshToken = preferences.getString(GlobalUtils.REFRESH_TOKEN) ?? '';
    }
    preferences.setString(GlobalUtils.TOKEN, GlobalUtils.activeToken.accessToken);
    preferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
    add(DashboardScreenLoadDataEvent());
  }

  Stream<DashboardScreenState> fetchPosProducts() async* {
    // Get Product
    List<ProductsModel> products = [];
    Info productInfo;
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query':
          '{\n  getProducts(businessUuid: \"${state.activeBusiness.id}\", paginationLimit: 20, pageNumber: 1, orderBy: \"price\", orderDirection: \"asc\", filterById: [], search: \"\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };
    dynamic response =
        await api.getProducts(GlobalUtils.activeToken.accessToken, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            print('infoObj => $infoObj');
            dynamic pagination = infoObj['pagination'];
            if (pagination != null) {
              productInfo = Info.toMap(pagination);
            }
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
            });
          }
        }
      }
    }
    yield state.copyWith(posProducts: products, posProductsInfo: productInfo);
    yield* getCheckout();
  }

  Stream<DashboardScreenState> getCheckout() async* {
    List<Checkout> checkouts = [];
    Checkout defaultCheckout;
    dynamic checkoutsResponse = await api.getCheckout(GlobalUtils.activeToken.accessToken, state.activeBusiness.id);
    if (checkoutsResponse is List) {
      checkoutsResponse.forEach((element) {
        checkouts.add(Checkout.fromJson(element));
      });
    }
    List defaults = checkouts.where((element) => element.isDefault).toList();

    if (defaults.length > 0) {
      defaultCheckout = defaults.first;
    } else {
      if (checkouts.length > 0) {
        defaultCheckout = checkouts.first;
      }
    }

    yield state.copyWith(checkouts: checkouts, defaultCheckout: defaultCheckout);
    if (state.openAppCode.contains('pos') || state.openAppCode.contains('checkout')) {
      if (defaultCheckout != null) {
        // await Future.delayed(Duration(milliseconds: 100));
      } else {
        Fluttertoast.showToast(msg: 'Can not find default checkout.');
      }
    }
    add(FetchTutorials(business: state.activeBusiness));
  }

  Stream<DashboardScreenState> fetchPOSCard(Business activeBusiness) async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isPosLoading: true);
    List<Terminal> terminals = [];
    List<ChannelSet> channelSets = [];
    dynamic terminalsObj = await api.getTerminal(activeBusiness.id, token);
    if (terminalsObj != null && terminalsObj is List){
      terminalsObj.forEach((terminal) {
        terminals.add(Terminal.fromJson(terminal));
      });
    }
    dynamic channelsObj = await api.getChannelSet(activeBusiness.id, token);
    if (channelsObj != null && channelsObj is List){
      channelsObj.forEach((channelSet) {
        channelSets.add(ChannelSet.fromJson(channelSet));
      });
    }

    terminals.forEach((terminal) async {
      channelSets.forEach((channelSet) async {
        if (terminal.channelSet == channelSet.id && channelSet.checkout != null && channelSet.checkout.length > 0) {
          dynamic paymentObj = await api.getCheckoutIntegration(activeBusiness.id, channelSet.checkout, token);
          paymentObj.forEach((pm) {
            terminal.paymentMethods.add(pm);
          });

          dynamic daysObj = await api.getLastWeek(activeBusiness.id, channelSet.id, token);
          int length = daysObj.length - 1;
          for (int i = length; i > length - 7; i--) {
            terminal.lastWeekAmount += Day.fromJson(daysObj[i]).amount;
          }
          daysObj.forEach((day) {
            terminal.lastWeek.add(Day.fromJson(day));
          });

          dynamic productsObj = await api.getPopularWeek(activeBusiness.id, channelSet.id, token);
          productsObj.forEach((product) {
            terminal.bestSales.add(Product.fromJson(product));
          });
        }
      });
    });

    Terminal activeTerminal;
    if (terminals.length > 0) {
      activeTerminal = terminals.firstWhere((element) => element.active);
    }
    yield state.copyWith(
        activeTerminal: activeTerminal,
        terminalList: terminals,
        isPosLoading: false,
        channelSets: channelSets);
    if (this.isBroadcast) {
      add(FetchProducts(business: activeBusiness));
    }
  }

  Future<dynamic> fetchDaily(Business currentBusiness) {
    return api
        .getDays(currentBusiness.id, GlobalUtils.activeToken.accessToken);
  }

  Future<dynamic> fetchMonthly(Business currentBusiness) {
    return api.getMonths(
        currentBusiness.id, GlobalUtils.activeToken.accessToken);
  }

  Stream<DashboardScreenState> getDaily(Business currentBusiness) async* {
    List<Day> lastMonth = [];
    var days = await fetchDaily(currentBusiness);
    days.forEach((day) {
      lastMonth.add(Day.fromJson(day));
    });
    yield state.copyWith(lastMonth: lastMonth);
    yield* getMonthly(currentBusiness);
  }

  Stream<DashboardScreenState> getMonthly(Business currentBusiness) async* {
    List<Month> lastYear = [];
    List<double> monthlySum = [];
    var months = await fetchMonthly(currentBusiness);
    months.forEach((month) {
      lastYear.add(Month.fromJson(month));
    });
    num sum = 0;
    for (int i = (lastYear.length - 1); i >= 0; i--) {
      sum += lastYear[i].amount;
      monthlySum.add(sum.toDouble());
    }

    yield state.copyWith(lastYear: lastYear, monthlySum: monthlySum);
    yield* getTotal(currentBusiness);
  }

  Stream<DashboardScreenState> getTotal(Business currentBusiness) async* {
    dynamic response = await api.getTransactionList(
        currentBusiness.id, GlobalUtils.activeToken.accessToken, '');
    yield state.copyWith(total: Transaction.fromJson(response).paginationData.amount.toDouble());

    add(FetchShops(business: currentBusiness));
  }


  Stream<DashboardScreenState> getTutorials(Business currentBusiness) async* {
    dynamic response = await api.getTutorials(GlobalUtils.activeToken.accessToken, currentBusiness.id);
    List<Tutorial> tutorials = [];
    response.forEach((element) {
      tutorials.add(Tutorial.map(element));
    });
    yield state.copyWith(tutorials: tutorials);
    add(FetchNotifications());
  }

  Stream<DashboardScreenState> getConnects(Business currentBusiness) async* {
    dynamic response = await api.getNotInstalledByCountry(GlobalUtils.activeToken.accessToken, currentBusiness.id);
    List<ConnectModel> connects = [];
    response.forEach((element) {
      connects.add(ConnectModel.toMap(element));
    });
    yield state.copyWith(connects: connects);
    yield* fetchPosProducts();
  }

  Stream<DashboardScreenState> getProductsPopularMonthRandom(Business currentBusiness) async* {
    List<Products> lastSales = [];
    dynamic response = await api.getProductsPopularMonthRandom(currentBusiness.id, GlobalUtils.activeToken.accessToken);
    response.forEach((element) {
      lastSales.add(Products.toMap(element));
    });
    yield state.copyWith(lastSalesRandom: lastSales);
    add(FetchConnects(business: currentBusiness));
  }

  Stream<DashboardScreenState> getShops(Business currentBusiness) async* {
    List<ShopModel> shops = [];
    dynamic response = await api.getShops(currentBusiness.id, GlobalUtils.activeToken.accessToken);
    if (response is List) {
      response.forEach((element) {
        shops.add(ShopModel.fromJson(element));
      });
    }
    ShopModel activeShop;
    if (shops.length > 0) {
      activeShop = shops.firstWhere((element) => element.active);
    }

    yield state.copyWith(shops: shops, activeShop: activeShop);
    add(FetchPosEvent(business: currentBusiness));
  }

  Stream<DashboardScreenState> fetchNotifications() async* {
    yield state.copyWith(notifications: {});
    Map<String, List<NotificationModel>> notifications = {};
    dynamic response = await api.getNotifications(GlobalUtils.activeToken.accessToken, 'business', state.activeBusiness.id, 'dashboard');
    response.forEach((noti) {
      NotificationModel notificationModel = NotificationModel.fromMap(noti);
      String app = notificationModel.app;
      if (notifications.containsKey(app)) {
        List<NotificationModel> list = [];
        list.addAll(notifications[app]);
        list.add(notificationModel);
        notifications[app] = list;
      } else {
        notifications[app] = [notificationModel];
      }
    });
    yield state.copyWith(notifications: notifications);

    dynamic shopsResponse = await api.getNotifications(GlobalUtils.activeToken.accessToken, 'business', state.activeBusiness.id, 'shops');
    if (shopsResponse is List) {
      List<NotificationModel> notiArr = [];
      shopsResponse.forEach((noti) {
        notiArr.add(NotificationModel.fromMap(noti));
      });
      if (notiArr.length > 0) {
        notifications['shops'] = notiArr;
      }
      yield state.copyWith(notifications: notifications);
    }

    dynamic mailResponse = await api.getNotifications(GlobalUtils.activeToken.accessToken, 'business', state.activeBusiness.id, 'mail');
    if (mailResponse is List) {
      List<NotificationModel> notiArr = [];
      mailResponse.forEach((noti) {
        notiArr.add(NotificationModel.fromMap(noti));
      });
      if (notiArr.length > 0) {
        notifications['mail'] = notiArr;
      }
      yield state.copyWith(notifications: notifications);
    }

    dynamic posResponse = await api.getNotifications(GlobalUtils.activeToken.accessToken, 'business', state.activeBusiness.id, 'pos');
    if (posResponse is List) {
      List<NotificationModel> notiArr = [];
      posResponse.forEach((noti) {
        notiArr.add(NotificationModel.fromMap(noti));
      });
      if (notiArr.length > 0) {
        notifications['pos'] = notiArr;
      }
      yield state.copyWith(notifications: notifications);
    }
  }

  Stream<DashboardScreenState> deleteNotification(String notificationId) async* {
    dynamic response = await api.deleteNotification(GlobalUtils.activeToken.accessToken, notificationId);
    yield* fetchNotifications();
  }

  Stream<DashboardScreenState> watchTutorial(Tutorial tutorial) async* {
    dynamic response = await api.patchTutorials(GlobalUtils.activeToken.accessToken, state.activeBusiness.id, tutorial.id);
    add(FetchTutorials(business: state.activeBusiness));
  }

  Stream<DashboardScreenState> installBusinessApp(BusinessApps businessApp) async* {
    yield state.copyWith(installBusinessAppId: businessApp.id);
    dynamic response = await api.toggleInstalled(GlobalUtils.activeToken.accessToken, state.activeBusiness.id, businessApp.microUuid, isInstall: !businessApp.installed);
    if (response is DioError) {
      yield state.copyWith(installBusinessAppId: '');
    } else {
        List<BusinessApps>businessAppsList = state.businessWidgets;
        int index = businessAppsList.indexWhere((element) => element.id == businessApp.id);
        businessAppsList[index].installed = !businessApp.installed;
        print('current element index: $index');
        yield state.copyWith(installBusinessAppId: '', businessWidgets: businessAppsList);
    }
  }

  Stream<DashboardScreenState> installWidget(AppWidget appWidget) async* {
    yield state.copyWith(installBusinessAppId: appWidget.id);
    dynamic response = await api.installWidget(GlobalUtils.activeToken.accessToken, state.activeBusiness.id, appWidget.id, !appWidget.install);
    if (response is DioError) {
      yield state.copyWith(installBusinessAppId: '');
    } else {
      List<AppWidget>appWidgets = state.currentWidgets;
      int index = appWidgets.indexWhere((element) => element.id == appWidget.id);
      appWidgets[index].installed = !appWidget.install;
      yield state.copyWith(installBusinessAppId: '', currentWidgets: appWidgets);
    }
  }
}