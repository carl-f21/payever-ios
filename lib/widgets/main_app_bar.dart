import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/dashboard/sub_view/business_logo.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:provider/provider.dart';

class MainAppbar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget icon;
  final bool isBusinessMode;
  final bool isClose;
  final DashboardScreenBloc dashboardScreenBloc;
  final DashboardScreenState dashboardScreenState;
  final bool toggleBusinessMode;

  User user;
  Business activeBusiness;
  String curWall;
  List<BusinessApps> businessWidgets;
  List<AppWidget> currentWidgets;

  MainAppbar({
    this.title,
    this.icon,
    this.dashboardScreenBloc,
    this.dashboardScreenState,
    this.isBusinessMode = true,
    this.isClose = true,
    this.toggleBusinessMode = false,
  }) {
    user = dashboardScreenState.user;
    activeBusiness = dashboardScreenState.activeBusiness;
    curWall = dashboardScreenState.curWall;
    businessWidgets = dashboardScreenState.businessWidgets;
    currentWidgets = dashboardScreenState.currentWidgets;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool _isPortrait;
    bool _isTablet;

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    _isTablet = MediaQuery.of(context).size.width > 600;

    String logo = '';
    String name = '';
    if (isBusinessMode) {
      if (activeBusiness != null) {
        name = activeBusiness.name;
        if (activeBusiness.logo != null)
          logo =
              'https://payeverproduction.blob.core.windows.net/images/${activeBusiness.logo}';
      }
    } else {
      if (user != null) {
        name = user.fullName ?? '';
        if (user.logo != null)
          logo =
              'https://payeverproduction.blob.core.windows.net/images/${user.logo}';
      }
    }

    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(child: icon),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: Row(
              children: <Widget>[
                BusinessLogo(
                  url: logo,
                ),
                _isTablet || !_isPortrait
                    ? Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            onTap: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/searchicon.svg',
              width: 20,
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: SearchScreen(
                    dashboardScreenBloc: dashboardScreenBloc,
                    businessId: activeBusiness.id,
                    searchQuery: '',
                    appWidgets: currentWidgets,
                    activeBusiness: activeBusiness,
                    currentWall: curWall,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset('assets/images/notificationicon.svg',
                width: 20),
            onTap: () async {
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentBusiness(activeBusiness);
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentWallpaper(curWall);

              await showGeneralDialog(
                barrierColor: null,
                transitionBuilder: (context, a1, a2, widget) {
                  final curvedValue = Curves.ease.transform(a1.value) - 1.0;
                  return Transform(
                    transform:
                        Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                    child: NotificationsScreen(
                      business: activeBusiness,
                      businessApps: businessWidgets,
                      dashboardScreenBloc: dashboardScreenBloc,
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
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/list.svg',
              width: 20,
            ),
            onTap: () {
              // innerDrawerKey.currentState.toggle();
              showCupertinoModalPopup(
                  context: context,
                  builder: (builder) {
                    return DashboardMenuView(
                      dashboardScreenBloc: dashboardScreenBloc,
                      activeBusiness: dashboardScreenState.activeBusiness,
                      isBusinessMode: isBusinessMode,
                    );
                  });
            },
          ),
        ),
        isClose
            ? Padding(
                padding: EdgeInsets.all(6),
                child: InkWell(
                  child: SvgPicture.asset(
                    'assets/images/closeicon.svg',
                    width: 16,
                  ),
                  onTap: () {
                    if (toggleBusinessMode) {
                      GlobalUtils.isBusinessMode = true;
                    }
                    Navigator.pop(context);
                  },
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
      ],
    );
  }
}
