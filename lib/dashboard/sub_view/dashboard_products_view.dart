import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/commons/views/custom_elements/product_cell.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardProductsView extends StatefulWidget {
  final AppWidget appWidget;
  final BusinessApps businessApps;
  final List<Products> lastSales;
  final Business business;
  final Function onOpen;
  final Function onSelect;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;

  DashboardProductsView({
    this.appWidget,
    this.businessApps,
    this.lastSales,
    this.business,
    this.onOpen,
    this.onSelect,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
  });

  @override
  _DashboardProductsViewState createState() => _DashboardProductsViewState();
}

class _DashboardProductsViewState extends State<DashboardProductsView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.businessApps.setupStatus == 'completed') {
      return _body();
    } else {
      return _notInstalledWidget();
    }
  }

  Widget _body() {
    return BlurEffectView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      isDashboard: true,
      child: Column(
        children: [
          Column(
            children: [
              InkWell(
                onTap: widget.onOpen,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Language.getCommerceOSStrings(
                    'dashboard.apps.products').toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14),
              widget.lastSales != null
                  ? Container(
                  height: (GlobalUtils.mainWidth - 64 - 8 * 2)/ 3,
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      widget.lastSales.length > 3 ? 3 : widget.lastSales.length,
                          (index) => ProductCell(
                        product: widget.lastSales[index],
                        business: widget.business,
                        onTap: (Products product) {
                          widget.onSelect(product);
                        },
                      ),
                    ).toList(),
                  ))
                  : Container(
                height: 92,
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
          if (isExpanded)
            Container(
              height: 50.0 * widget.notifications.length,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6)),
                color: overlayBackground(),
              ),
              child: ListView.builder(
                itemBuilder: _itemBuilderDDetails,
                itemCount: widget.notifications.length,
                physics: NeverScrollableScrollPhysics(),
              ),
            )
        ],
      ),
    );
  }

  Widget _notInstalledWidget() {
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
                            '${Env.cdnIcon}icon-comerceos-product-not-installed.png'),
                        fit: BoxFit.contain),
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
                      'widgets.products.actions.add-new'),
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
