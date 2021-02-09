import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/payever_bloc_delegate.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/standard_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'commons/view_models/view_models.dart';
import 'commons/utils/utils.dart';
import 'commons/network/network.dart';
import 'dashboard/dashboard_screen.dart';
import 'login/login_screen.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

void main() async {
  BlocSupervisor.delegate = PayeverBlocDelegate();
  Provider.debugCheckInvalidValueType = null;

  DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        GlobalUtils.isConnected = true;
        print('Data connection: is available.');
        break;
      case DataConnectionStatus.disconnected:
        print('Data connection: You are disconnected from the internet.');
        GlobalUtils.isConnected = false;
        break;
      default:
        GlobalUtils.isConnected = false;
        print('Data connection: You are disconnected from the internet.');
        break;
    }
  });
  // var isDeviceConnected = false;
  // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
  //   if(result != ConnectivityResult.none) {
  //     isDeviceConnected = await DataConnectionChecker().hasConnection;
  //     Fluttertoast.showToast(msg: 'Connection is $isDeviceConnected.');
  //     print('Data connection1 $isDeviceConnected.');
  //   }
  // });
  runApp(PayeverApp());
}

class PayeverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences preferences;
  var _loadCredentials = ValueNotifier(true);
  bool _haveCredentials;
  String wallpaper;

  GlobalStateModel globalStateModel = GlobalStateModel();

  @override
  void initState() {
    super.initState();
    _loadCredentials.addListener(listener);
    _storedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    StandardData(context);
    Language(context);
    return MultiProvider(
      providers: [
        Provider.value(value: globalStateModel),
        Provider.value(value: RestDataSource()),
        ChangeNotifierProvider<GlobalStateModel>(
            create: (BuildContext context) => globalStateModel),
        ChangeNotifierProvider<PosCartStateModel>(
            create: (BuildContext context) => PosCartStateModel()),
        ChangeNotifierProvider<ProductStateModel>(
            create: (BuildContext context) => ProductStateModel()),
        BlocProvider<ChangeThemeBloc>(
          create: (BuildContext context) => ChangeThemeBloc(),
        ),
      ],
      child: BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
        builder: (context, state) {
          if (state.theme == null) {
            BlocProvider.of<ChangeThemeBloc>(context)..add(DecideTheme());
          }
          GlobalUtils.currentContext = context;
          print(state.theme);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'payever',
            darkTheme: state.themeData,
            theme: state.themeData,
            home: _loadCredentials.value
                ? Center(child: CircularProgressIndicator())
                : _haveCredentials ? DashboardScreenInit(refresh: false,) : LoginInitScreen(),
          );
        },
      ),
    );
  }

  _storedCredentials() async {
    String fingerPrint = '${Platform.operatingSystem}  ${Platform.operatingSystemVersion}';


    preferences = await SharedPreferences.getInstance();
    wallpaper = preferences.getString(GlobalUtils.WALLPAPER) ?? '';
    String bus = preferences.getString(GlobalUtils.BUSINESS) ?? '';
    String rfToken = preferences.getString(GlobalUtils.REFRESH_TOKEN) ?? '';
    GlobalUtils.fingerprint = preferences.getString(GlobalUtils.FINGERPRINT) ?? fingerPrint;
    print('Refresh Token $rfToken');
    print('Finger print ${GlobalUtils.fingerprint}');

    _loadCredentials.value = false;
    _haveCredentials = rfToken.isNotEmpty && bus.isNotEmpty;
  }

  void listener() {
    setState(() {});
  }

}
