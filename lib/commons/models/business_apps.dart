import 'package:payever/settings/models/models.dart';

class BusinessApps {
  final String id;
  final Acl allowedAcls;
  final String bootstrapScriptUrl;
  final String code;
  final DashboardInfo dashboardInfo;
  final bool isDefault;
  bool installed;
  final String microUuid;
  final int order;
  final DateTime startAt;
  final String setupStatus;
  final String tag;
  final String url;

  BusinessApps(
      {this.id,
      this.allowedAcls,
      this.bootstrapScriptUrl,
      this.code,
      this.dashboardInfo,
      this.isDefault,
      this.installed,
      this.microUuid,
      this.order,
      this.startAt,
      this.setupStatus,
      this.tag,
      this.url});


  factory BusinessApps.fromMap(dynamic app) {
    return BusinessApps(
      id: app['_id'],
      allowedAcls: Acl.fromMap(app['allowedAcls']),
      bootstrapScriptUrl: app['bootstrapScriptUrl'],
      code: app['code'],
      dashboardInfo: app['dashboardInfo'] == {}
          ? null
          : DashboardInfo.fromMap(app['dashboardInfo']),
      isDefault: app['default'],
      installed: app['installed'],
      microUuid: app['microUuid'],
      order: app['order'],
      startAt: app['startAt'] != null ? DateTime.parse(app['startAt']) : DateTime.now(),
      setupStatus: app['setupStatus'],
      tag: app['tag'],
      url: app['url'],
    );
  }

}

class DashboardInfo {
  final String title;
  final String icon;

  DashboardInfo({this.title, this.icon});

  factory DashboardInfo.fromMap(dashboardInfo) {
    return DashboardInfo(
        title: dashboardInfo['title'], icon: dashboardInfo['icon']);
  }
}
