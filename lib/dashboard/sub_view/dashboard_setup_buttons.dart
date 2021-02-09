import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/theme.dart';

class DashboardSetupButtons extends StatelessWidget {
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;

  DashboardSetupButtons({
    this.businessApps,
    this.appWidget,
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
  });

  Map<String, String>learnMoreUrls = {
    'pos': 'https://getpayever.com/pos?_ga=2.81365975.1187566179.1598419016-238550036.1593180292',
    'shop': 'https://getpayever.com/shop?_ga=2.69838672.1187566179.1598419016-238550036.1593180292'
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
        color: overlayBackground(),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                businessApps.installed
                    ? onTapContinueSetup(businessApps)
                    : onTapGetStarted(businessApps);
              },
              child: Center(
                child: Text(
                  !businessApps.installed ? Language.getWelcomeStrings('welcome.get-started') : Language.getWidgetStrings('widgets.actions.continue-setup'),
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 12),
                ),
              ),
            ),
          ),
          if (!businessApps.installed) Container(
            width: 1,
            color: overlayButtonBackground(),
          ),
          if (!businessApps.installed) Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                onTapLearnMore(
                    learnMoreUrls[businessApps.code]);
              },
              child: Center(
                child: Text(
                  Language.getWidgetStrings('widgets.actions.learn-more'),
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
