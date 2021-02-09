import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardTransactionsView extends StatefulWidget {
  final VoidCallback onOpen;
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final bool isLoading;
  final List<Day> lastMonth;
  final List<Month> lastYear;
  final List<double> monthlySum;
  final double total;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;

  DashboardTransactionsView({
    this.onOpen,
    this.businessApps,
    this.appWidget,
    this.total = 0,
    this.isLoading = true,
    this.lastMonth = const [],
    this.lastYear = const [],
    this.monthlySum = const [],
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
  });
  @override
  _DashboardTransactionsViewState createState() => _DashboardTransactionsViewState();
}

class _DashboardTransactionsViewState extends State<DashboardTransactionsView> {
  bool isExpanded = false;
  var f = NumberFormat('###,###,##0.00', 'en_US');
  @override
  Widget build(BuildContext context) {
    String currency = '';
    if (widget.lastYear.length > 0) {
      NumberFormat format = NumberFormat();
      currency = format.simpleCurrencySymbol(widget.lastYear.last.currency);
    }
    if (widget.businessApps != null && widget.businessApps.setupStatus == 'completed') {
      return InkWell(
        onTap: widget.onOpen,
        child: BlurEffectView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          isDashboard: true,
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Language.getCommerceOSStrings('dashboard.apps.transactions').toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    widget.isLoading ? Container(
                      height: 64,
                      child: Center(
                        child: Container(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ):
                    !widget.isLoading ?  SizedBox(height: 14): Container(),
                    widget.lastYear.length > 0 ?  Row(
                      children: [
                        Text(
                          '${f.format(widget.total)} $currency',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ): Container(),
                    SizedBox(height: 8),
                    !widget.isLoading ?  Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          Language.getWidgetStrings('widgets.transactions.this-month'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ): Container(),
                    !widget.isLoading ?  SizedBox(height: 6): Container(),
                    widget.lastYear.length > 0 ?  Row(
                      children: [
                        Text(
                          '${widget.lastYear.last.amount} $currency',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(28, 187, 45, 1),
                          ),
                        )
                      ],
                    ): Container(),
                  ],
                ),
              ),
              if (isExpanded)
                Container(
                  height: 50.0 * widget.notifications.length,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
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
        ),
      );
    } else {
      return _noInstalledView();
    }
  }

  Widget _noInstalledView() {
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
                        image: NetworkImage('${Env.cdnIcon}icon-comerceos-${widget.appWidget.type}-not-installed.png'),
                        fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  Language.getWidgetStrings(widget.appWidget.title),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
          SizedBox(height: 12),
          DashboardSetupButtons(
            businessApps: widget.businessApps,
            appWidget: widget.appWidget,
            onTapContinueSetup: widget.onTapContinueSetup,
            onTapGetStarted: widget.onTapGetStarted,
            onTapLearnMore: widget.onTapLearnMore,
          )
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
