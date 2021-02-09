import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardCheckoutView extends StatefulWidget {
  final VoidCallback onOpen;
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;
  final Function onTapLinkOrManage;

  DashboardCheckoutView({
    this.onOpen,
    this.businessApps,
    this.appWidget,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
    this.checkouts = const [],
    this.defaultCheckout,
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
    this.onTapLinkOrManage,
  });

  @override
  _DashboardCheckoutViewState createState() => _DashboardCheckoutViewState();
}

class _DashboardCheckoutViewState extends State<DashboardCheckoutView> {

  @override
  Widget build(BuildContext context) {
    if (widget.businessApps.setupStatus == 'completed') {
      return BlurEffectView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        isDashboard: true,
        child: Column(
          children: [
            InkWell(
              onTap: widget.onOpen,
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  Language.getCommerceOSStrings('dashboard.apps.checkout')
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            widget.checkouts.length > 0
                ? Column(
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            widget.onTapLinkOrManage(true);
                          },
                          child: Container(
                            height: 58,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: overlayDashboardButtonsBackground(),
                            ),
                            child: Text(
                              'Link',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        child: InkWell(
                          onTap: () {
                            widget.onTapLinkOrManage(false);
                          },
                          child: Container(
                            height: 58,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: overlayDashboardButtonsBackground(),
                            ),
                            child: Text(
                              Language.getCommerceOSStrings(
                                  'menu.customer.manage'),
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
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
                  ),
          ],
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
                        image: NetworkImage(
                            '${Env.cdnIcon}icon-comerceos-${widget.appWidget.type}-not-installed.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Language.getWidgetStrings(widget.appWidget.title),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Language.getWidgetStrings(
                        'widgets.checkout.actions.add-new'),
                    style: TextStyle(
                      fontSize: 10,
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
