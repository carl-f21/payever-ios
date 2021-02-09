import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';

class NotificationCell extends StatefulWidget {
  final List<NotificationModel> notifications;
  final BusinessApps businessApps;
  final Function tapOpen;
  final Function tapDelete;
  NotificationCell({
    this.notifications = const [],
    this.businessApps,
    this.tapOpen,
    this.tapDelete
  });
  @override
  _NotificationCellState createState() => _NotificationCellState();
}

class _NotificationCellState extends State<NotificationCell> {
  String uiKit = '${Env.cdnIcon}/';
  String imageBase = Env.storage + '/images/';

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {

    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.businessApps != null ? Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('https://payever.azureedge.net/icons-png/icon-commerceos-${getIconsOfKind(getKind(widget.businessApps.code))}-64.png'),
                            fit: BoxFit.fitWidth)),
                  ): Container(),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  widget.businessApps != null ? Text(
                    Language.getCommerceOSStrings(widget.businessApps.dashboardInfo.title),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ): Container(),
                ],
              ),
              widget.notifications.length > 1 ? Row(
                children: <Widget>[
                  Text(
                    '${widget.notifications.length}',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(width: 8) ,
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.4)
                      ),
                      child: Center(
                        child: Text(
                          isExpanded ? 'Less': 'More',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ): Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return DashboardOptionCell(
                notificationModel: widget.notifications[index],
                onTapOpen: (NotificationModel notification) {
                  widget.tapOpen(notification);
                },
                onTapDelete: (NotificationModel notification) {
                  widget.tapDelete(notification);
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Colors.black,
              );
            },
            itemCount: isExpanded ? widget.notifications.length : 1,
          ),
        ],
      ),
    );
  }
}
