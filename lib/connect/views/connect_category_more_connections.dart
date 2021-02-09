
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/widgets/connect_grid_item.dart';
import 'package:payever/connect/widgets/connect_list_item.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/theme.dart';

import 'connect_detail_screen.dart';
import 'connect_payment_settings_screen.dart';
import 'connect_setting_screen.dart';

class ConnectCategoryMoreScreen extends StatefulWidget {
  final List<ConnectModel> connections;
  final ConnectDetailScreenBloc screenBloc ;

  ConnectCategoryMoreScreen({
    this.connections,
    this.screenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _ConnectCategoryMoreScreenState();
  }
}

class _ConnectCategoryMoreScreenState extends State<ConnectCategoryMoreScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;
  static int selectedStyle = 1;
  List<ConnectPopupButton> appBarPopUpActions(BuildContext context, ConnectDetailScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getProductListStrings('list_view'),
        icon: SvgPicture.asset('assets/images/list.svg'),
        onTap: () async {
          setState(() {
            selectedStyle = 0;
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('grid_view'),
        icon: SvgPicture.asset('assets/images/grid.svg'),
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
    super.initState();
  }

  @override
  void dispose() {
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
      bloc: widget.screenBloc,
      listener: (BuildContext context, ConnectDetailScreenState state) async {
        if (state is ConnectScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ConnectDetailScreenBloc, ConnectDetailScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ConnectDetailScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(ConnectDetailScreenState state) {
    String itemsString = '${widget.connections.length} ${Language.getWidgetStrings('widgets.store.product.items')}';
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            itemsString,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<ConnectPopupButton>(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: selectedStyle == 0 ? SvgPicture.asset('assets/images/list.svg'): SvgPicture.asset('assets/images/grid.svg'),
            ),
            offset: Offset(0, 100),
            onSelected: (ConnectPopupButton item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: overlayBackground(),
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
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(ConnectDetailScreenState state) {
    return selectedStyle == 0
        ? _getListBody(state)
        : _getGridBody(state);
  }

  Widget _getListBody(ConnectDetailScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            padding: EdgeInsets.only(left: 24, right: 24),
            color: overlayColor(),
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
                _isTablet || !_isPortrait ? Container(
                  width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
                _isTablet || !_isPortrait ? Container(
                  width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                  child: Text(
                    'Developer',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
                _isTablet || !_isPortrait ? Container(
                  width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                  child: Text(
                    'Languages',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
                Container(
                  width: !_isTablet && _isPortrait ? null : Measurements.width * (_isTablet ? (_isPortrait ? 0.15 : 0.2) : (_isPortrait ? null: 0.35)),
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
                  connectModel: widget.connections[index],
                  isPortrait: _isPortrait,
                  isTablet: _isTablet,
                  installingConnect: state.categoryConnects[index].integration.name == state.installingConnect,
                  onOpen: (model) {
                    if (model.integration.category == 'payments') {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: ConnectPaymentSettingsScreen(
                            connectScreenBloc: widget.screenBloc.connectScreenBloc,
                            connectModel: model,
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
                            screenBloc: widget.screenBloc.connectScreenBloc,
                            connectIntegration: model.integration,
                          ),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    }
                  },
                  onInstall: (model) {
                    widget.screenBloc.add(InstallMoreConnectEvent(model: model));
                  },
                  onUninstall: (model) {
                    widget.screenBloc.add(UninstallMoreConnectEvent(model: model));
                  },
                  onTap: (model) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ConnectDetailScreen(
                          screenBloc: widget.screenBloc.connectScreenBloc,
                          connectModel: widget.connections[index],
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
              itemCount: widget.connections.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGridBody(ConnectDetailScreenState state) {
    int crossAxisCount = _isTablet ? (_isPortrait ? 2 : 3): (_isPortrait ? 1 : 2);
    double imageRatio= 323.0 / 182.0;
    double contentHeight = 116;
    double cellWidth = _isPortrait ? (Measurements.width - 44) / crossAxisCount : (Measurements.height - 56) / crossAxisCount;
    double imageHeight = cellWidth / imageRatio;
    double cellHeight = imageHeight + contentHeight;
    print('$cellWidth,  $cellHeight, $imageHeight  => ${cellHeight / cellWidth}');
    if (widget.connections.length == 0) {
      return Container();
    }
    return Container(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        childAspectRatio: cellWidth / cellHeight,
        children: widget.connections.map((installation) {
          return ConnectGridItem(
            connectModel: installation,
            installingConnect: installation.integration.name == state.installingConnect,
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: ConnectDetailScreen(
                    screenBloc: widget.screenBloc.connectScreenBloc,
                    connectModel: installation,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            onInstall: (model) {
              widget.screenBloc.add(InstallMoreConnectEvent(model: model));
            },
            onUninstall: (model) {
              widget.screenBloc.add(UninstallMoreConnectEvent(model: model));
            },
          );
        }).toList(),
      ),
    );
  }
}