
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/views/connect_payment_settings_screen.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/views/connect_category_more_connections.dart';
import 'package:payever/connect/views/connect_reviews_screen.dart';
import 'package:payever/connect/views/connect_version_history_screen.dart';
import 'package:payever/connect/widgets/connect_item_image_view.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/theme.dart';

import 'connect_add_reviews_screen.dart';
import 'connect_setting_screen.dart';

class ConnectDetailScreen extends StatefulWidget {
  final ConnectModel connectModel;
  final ConnectScreenBloc screenBloc;

  ConnectDetailScreen({
    this.connectModel,
    this.screenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _ConnectDetailScreenState();
  }
}

class _ConnectDetailScreenState extends State<ConnectDetailScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;
  bool installed = false;

  ConnectDetailScreenBloc screenBloc;
  List<ConnectPopupButton> uninstallPopUp(BuildContext context, ConnectDetailScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getConnectStrings('actions.uninstall'),
        onTap: () async {
          screenBloc.add(UninstallEvent());
        },
      ),
    ];
  }

  List<ConnectPopupButton> uninstallConnectPopUp(BuildContext context, ConnectDetailScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getConnectStrings('actions.uninstall'),
        onTap: (connect) async {
          screenBloc.add(UninstallMoreConnectEvent(model: connect));
        },
      ),
    ];
  }

  @override
  void initState() {
    screenBloc = ConnectDetailScreenBloc(connectScreenBloc: widget.screenBloc);
    screenBloc.add(ConnectDetailScreenInitEvent(business: widget.screenBloc.state.business, connectModel: widget.connectModel,));
    super.initState();
    setState(() {
      installed = widget.connectModel.installed;
    });
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
      listener: (BuildContext context, ConnectDetailScreenState state) async {
        if (state is ConnectDetailScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ConnectDetailScreenState) {
          if (state.installed != installed) {
            setState(() {
              installed = state.installed;
            });
            showInstalledDialog(state.installed, widget.connectModel);
          } else if (state.installedNewConnect != '') {
            List<ConnectModel> models = state.categoryConnects;
            List list = models.where((element) => element.integration.name == state.installedNewConnect).toList();
            if (list.length > 0) {
              showInstalledDialog(true, list.first);
            }
          } else if (state.uninstalledNewConnect != '') {
            List<ConnectModel> models = state.categoryConnects;
            List list = models.where((element) => element.integration.name == state.uninstalledNewConnect).toList();
            if (list.length > 0) {
              showInstalledDialog(false, list.first);
            }

          }
        }
      },
      child: BlocBuilder<ConnectDetailScreenBloc, ConnectDetailScreenState>(
        bloc: screenBloc,
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
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            state.editConnect != null ? Language.getPosConnectStrings(state.editConnect.displayOptions.title): '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
            maxHeight: 32,
            maxWidth: 32,
            minHeight: 32,
            minWidth: 32,
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(ConnectDetailScreenState state) {
    if (state.editConnect == null) {
      return Container();
    }
    String iconType = state.editConnect.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    iconType = iconType.replaceAll('#', '');
    String imageUrl = state.editConnect.installationOptions.links.length > 0
        ? state.editConnect.installationOptions.links.first.url ?? '': '';

    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    double rate = 0;
    List<ReviewModel> reviews = state.editConnect.reviews;
    if (reviews.length > 0) {
      double sum = 0;
      reviews.forEach((element) {
        sum = sum + element.rating;
      });
      rate = sum / reviews.length;
    }
    print(state.installed);
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(margin),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: margin),
                    child: SvgPicture.asset(
                      Measurements.channelIcon(iconType),
                      width: iconSize,
                      color: iconColor(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.displayOptions.title),
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueMed',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.installationOptions.price),
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueLight',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.installationOptions.developer),
                                      style: TextStyle(
                                        fontFamily: 'Helvetica Neue',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _isTablet || !_isPortrait ? Container(
                              child: state.installed ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (widget.connectModel.integration.category == 'payments') {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: ConnectPaymentSettingsScreen(
                                                connectScreenBloc: widget.screenBloc,
                                                connectModel: widget.connectModel,
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
                                                screenBloc: widget.screenBloc,
                                                connectIntegration: state.editConnect,
                                              ),
                                              type: PageTransitionType.fade,
                                              duration: Duration(milliseconds: 500),
                                            ),
                                          );
                                        }
                                      },
                                      color: overlayBackground(),
                                      height: 26,
                                      minWidth: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      hoverElevation: 0,
                                      child: Text(
                                        Language.getPosConnectStrings('integrations.actions.open'),
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeueMed',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    child: PopupMenuButton<ConnectPopupButton>(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: state.installing ? Container(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ) : SvgPicture.asset('assets/images/more.svg', color: iconColor(),),
                                      ),
                                      offset: Offset(0, 100),
                                      onSelected: (ConnectPopupButton item) => item.onTap(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: overlayBackground(),
                                      itemBuilder: (BuildContext context) {
                                        return uninstallPopUp(context, state)
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
                              ) : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: MaterialButton(
                                      onPressed: () {
                                        screenBloc.add(InstallEvent());
                                      },
                                      color: Color.fromRGBO(255, 255, 255, 0.1),
                                      height: 26,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      minWidth: 0,
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      hoverElevation: 0,
                                      child: state.installing ? Container(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ) : Text(
                                        Language.getPosConnectStrings('integrations.actions.install'),
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeueMed',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ): Container(),
                          ],
                        ),
                        _isTablet || !_isPortrait
                            ? Container()
                            : Container(
                          child: state.installed ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(0),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (widget.connectModel.integration.category == 'payments') {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: ConnectPaymentSettingsScreen(
                                            connectScreenBloc: widget.screenBloc,
                                            connectModel: widget.connectModel,
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
                                            screenBloc: widget.screenBloc,
                                            connectIntegration: state
                                                .editConnect,
                                          ),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 500),
                                        ),
                                      );
                                    }
                                  },
                                  color: overlayBackground(),
                                  height: 26,
                                  minWidth: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  elevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  hoverElevation: 0,
                                  child: Text(
                                    Language.getPosConnectStrings('integrations.actions.open'),
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeueMed',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                child: PopupMenuButton<ConnectPopupButton>(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: state.installing ? Container(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ) : SvgPicture.asset('assets/images/more.svg', color: iconColor(),),
                                  ),
                                  offset: Offset(0, 100),
                                  onSelected: (ConnectPopupButton item) => item.onTap(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: overlayBackground(),
                                  itemBuilder: (BuildContext context) {
                                    return uninstallPopUp(context, state)
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
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 16),
                                child: MaterialButton(
                                  onPressed: () {
                                    screenBloc.add(InstallEvent());
                                  },
                                  color: overlayColor().withOpacity(0.1),
                                  height: 26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  minWidth: 0,
                                  elevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  hoverElevation: 0,
                                  child: state.installing ? Container(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ) : Text(
                                    Language.getPosConnectStrings('integrations.actions.install'),
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeueMed',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 24,
                          thickness: 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            state.editConnect.reviews.length > 0 ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '$rate',
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueMed',
                                        fontSize: 21,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: margin / 4),
                                    ),
                                    _rateView(rate),
                                  ],
                                ),
                                Text(
                                  Language.getPosConnectStrings('${state.editConnect.reviews.length} Ratings'),
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueLight',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ) : Text(
                              'No rating',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueMed',
                                fontSize: 16,
                              ),
                            ),
                            _isTablet || !_isPortrait ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${state.editConnect.timesInstalled ?? 0}',
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueMed',
                                    fontSize: 21,
                                  ),
                                ),
                                Text(
                                  Language.getPosConnectStrings('Times Downloaded'),
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueLight',
                                    fontSize: 12,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                              ],
                            ): Container(),
                          ],
                        ),
                        _isTablet || !_isPortrait ? Container()
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Text(
                              '${state.editConnect.timesInstalled ?? 0}',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueMed',
                                fontSize: 21,
                              ),
                            ),
                            Text(
                              Language.getPosConnectStrings('Times Downloaded'),
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.all(margin),
              child: ConnectItemImageView(
                imageUrl,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: margin, right: margin),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Language.getPosConnectStrings(state.editConnect.installationOptions.description),
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(margin),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Language.getPosConnectStrings(state.editConnect.installationOptions.developer),
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              Language.getConnectStrings('installation.labels.website'),
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SvgPicture.asset('assets/images/website.svg', color: iconColor(),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              Language.getConnectStrings('Support'),
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SvgPicture.asset('assets/images/support.svg', color: iconColor(),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Divider(
              height: margin,
              thickness: 0.5,
              endIndent: margin,
              indent: margin,
            ),

            _ratingView(state),

            Divider(
              height: margin,
              thickness: 0.5,
              endIndent: margin,
              indent: margin,
            ),

            _versions(state),

            Divider(
              height: margin,
              thickness: 0.5,
              endIndent: margin,
              indent: margin,
            ),

            _informations(state),

            _information2(state),

            Divider(
              height: margin,
              thickness: 0.5,
              endIndent: margin,
              indent: margin,
            ),

            _supported(state),

            Divider(
              height: margin,
              thickness: 0.5,
              endIndent: margin,
              indent: margin,
            ),

            _morePayever(state),
          ],
        ),
      ),
    );
  }

  Widget _ratingView(ConnectDetailScreenState state) {
    double rate = 0;
    List<ReviewModel> reviews = state.editConnect.reviews;
    if (reviews.length > 0) {
      double sum = 0;
      reviews.forEach((element) {
        sum = sum + element.rating;
      });
      rate = sum / reviews.length;
    }
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    } else {
      if (_isPortrait) {
        count = 1;
      } else {
        count = 2;
      }
    }
    int length = 2;
    if (_isTablet) {
      length = count;
    } else {
      length = 2;
    }

    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Language.getConnectStrings('Ratings & Reviews'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
              reviews.length > 0 ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectReviewsScreen(
                        screenBloc: screenBloc,
                        connectModel: widget.connectModel.integration,
                        installed: widget.connectModel.installed,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('See All'),
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ): GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectAddReviewsScreen(
                        screenBloc: screenBloc,
                        connectIntegration: state.editConnect,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('Write Review'),
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          reviews.length > 0 ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              rate > 0 ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$rate',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueMed',
                      fontSize: 60,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'out of 5',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueBold',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ): Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${reviews.length} Ratings',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                  !_isTablet && _isPortrait ? Container() : Padding(
                    padding: EdgeInsets.only(right: margin / 2),
                  ),
                  !_isTablet && _isPortrait ? Container() : _allRateView(state),
                ],
              ),
            ],
          ): Container(
            child: Text(
              'No rating',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'HelveticaNeueMed',
              ),
            ),
          ),
          !_isTablet && _isPortrait ? _allRateView(state): Container(),
          Flexible(
            fit: FlexFit.loose,
            child: reviews.length == 0 ? Container(): GridView.count(
              padding: EdgeInsets.only(top: 16,),
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: margin,
              shrinkWrap: true,
              childAspectRatio: 3,
              crossAxisCount: count,
              children: reviews.map((review) {
                return Container(
                  height: 200,
                  padding: EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: overlayBackground(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                review.title ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeueMed',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: margin / 4),
                              ),
                              _rateView(review.rating),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                review.reviewDate ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Helvetica Neue',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: margin / 4),
                              ),
                              Text(
                                review.userFullName ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Helvetica Neue',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: margin / 2),
                      ),
                      Text(
                        review.text ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList().sublist(0, reviews.length > length ? length: reviews.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateView(num rate) {
    return Container(
      child: Row(
        children: List.generate(5, (index) {
          return Container(
            child: SvgPicture.asset(
              index < rate ? 'assets/images/star_fill.svg'
                  : 'assets/images/star_outline.svg',
              width: 14,
              height: 14,
              color: iconColor(),
            ),
          );
        }).toList()
      ),
    );
  }

  Widget _allRateView(ConnectDetailScreenState state) {
    if (state.editConnect.reviews.length == 0) {
      return Container();
    }
    double width = Measurements.width;
    if (!_isTablet) {
      width = Measurements.width - margin * 6;
    } else {
      width = (Measurements.width - margin * 4) / 2;
    }
    List<Map<int, double>> percents = [];
    List<ReviewModel> reviews = state.editConnect.reviews;
    List.generate(5, (index) {
      num count = 0;
      reviews.forEach((element) {
        if (element.rating == (index + 1)) {
          count++;
        }
      });
      percents.add({
        index + 1: count.toDouble() / reviews.length.toDouble()
      });
    });
    percents = percents.reversed.toList();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: percents.map((p) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: List.generate(p.keys.toList().first, (index) {
                    return SvgPicture.asset(
                      'assets/images/star_fill.svg',
                      width: margin / 2,
                      height: margin / 2,
                      color: iconColor(),
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(right: margin / 2),
                ),
                Container(
                  width: width,
                  child: SizedBox(
                    height: margin / 5,
                    child: LinearProgressIndicator(
                      value: p.values.first,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _versions(ConnectDetailScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                Language.getConnectStrings('What\'s New'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectVersionHistoryScreen(
                        screenBloc: screenBloc,
                        connectModel: widget.connectModel,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('Version History'),
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _informations(ConnectDetailScreenState state) {
    List<InformationData> informations = [];

    if (state.editConnect.installationOptions.developer != null) {
      informations.add(InformationData(title: 'Provider', detail: Language.getPosConnectStrings(state.editConnect.installationOptions.developer)));
    }
    if (state.editConnect.installationOptions.category != null) {
      informations.add(InformationData(title: 'Category' , detail: Language.getConnectStrings('categories.${state.editConnect.category}.title')));
    }
    if (state.editConnect.installationOptions.languages != null) {
      informations.add(InformationData(title: 'Languages' , detail: Language.getPosConnectStrings(state.editConnect.installationOptions.languages)));
    }
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 3;
      } else {
        count = 4;
      }
    } else {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    }
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            Language.getConnectStrings('Informations'),
            style: TextStyle(
              fontFamily: 'HelveticaNeueMed',
              fontSize: 18,
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.count(
              padding: EdgeInsets.only(top: 16,),
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: margin,
              shrinkWrap: true,
              childAspectRatio: 4,
              crossAxisCount: count,
              children: informations.map((info) {
                return Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        info.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                      Text(
                        info.detail,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _information2(ConnectDetailScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Divider(
                  height: margin,
                  thickness: 0.5,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/website.svg', color: iconColor(),),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Expanded(
                      child: Text(
                        'Developer Website',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: margin),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Divider(
                  height: margin,
                  thickness: 0.5,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/privacy.svg', color: iconColor(),),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Expanded(
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: margin),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Divider(
                  height: margin,
                  thickness: 0.5,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/description.svg', color: iconColor(),),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Expanded(
                      child: Text(
                        'Licence Agreement',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supported(ConnectDetailScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            Language.getConnectStrings('Supported'),
            style: TextStyle(
              fontFamily: 'HelveticaNeueMed',
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/images/account.svg', color: iconColor(),),
              Padding(
                padding: EdgeInsets.only(left: margin / 2),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Language.getConnectStrings('Title'),
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _morePayever(ConnectDetailScreenState state) {
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    } else {
      if (_isPortrait) {
        count = 1;
      } else {
        count = 2;
      }
    }
//    double width = (Measurements.width - margin * 2) / count - (count - 1) * margin / 2;
//    double ratio = width / (min(Measurements.width, Measurements.height) * 0.2);
    int length = 6;
    if (_isTablet) {
      length = 6;
    } else {
      length = 4;
    }
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Language.getConnectStrings('More by payever'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
              state.categoryConnects.length > length ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectCategoryMoreScreen(
                        screenBloc: screenBloc,
                        connections: state.categoryConnects,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('See All'),
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ): Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          state.categoryConnects.length > 0 ? Flexible(
            fit: FlexFit.loose,
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              childAspectRatio: 3,
              mainAxisSpacing: margin / 2,
              crossAxisSpacing: margin / 2,
              children: state.categoryConnects.map((connect) {
                String iconType = connect.integration.displayOptions.icon ?? '';
                iconType = iconType.replaceAll('#icon-', '');
                iconType = iconType.replaceAll('#', '');
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: margin),
                        child: SvgPicture.asset(
                          Measurements.channelIcon(iconType),
                          width: iconSize * 0.6,
                          color: iconColor(),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  Language.getPosConnectStrings(connect.integration.displayOptions.title),
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueMed',
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  Language.getConnectStrings('categories.${connect.integration.category}.title'),
                                  style: TextStyle(
                                    fontFamily: 'Helvetica Neue',
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  child: connect.installed ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (widget.connectModel.integration.category == 'payments') {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  child: ConnectPaymentSettingsScreen(
                                                    connectScreenBloc: widget.screenBloc,
                                                    connectModel: widget.connectModel,
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
                                                    screenBloc: widget.screenBloc,
                                                    connectIntegration: connect.integration,
                                                  ),
                                                  type: PageTransitionType.fade,
                                                  duration: Duration(milliseconds: 500),
                                                ),
                                              );
                                            }
                                          },
                                          color: overlayBackground(),
                                          height: 26,
                                          minWidth: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          hoverElevation: 0,
                                          child: Text(
                                            Language.getPosConnectStrings('integrations.actions.open'),
                                            style: TextStyle(
                                              fontFamily: 'HelveticaNeueMed',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        child: PopupMenuButton<ConnectPopupButton>(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: state.installingConnect == connect.integration.name ? Center(
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            ) : SvgPicture.asset('assets/images/more.svg', color: iconColor(),),
                                          ),
                                          offset: Offset(0, 100),
                                          onSelected: (ConnectPopupButton item) => item.onTap(connect),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          color: overlayBackground(),
                                          itemBuilder: (BuildContext context) {
                                            return uninstallConnectPopUp(context, state)
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
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(right: 16),
                                        child: MaterialButton(
                                          onPressed: () {
                                            screenBloc.add(InstallMoreConnectEvent(model: connect));
                                          },
                                          color: overlayBackground(),
                                          height: 26,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          minWidth: 0,
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          hoverElevation: 0,
                                          child: state.installingConnect == connect.integration.name ? Container(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ) : Text(
                                            Language.getPosConnectStrings('integrations.actions.install'),
                                            style: TextStyle(
                                              fontFamily: 'HelveticaNeueMed',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: margin,
                                  thickness: 0.5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList().sublist(0, state.categoryConnects.length > length ? length: state.categoryConnects.length),
            ),
          ): Container(),
        ],
      ),
    );
  }

  void showInstalledDialog(bool install, ConnectModel model) {
/*    "installation.installed.title": "Installed",
    "installation.installed.description": "You have successfully installed {{ title }}!<br>\nPlease connect you payment account to payever.",
    "installation.uninstalled.title": "Uninstalled",
    "installation.uninstalled.description": "You are successfully disconnected from \"{{ title }}\" now!",*/
    screenBloc.add(ClearEvent());
    String detail = install ? Language.getConnectStrings('installation.installed.description')
        : Language.getConnectStrings('installation.uninstalled.description');
    if (install) {
      detail = detail.replaceAll('{{ title }}!<br>', Language.getPosConnectStrings(model.integration.displayOptions.title));
    } else {
      detail = detail.replaceAll('\"{{ title }}\"', Language.getPosConnectStrings(model.integration.displayOptions.title));
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
              color: Color.fromRGBO(50, 50, 50, 0.4),
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
                    Language.getConnectStrings(install ? 'installation.installed.title': 'installation.uninstalled.title'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (install) {
                            if (widget.connectModel.integration.category == 'payments') {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ConnectPaymentSettingsScreen(
                                    connectScreenBloc: widget.screenBloc,
                                    connectModel: widget.connectModel,
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
                                    screenBloc: widget.screenBloc,
                                    connectIntegration: model.integration,
                                  ),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
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
                          install ? Language.getPosConnectStrings('integrations.actions.open') : Language.getConnectStrings('actions.close'),
                        ),
                      ),
                    ],
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