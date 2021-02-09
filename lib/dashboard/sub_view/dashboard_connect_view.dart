import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardConnectView extends StatefulWidget {
  final AppWidget appWidget;
  final BusinessApps businessApps;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  final Function tapOpen;
  final List<ConnectModel> connects;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;

  DashboardConnectView({
    this.appWidget,
    this.businessApps,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
    this.tapOpen,
    this.connects,
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
  });
  @override
  _DashboardConnectViewState createState() => _DashboardConnectViewState();
}

class _DashboardConnectViewState extends State<DashboardConnectView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {

    if (widget.businessApps.setupStatus == 'completed') {
      return BlurEffectView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        isDashboard: true,
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: widget.tapOpen,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Language.getCommerceOSStrings('dashboard.apps.connect').toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  widget.connects == null ? Container(
                    height: 72,
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ): Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top rated',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              height: 50,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  String iconType = widget.connects[index].integration.displayOptions.icon ?? '';
                                  iconType = iconType.replaceAll('#icon-', '');
                                  iconType = iconType.replaceAll('#', '');
                                  return Container(
                                    width: 35,
                                    height: 35,
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: SvgPicture.asset(Measurements.channelIcon(iconType), width: 16, height: 16, color: iconColor(),)
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Container();
                                },
                                itemCount: widget.connects.length > 4 ? 4: widget.connects.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: InkWell(
                            onTap: widget.tapOpen,
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: overlayDashboardButtonsBackground(),
                              ),
                              child: Center(
                                child: Text(
                                  Language.getCommerceOSStrings('dashboard.apps.connect'),
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
            if (isExpanded)
              Container(
                height: 50.0 * widget.notifications.length,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  color: overlayBackground(),
                ),
                child: ListView.builder(
                  itemBuilder: _itemBuilderDDetails,
                  itemCount: widget.notifications.length,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
          ],
        ),
      );
    } else {
      return _unInstalledView();
    }
  }

  Widget _unInstalledView() {
    return  BlurEffectView(
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
                      image: NetworkImage('${Env.cdnIcon}icon-comerceos-connect-not-installed.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  Language.getWidgetStrings(widget.appWidget.title),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
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
