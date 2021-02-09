import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/views/connect_detail_screen.dart';
import 'package:payever/connect/views/connect_setting_screen.dart';
import 'package:payever/connect/widgets/connect_grid_item.dart';
import 'package:payever/connect/widgets/connect_list_item.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';

import 'connect_categories_screen.dart';
import 'connect_payment_settings_screen.dart';

class ConnectInitScreen extends StatelessWidget {
  final List<Connect> connectModels;
  final Connect activeConnect;
  final DashboardScreenBloc dashboardScreenBloc;

  ConnectInitScreen({
    this.connectModels,
    this.activeConnect,
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ConnectScreen(
      globalStateModel: globalStateModel,
      connectModels: connectModels,
      activeConnect: activeConnect,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ConnectScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final List<Connect> connectModels;
  final Connect activeConnect;
  final DashboardScreenBloc dashboardScreenBloc;

  ConnectScreen({
    this.dashboardScreenBloc,
    this.activeConnect,
    this.connectModels,
    this.globalStateModel,
  });

  @override
  createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool _isPortrait;
  bool _isTablet;
  bool openCategory = false;

  ConnectScreenBloc screenBloc;
  static int selectedStyle = 1;

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  double iconSize;
  double margin;

  List<ConnectPopupButton> appBarPopUpActions(
      BuildContext context, ConnectScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getProductListStrings('list_view'),
        icon: SvgPicture.asset(
          'assets/images/list.svg',
          color: iconColor(),
        ),
        onTap: () async {
          setState(() {
            selectedStyle = 0;
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('grid_view'),
        icon: SvgPicture.asset(
          'assets/images/grid.svg',
          color: iconColor(),
        ),
        onTap: () async {
          setState(() {
            selectedStyle = 1;
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    screenBloc = ConnectScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
    screenBloc.add(ConnectScreenInitEvent(
      business: widget.globalStateModel.currentBusiness.id,
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
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, ConnectScreenState state) async {
        if (state is ConnectScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
        if (state.installedConnect != '') {
          List<ConnectModel> models = state.connectInstallations;
          List list = models
              .where((element) =>
                  element.integration.name == state.installedConnect)
              .toList();
          if (list.length > 0) {
            showInstalledDialog(true, list.first);
          }
        } else if (state.uninstalledConnect != '') {
          List<ConnectModel> models = state.connectInstallations;
          List list = models
              .where((element) =>
                  element.integration.name == state.uninstalledConnect)
              .toList();
          if (list.length > 0) {
            showInstalledDialog(false, list.first);
          }
        }
      },
      child: BlocBuilder<ConnectScreenBloc, ConnectScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ConnectScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(ConnectScreenState state) {
    iconSize = _isTablet ? 120 : 80;
    margin = _isTablet ? 24 : 16;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title: Language.getConnectStrings('layout.title'),
        icon: SvgPicture.asset(
          'assets/images/connect.svg',
          height: 20,
          width: 20,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    _topBar(state),
                    Expanded(
                      child: _getBody(state),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _topBar(ConnectScreenState state) {
    String itemsString = '';
    if (state.selectedCategory == 'all') {
      itemsString =
          '${state.connectInstallations.length} ${Language.getWidgetStrings('widgets.store.product.items')} in ${state.categories.length}'
          ' ${Language.getProductStrings('category.headings.categories').toLowerCase()}';
    } else {
      itemsString =
          '${state.connectInstallations.length} ${Language.getWidgetStrings('widgets.store.product.items')} in'
          ' ${Language.getConnectStrings('categories.${state.selectedCategory}.title')}';
    }
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  setState(() {
                    openCategory = !openCategory;
                  });
                  if (_isTablet || !_isPortrait) {
                  } else {
                    await showGeneralDialog(
                      barrierColor: null,
                      transitionBuilder: (context, a1, a2, wg) {
                        final curvedValue =
                            1.0 - Curves.ease.transform(a1.value);
                        return Transform(
                          transform: Matrix4.translationValues(
                              -curvedValue * 200, 0.0, 0),
                          child: ConnectCategoriesScreen(
                            screenBloc: screenBloc,
                          ),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 200),
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      pageBuilder: (context, animation1, animation2) {
                        return null;
                      },
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/images/filter.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      itemsString,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<ConnectPopupButton>(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: selectedStyle == 0
                          ? SvgPicture.asset(
                              'assets/images/list.svg',
                            )
                          : SvgPicture.asset(
                              'assets/images/grid.svg',
                            ),
                    ),
                    offset: Offset(0, 100),
                    onSelected: (ConnectPopupButton item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: overlayFilterViewBackground(),
                    itemBuilder: (BuildContext context) {
                      return appBarPopUpActions(context, state)
                          .map((ConnectPopupButton item) {
                        return PopupMenuItem<ConnectPopupButton>(
                          value: item,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: item.icon,
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(ConnectScreenState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        openCategory && (_isTablet || !_isPortrait)
            ? Flexible(
                flex: 1,
                child: ListView.separated(
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    String category = screenBloc.state.categories[index];
                    return GestureDetector(
                      onTap: () {
                        screenBloc
                            .add(ConnectCategorySelected(category: category));
                      },
                      child: Container(
                        height: 44,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: screenBloc.state.selectedCategory == category
                              ? overlayBackground()
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: SvgPicture.asset(
                                Measurements.channelIcon(category),
                                height: 32,

                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Text(
                              Language.getConnectStrings(
                                  'categories.$category.title'),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container();
                  },
                  itemCount: screenBloc.state.categories.length,
                ),
              )
            : Container(),
        openCategory && (_isTablet || !_isPortrait)
            ? Container(
                width: 1,
                color: Colors.grey,
              )
            : Container(),
        Flexible(
          flex: 2,
          child: selectedStyle == 0 ? _getListBody(state) : _getGridBody(state),
        ),
      ],
    );
  }

  Widget _getListBody(ConnectScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            padding: EdgeInsets.only(left: 24, right: 24),
            color: overlayBackground(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'App Name',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                ),
                _isTablet || !_isPortrait
                    ? Container(
                        width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                        child: Text(
                          'Category',
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(),
                _isTablet || !_isPortrait
                    ? Container(
                        width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                        child: Text(
                          'Developer',
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(),
                _isTablet || !_isPortrait
                    ? Container(
                        width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                        child: Text(
                          'Languages',
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  width: !_isTablet && _isPortrait
                      ? null
                      : Measurements.width *
                          (_isTablet
                              ? (_isPortrait ? 0.15 : 0.2)
                              : (_isPortrait ? null : 0.35)),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Price',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ConnectListItem(
                  connectModel: state.connectInstallations[index],
                  isPortrait: _isPortrait,
                  isTablet: _isTablet,
                  installingConnect:
                      state.connectInstallations[index].integration.name ==
                          state.installingConnect,
                  onOpen: (model) {
                    if (model.integration.category == 'payments') {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: ConnectPaymentSettingsScreen(
                            connectScreenBloc: screenBloc,
                            connectModel: model,
                            business:
                                widget.globalStateModel.currentBusiness.id,
                          ),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: ConnectSettingScreen(
                            screenBloc: screenBloc,
                            connectIntegration: model.integration,
                          ),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    }
                  },
                  onInstall: (model) {
                    screenBloc.add(InstallConnectAppEvent(model: model));
                  },
                  onUninstall: (model) {
                    screenBloc.add(UninstallConnectAppEvent(model: model));
                  },
                  onTap: (model) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ConnectDetailScreen(
                          screenBloc: screenBloc,
                          connectModel: state.connectInstallations[index],
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  thickness: 0.5,
                );
              },
              itemCount: state.connectInstallations.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGridBody(ConnectScreenState state) {
    int crossAxisCount =
        _isTablet ? (_isPortrait ? 3 : 3) : (_isPortrait ? 2 : 3);
    double imageRatio = 323.0 / 182.0;
    double contentHeight = 116;
    double cellWidth = _isPortrait
        ? (Measurements.width - 44) / crossAxisCount
        : (Measurements.height - 56) / crossAxisCount;
    double imageHeight = cellWidth / imageRatio;
    double cellHeight = imageHeight + contentHeight;
    print(
        '$cellWidth,  $cellHeight, $imageHeight  => ${cellHeight / cellWidth}');
    if (state.connectInstallations.length == 0) {
      return Container();
    }
    return Container(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        shrinkWrap: true,
        children: state.connectInstallations.map((installation) {
          return ConnectGridItem(
            connectModel: installation,
            installingConnect:
                installation.integration.name == state.installingConnect,
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: ConnectDetailScreen(
                    screenBloc: screenBloc,
                    connectModel: installation,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            onInstall: (model) {
              screenBloc.add(InstallConnectAppEvent(model: model));
            },
            onUninstall: (model) {
              screenBloc.add(UninstallConnectAppEvent(model: model));
            },
          );
        }).toList(),
      ),
    );
  }

  void showInstalledDialog(bool install, ConnectModel model) {
/*    "installation.installed.title": "Installed",
    "installation.installed.description": "You have successfully installed {{ title }}!<br>\nPlease connect you payment account to payever.",
    "installation.uninstalled.title": "Uninstalled",
    "installation.uninstalled.description": "You are successfully disconnected from \"{{ title }}\" now!",*/
    screenBloc.add(ClearInstallEvent());
    String detail = install
        ? Language.getConnectStrings('installation.installed.description')
        : Language.getConnectStrings('installation.uninstalled.description');
    if (install) {
      detail = detail.replaceAll(
          '{{ title }}!<br>',
          Language.getPosConnectStrings(
              model.integration.displayOptions.title));
    } else {
      detail = detail.replaceAll(
          '\"{{ title }}\"',
          Language.getPosConnectStrings(
              model.integration.displayOptions.title));
    }
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 250,
            width: Measurements.width * 0.8,
            child: BlurEffectView(
              color: overlayBackground(),
              padding: EdgeInsets.all(margin / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  Icon(Icons.check),
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  Text(
                    Language.getConnectStrings(install
                        ? 'installation.installed.title'
                        : 'installation.uninstalled.title'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'HelveticaNeueMed',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  Text(
                    detail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Helvetica Neue',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  install
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (model.integration.category == 'payments') {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ConnectPaymentSettingsScreen(
                                        connectScreenBloc: screenBloc,
                                        connectModel: model,
                                        business: widget.dashboardScreenBloc
                                            .state.activeBusiness.id,
                                      ),
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ConnectSettingScreen(
                                        screenBloc: screenBloc,
                                        connectIntegration: model.integration,
                                      ),
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  );
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                install
                                    ? Language.getPosConnectStrings(
                                        'integrations.actions.open')
                                    : Language.getConnectStrings(
                                        'actions.close'),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getPosStrings('actions.no'),
                              ),
                            ),
                          ],
                        )
                      : MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 24,
                          elevation: 0,
                          minWidth: 0,
                          color: overlayBackground(),
                          child: Text(
                            Language.getConnectStrings('actions.close'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
