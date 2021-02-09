import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/business/views/business_register_screen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/personal/views/personal_dashboard_screen.dart';
import 'package:payever/switcher/switcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';

class DashboardMenuView extends StatelessWidget {
  final Widget scaffold;
  final Business activeBusiness;
  final DashboardScreenBloc dashboardScreenBloc;
  final bool isBusinessMode;
  DashboardMenuView({
    this.scaffold,
    this.dashboardScreenBloc,
    this.isBusinessMode = true,
    @required this.activeBusiness,
  });

  @override
  Widget build(BuildContext context) {
    bool _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    bool _isTablet;
    if (_isPortrait) {
      _isTablet = MediaQuery.of(context).size.width > 600;
    } else {
      _isTablet = MediaQuery.of(context).size.height > 600;
    }


    bool isActive = false;
    if (activeBusiness != null) {
      isActive = activeBusiness.active;
    }
    return Container(
      height: _isPortrait ? 450 : Measurements.height,
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(top: _isPortrait ? 46 : 0),
          padding: EdgeInsets.symmetric(horizontal: _isPortrait ? 20 : 40),
          decoration: BoxDecoration(
            color: overlayFilterViewBackground(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 44,
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(top: 8),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.centerRight,
                      width: 70,
                      child: SvgPicture.asset(
                        'assets/images/closeicon.svg',
                        color: iconColor(),
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              isActive && dashboardScreenBloc.state.businesses.length > 1 ? InkWell(
                onTap: () async {
                  //onSwitchBusiness,
                  GlobalUtils.isBusinessMode = true;
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    PageTransition(
                      child: SwitcherScreen(false),
                      type: PageTransitionType.fade,
                    ),
                  );
                  if (result == 'refresh') {
                  }

                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Container(
                        width: 25,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/switch.svg',
                            width: 20,
                            color: iconColor(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Flexible(
                        child: Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.switch_profile'),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ) : Container(),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
              Visibility(
                visible: isBusinessMode,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<GlobalStateModel>(context, listen: false)
                            .setCurrentBusiness(dashboardScreenBloc.state.activeBusiness);
                        Provider.of<GlobalStateModel>(context, listen: false)
                            .setCurrentWallpaper(dashboardScreenBloc.state.curWall);
                        GlobalUtils.isBusinessMode = false;
                        Navigator.push(
                          context,
                          PageTransition(
                            child: PersonalDashboardInitScreen(
                              dashboardScreenBloc: dashboardScreenBloc,
                              isRefresh: true,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 8,),
                            Container(
                              width: 25,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/business_person.svg',
                                  width: 20,
                                  color: iconColor(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Flexible(
                              child: Text(
                                Language.getSettingsStrings('info_boxes.panels.general.menu_list.personal_information.title'),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: BusinessRegisterScreen(
                        dashboardScreenBloc: dashboardScreenBloc,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(microseconds: 300),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Container(
                        width: 25,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/add.svg',
                            width: 20,
                            color: iconColor(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Flexible(
                        child: Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.add_business'),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
              InkWell(
                onTap: () async {
                  GlobalUtils.isBusinessMode = true;
                  Navigator.pop(context);
                  SharedPreferences.getInstance().then((p) {
                    p.setString(GlobalUtils.BUSINESS, '');
                    p.setString(GlobalUtils.DEVICE_ID, '');
                    p.setString(GlobalUtils.REFRESH_TOKEN, '');
                    p.setString(GlobalUtils.TOKEN, '');
                  });
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: LoginInitScreen(), type: PageTransitionType.fade,
                    ),
                  );

                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Container(
                        width: 25,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/logout.svg',
                            width: 16,
                            color: iconColor(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Flexible(
                        child: Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.log_out'),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
              InkWell(
                onTap: () {
                  _sendMail('service@payever.de', 'Contact payever', '');
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Container(
                        width: 25,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/contact.svg',
                            width: 16,
                            color: iconColor(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Flexible(
                        child: Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.contact'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
              InkWell(
                onTap: () {
                  _sendMail(
                      'service@payever.de', 'Feedback for the payever-Team', '');
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Container(
                        width: 25,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/feedback.svg',
                            width: 16,
                            color: iconColor(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Flexible(
                        child: Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.feedback'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white10,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
  _sendMail(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
