import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/dashboard/dashboard_screen.dart';
import 'package:payever/dashboard/fake_dashboard_screen.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

const double _heightFactorTablet = 0.05;
const double _heightFactorPhone = 0.07;
//const double _widthFactorTablet = 2.0;
//const double _widthFactorPhone = 1.1;
//const double _paddingText = 16.0;

bool _isTablet = false;
bool _isPortrait = true;

class SwitcherScreen extends StatefulWidget {
  final bool isLogin;
  SwitcherScreen(this.isLogin);

  @override
  createState() => _SwitcherScreenState();
}

class _SwitcherScreenState extends State<SwitcherScreen> {

  bool isSetLanguage = false;
  SwitcherScreenBloc screenBloc = SwitcherScreenBloc();

  @override
  void initState() {
    super.initState();
    screenBloc.add(SwitcherScreenInitialEvent());
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
      listener: (BuildContext context, SwitcherScreenState state) async {
        if (state is SwitcherScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is SwitcherScreenStateSuccess) {
          Provider.of<GlobalStateModel>(context,listen: false)
              .setCurrentBusiness(state.business);
          Provider.of<GlobalStateModel>(context,listen: false)
              .setCurrentWallpaper('$wallpaperBase${state.wallpaper.currentWallpaper.wallpaper}');
          Navigator.pushReplacement(
              context,
              PageTransition(
                child: DashboardScreenInit(refresh: true,),
                type: PageTransitionType.fade,
              )
          );

        }
      },
      child: BlocBuilder<SwitcherScreenBloc, SwitcherScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, SwitcherScreenState state) {
          if (!isSetLanguage && state.logUser != null) {
            Language.language = state.logUser.language;
            Language(context);
            Measurements.loadImages(context);
            isSetLanguage = true;
          }
          return Stack(
            children: <Widget>[ FakeDashboardScreen(), _body(state),],
          );
        },
      ),
    );
  }
//  NetworkImage(
//  '${Env.cdn}/images/commerceos-background.jpg')
  Widget _body(SwitcherScreenState state) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          AnimatedOpacity(
            child: state.isLoading ? Wait() : Switcher(screenBloc: screenBloc,),
            duration: Duration(milliseconds: 500),
            opacity: 1.0,
          ),
          !widget.isLogin ? SafeArea(
            bottom: false,
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              minWidth: 0,
              shape: CircleBorder(),
              child: SvgPicture.asset('assets/images/closeicon.svg', color: iconColor(),),
            ),
          ): Container()
        ],
      ),
    );
  }
}

class GridItems extends StatefulWidget {
  final Business business;
  final Function onTap;
  final bool isLoading;
  GridItems({this.business, this.onTap, this.isLoading = false});

  @override
  createState() => _GridItemsState();
}

class _GridItemsState extends State<GridItems> {
  double itemsHeight = (Measurements.width * 0.3);

  bool haveImage;
  String imageURL;

