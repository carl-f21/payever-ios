import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/theme.dart';

class DashboardOptionCell extends StatelessWidget {
  final NotificationModel notificationModel;
  final Function onTapOpen;
  final Function onTapDelete;
  DashboardOptionCell({
    this.notificationModel,
    this.onTapOpen,
    this.onTapDelete,
  });
  @override
  Widget build(BuildContext context) {
    String actionKey = notificationModel.message.replaceAll('notification.', '');
    String message = 'info_boxes.notifications.messages.$actionKey';
    return Column(
      children: [
        Divider(height: 0,),
        Container(
          height: 49,
          padding: EdgeInsets.fromLTRB(12, 0, 14, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: iconColor(),
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        Language.getCommerceOSStrings(message),
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      onTapOpen(notificationModel);
                    },
                    child: Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: overlayDashboardButtonsBackground(),
                      ),
                      child: Center(
                        child: Text(
                          Language.getCommerceOSStrings('actions.open'),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      onTapDelete(notificationModel);
                    },
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.5),
                        color: overlayDashboardButtonsBackground(),
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/images/closeicon.svg', width: 8),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
