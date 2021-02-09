import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/theme.dart';

import 'connect_top_button.dart';

class ConnectListItem extends StatelessWidget {
  final ConnectModel connectModel;
  final Function onTap;
  final Function onOpen;
  final Function onInstall;
  final Function onUninstall;
  final bool isPortrait;
  final bool isTablet;
  final bool installingConnect;

  ConnectListItem({
    this.connectModel,
    this.onTap,
    this.onOpen,
    this.onInstall,
    this.onUninstall,
    this.isTablet = false,
    this.isPortrait = true,
    this.installingConnect = false,
  });

  List<ConnectPopupButton> uninstallPopUp(BuildContext context) {
    return [
      ConnectPopupButton(
        title: Language.getConnectStrings('actions.uninstall'),
        onTap: () {
          onUninstall(connectModel);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double margin = isTablet ? 24: 16;
    String iconType = connectModel.integration.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    iconType = iconType.replaceAll('#', '');

    return GestureDetector(
      onTap: () {
        onTap(connectModel);
      },
      child: Container(
        height: 66,
        padding: EdgeInsets.only(left: margin, right: margin),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(Measurements.channelIcon(iconType), width: 32, color: iconColor(),),
                  ),
                  Expanded(
                    child: Text(
                      Language.getPosConnectStrings(connectModel.integration.displayOptions.title),
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueMed',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6),
            ),
            isTablet || !isPortrait ? Container(
              width: Measurements.width * (isPortrait ? 0.1 : 0.2),
              child: Text(
                Language.getConnectStrings('categories.${connectModel.integration.category}.title'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 14,
                ),
              ),
            ): Container(),
            isTablet || !isPortrait ? Padding(
              padding: EdgeInsets.only(left: 6),
            ): Container(),
            isTablet || !isPortrait ? Container(
              width: Measurements.width * (isPortrait ? 0.1 : 0.2),
              child: Text(
                Language.getPosConnectStrings(connectModel.integration.installationOptions.developer),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 14,
                ),
              ),
            ): Container(),
            isTablet || !isPortrait ? Padding(
              padding: EdgeInsets.only(left: 6),
            ): Container(),
            isTablet || !isPortrait ? Container(
              width: Measurements.width * (isPortrait ? 0.1 : 0.2),
              child: Text(
                Language.getPosConnectStrings(connectModel.integration.installationOptions.languages),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 14,
                ),
              ),
            ): Container(),
            isTablet || !isPortrait ? Padding(
              padding: EdgeInsets.only(left: 6),
            ): Container(),
            Container(
              width: !isTablet && isPortrait ? null : Measurements.width * (isTablet ? (isPortrait ? 0.15 : 0.2) : (isPortrait ? null: 0.35)),
              child: connectModel.installed ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    child: MaterialButton(
                      onPressed: () {
                        onOpen(connectModel);
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
                        child: installingConnect ? Center(
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
                      onSelected: (ConnectPopupButton item) => item.onTap(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: overlayBackground(),
                      itemBuilder: (BuildContext context) {
                        return uninstallPopUp(context)
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
                    padding: EdgeInsets.only(right: margin / 2),
                    child: MaterialButton(
                      onPressed: () {
                        onInstall(connectModel);
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
                      child: installingConnect ? Container(
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
          ],
        ),
      ),
    );
  }
}