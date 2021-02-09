import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';

class DashboardBusinessAppsView extends StatefulWidget {
  final List<BusinessApps> businessApps;
  final List<AppWidget> appWidgets;
  final Function onTapEdit;
  final Function onTapWidget;
  final bool isTablet;
  final String openAppCode;

  DashboardBusinessAppsView({
    this.businessApps,
    this.appWidgets,
    this.onTapEdit,
    this.onTapWidget,
    this.isTablet,
    this.openAppCode,
  });

  @override
  _DashboardBusinessAppsViewState createState() =>
      _DashboardBusinessAppsViewState();
}

class _DashboardBusinessAppsViewState extends State<DashboardBusinessAppsView> {
  @override
  Widget build(BuildContext context) {
    List<BusinessApps> businessApps = widget.businessApps.where((element) {
      String title = element.dashboardInfo.title ?? '';
      if (title != '') {
        if (title.contains('store') ||
            title.contains('transactions') ||
            title.contains('connect') ||
            title.contains('checkout') ||
            title.contains('contacts') ||
            title.contains('products') ||
            title.contains('setting') ||
            title.contains('pos')) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    }).toList();
    businessApps.sort((b1, b2) {
      if (b2.installed) {
        return 1;
      }
      return -1;
    });
    BusinessApps setting = businessApps.firstWhere(
        (element) => element.dashboardInfo.title.contains('setting'));
    businessApps.remove(setting);
    businessApps.add(setting);
    return BlurEffectView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      isDashboard: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: widget.onTapEdit,
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                'APPS',
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
          if (businessApps != null)
            _gridView(businessApps),
        ],
      ),
    );
  }

  Widget _gridView(List<BusinessApps> businessApps) {
    int crossAxisCount = widget.isTablet ? 6 : 4;
    int columnCount = businessApps.length ~/ crossAxisCount + ((businessApps.length % crossAxisCount == 0) ? 0 : 1);
    double height = columnCount * 86.0 + (columnCount - 1) * 30.0;
    return Container(
      height: height,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 0,
        crossAxisSpacing: (GlobalUtils.mainWidth - 64 - 68 * crossAxisCount) / (crossAxisCount - 1),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        childAspectRatio: 10 / 16,
        children: businessApps.map((e) => _itemBuilder(e)).toList(),
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _itemBuilder(BusinessApps currentApp) {
    String icon = currentApp.dashboardInfo.icon;
    icon = icon.replaceAll('32', '64');
    String code = currentApp.code;
    if (code == 'products') {
      code = 'product';
    }
    String title = currentApp.dashboardInfo.title;
    if (title.contains('setting')) {
      title = 'info_boxes.settings.heading';
    }
    return GestureDetector(
      onTap: () {
        widget.onTapWidget(currentApp);
      },
      child: Container(
        width: 68,
        height: 86,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          '${Env.cdnIcon}icon-comerceos-$code-not-installed.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: overlayDashboardAppsBackground(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                if (widget.openAppCode == currentApp.code)
                  Container(
                      width: 68,
                      height: 68,
                      padding: EdgeInsets.all(10),
                      child: Center(child: CircularProgressIndicator()))
              ],
            ),
            SizedBox(height: 4),
            Container(
              height: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  !currentApp.dashboardInfo.title.contains('setting') &&
                          currentApp.setupStatus != 'completed'
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentApp.installed
                                ? Color(0xFF0084FF)
                                : Color(0xFFC02F1D),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Text(
                      Language.getCommerceOSStrings(title),
                      style: TextStyle(
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
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
