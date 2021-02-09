import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardAppPosView extends StatefulWidget {
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool isLoading;
  final Function onTapOpen;
  final Function onTapEditTerminal;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;

  DashboardAppPosView({
    this.appWidget,
    this.businessApps,
    this.terminals,
    this.isLoading,
    this.activeTerminal,
    this.onTapEditTerminal,
    this.onTapOpen,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
    this.onTapLearnMore,
    this.onTapGetStarted,
    this.onTapContinueSetup,
  });
  @override
  _DashboardAppPosViewState createState() => _DashboardAppPosViewState();
}

class _DashboardAppPosViewState extends State<DashboardAppPosView> {
  String imageBase = Env.storage + '/images/';

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    List<Terminal> terminals = widget.terminals;
    String avatarName = '';
    if (widget.activeTerminal != null) {
      String name = widget.activeTerminal.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    if (widget.businessApps.setupStatus == 'completed') {
      String themeColor = GlobalUtils.theme == 'light' ? 'black' : 'white';
      return InkWell(
        onTap: widget.onTapOpen,
        child: BlurEffectView(
          isDashboard: true,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Language.getCommerceOSStrings('dashboard.apps.pos').toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 14,),
                    widget.isLoading ? Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      ),
                    ):
                    widget.activeTerminal == null ? Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      child: Text(
                        'You have no terminals here',
                      ),
                    ):
                    Row(
                      children: <Widget>[
                        // Terminal View
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              widget.activeTerminal.logo != null ?
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage('$imageBase${widget.activeTerminal.logo}'),
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ):
                              Container(
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                                  child: Text(
                                    avatarName,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: iconColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  widget.activeTerminal.name,
                                  maxLines: 2,
                                  minFontSize: 16,
                                  maxFontSize: 24,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
//                        Padding(
//                          padding: EdgeInsets.only(left: 12),
//                        ),
//                        // Edit Button
//                        Expanded(
//                          flex: 1,
//                          child: InkWell(
//                            onTap: widget.onTapEditTerminal,
//                            child: Container(
//                              height: 58,
//                              alignment: Alignment.center,
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(8),
//                                color: overlayDashboardButtonsBackground(),
//                              ),
//                              child: Text(
//                                Language.getCommerceOSStrings('dashboard.edit_apps.enter_button'),
//                                softWrap: true,
//                                style: TextStyle(fontSize: 16, color: Colors.white),
//                              ),
//                            ),
//                          ),
//                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Container(
                  height: 50.0 * widget.notifications.length,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                      color: overlayColor(),
                  ),
                  child: ListView.builder(
                    itemBuilder: _itemBuilderDDetails,
                    itemCount: widget.notifications.length,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return BlurEffectView(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        isDashboard: true,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${Env.cdnIcon}icon-comerceos-pos-not-installed.png'),
                            fit: BoxFit.fitWidth)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Language.getCommerceOSStrings(widget.businessApps.dashboardInfo.title),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Language.getWidgetStrings('widgets.${widget.businessApps.code}.install-app'),
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            DashboardSetupButtons(
              businessApps: widget.businessApps,
              onTapContinueSetup: widget.onTapContinueSetup,
              onTapGetStarted: widget.onTapGetStarted,
              onTapLearnMore: widget.onTapLearnMore,
            ),
          ],
        ),
      );
    }
  }

  Widget _itemBuilderDDetails(BuildContext context, int index) {
    return DashboardOptionCell(
      notificationModel: widget.notifications[index],
      onTapDelete: (NotificationModel model) {
        widget.deleteNotification(model);
      },
      onTapOpen: (NotificationModel model) {
        widget.openNotification(model);
      },
    );
  }

}
