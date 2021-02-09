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
import 'package:payever/theme.dart';

class ConnectVersionHistoryScreen extends StatefulWidget {
  final ConnectModel connectModel;
  final ConnectDetailScreenBloc screenBloc;

  ConnectVersionHistoryScreen({
    this.connectModel,
    this.screenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _ConnectVersionHistoryScreenState();
  }
}

class _ConnectVersionHistoryScreenState extends State<ConnectVersionHistoryScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;

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
            Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title),
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
    String iconType = widget.connectModel.integration.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    iconType = iconType.replaceAll('#', '');
    String imageUrl = widget.connectModel.integration.installationOptions.links.length > 0
        ? widget.connectModel.integration.installationOptions.links.first.url ?? '': '';

    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title),
                            style: TextStyle(
                              fontFamily: 'HelveticaNeueMed',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            Language.getPosConnectStrings(widget.connectModel.integration.installationOptions.price),
                            style: TextStyle(
                              fontFamily: 'HelveticaNeueLight',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            Language.getPosConnectStrings(widget.connectModel.integration.installationOptions.developer),
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: margin,
              thickness: 0.5,
              indent: margin,
              endIndent: margin,
            ),
          ],
        ),
      ),
    );
  }

}