  @override
  void initState() {
    super.initState();

    setState(() {
      haveImage = (widget.business.logo == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Measurements.width * 0.25,
      child: InkWell(
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: Measurements.height * 0.01,
                  ),
                  child: CustomCircleAvatar(
                    widget.business.logo != null
                        ? widget.business.logo
                        : 'business',
                    widget.business.name,
                    Measurements.width * 0.08,
                  ),
                ),
                widget.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.business.name,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}

class Wait extends StatefulWidget {
  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}

class Switcher extends StatefulWidget {
  final SwitcherScreenBloc screenBloc;
  Switcher({this.screenBloc});

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool _moreSelected = false;
  bool selectActive = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 700),
          padding: EdgeInsets.only(
              top: (Measurements.height *
                  (!_moreSelected
                      ? (_isTablet ? 0.3 : _isPortrait ? 0.3 : 0.1)
                      : (_isTablet ? 0.1 : _isPortrait ? 0.1 : 0.05)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.screenBloc.state.active != null
                  ? Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'BUSINESS',
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: (Measurements.height *
                                (_isTablet
                                    ? _heightFactorTablet
                                    : _heightFactorPhone)) /
                                3),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CustomCircleAvatar(
                              widget.screenBloc.state.active.logo != null
                                  ? widget.screenBloc.state.active.logo
                                  : 'business',
                              widget.screenBloc.state.active.name,
                              Measurements.width * 0.12,
                            ),
                            selectActive
                                ? Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: Measurements.height * 0.06,
                                  width: Measurements.height * 0.06,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                Container(
                                  child: CircularProgressIndicator(),
                                )
                              ],
                            )
                                : Container(),
                          ],
                        ),
                        onTap: () {
                          print('onIconSelect - business');
                          setState(() {
                            selectActive = true;
                          });
                          widget.screenBloc.add(SwitcherSetBusinessEvent(business: widget.screenBloc.state.active));
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: (Measurements.height *
                                (_isTablet
                                    ? _heightFactorTablet
                                    : _heightFactorPhone)) /
                                3),
                      ),
                      widget.screenBloc.state.businesses.length > 0
                          ? InkWell(
                        highlightColor: Colors.transparent,
                        child: Chip(
                          backgroundColor: overlayBackground(),
                          label: widget.screenBloc.state.businesses.length > 1
                              ? Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                    'All ${widget.screenBloc.state.businesses.length}'),
                                Icon(!_moreSelected
                                    ? IconData(58131, fontFamily: 'MaterialIcons',)
                                    : IconData(58134, fontFamily: 'MaterialIcons',),
                                ),
                              ],
                            ),
                          )
                              : Container(
                            child: Row(
                              children: <Widget>[
                                Text(widget.screenBloc.state.active.name),
                                Icon(!_moreSelected
                                    ? IconData(58131, fontFamily: 'MaterialIcons',)
                                    : IconData(58134, fontFamily: 'MaterialIcons',),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          print('onTextSelect - personal');
                          setState(
                                  () => _moreSelected = !_moreSelected);
                        },
                      )
                          : Container(),
                    ],
                  ),
              )
                  : Container(),
            ],
          ),
        ),
        !_moreSelected
            ? Container()
            : Expanded(
          child: CustomGrid(
            screenBloc: widget.screenBloc,
          ),
        ),
      ],
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  final String url;
  final String name;
  final double avatarSoze;

  CustomCircleAvatar(this.url, this.name, this.avatarSoze);

  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    bool _haveImage;
    String displayName;
    double size = Measurements.height * 0.04;
    if (avatarSoze != null) {
      size = avatarSoze;
    }
    if (url.contains('user') || url.contains('business')) {
      _haveImage = false;
      if (name.contains(' ')) {
        displayName = name.substring(0, 1);
        displayName = displayName + name.split(' ')[1].substring(0, 1);
      } else {
        displayName = name.substring(0, 1) + name.substring(name.length - 1);
        displayName = displayName.toUpperCase();
      }
    } else {
      _haveImage = true;
      image = CachedNetworkImageProvider(imageBase + url);
    }

    return Container(
      child: CircleAvatar(
        radius: size,
        backgroundColor:
        _haveImage ? Colors.transparent : Colors.grey.withOpacity(0.4),
        child: _haveImage
            ? CircleAvatar(
          radius: size,
          backgroundImage: image,
          backgroundColor: Colors.transparent,
        )
            : Text(displayName,
            style:
            TextStyle(
              fontSize: _isTablet ? Measurements.height * 0.025: Measurements.height * 0.035,
              fontWeight: FontWeight.w500,
              color: iconColor(),
            ),
        ),
      ),
    );
  }
}

class CustomGrid extends StatefulWidget {
  final SwitcherScreenBloc screenBloc;

  CustomGrid({this.screenBloc,});
  @override
  _CustomGridState createState() => _CustomGridState();
}

class _CustomGridState extends State<CustomGrid> {
  Business selected;
  @override
  Widget build(BuildContext context) {
    List<Widget> business = List();
    int index = 0;
    business.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('Business'),
            padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
          ),
        ],
      ),
    );
    widget.screenBloc.state.businesses.forEach((f) {
      business.add(
        Container(
          key: Key('$index.switcher.icon'),
          child: GridItems(
            business: f,
            onTap: () {
              setState(() {
                selected = f;
              });
              widget.screenBloc.add(SwitcherSetBusinessEvent(business: f));
            },
            isLoading: f == selected,
          ),
        ),
      );
      index++;
    });
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Wrap(
          spacing: Measurements.width * 0.075,
          runSpacing: Measurements.width * 0.01,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: business,
        ),
      ],
    );
  }
}