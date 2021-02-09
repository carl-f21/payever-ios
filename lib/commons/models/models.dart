export 'app_widget.dart';
export 'business.dart';
export 'business_apps.dart';
export 'buttons_data.dart';
export 'expandable_header.dart';
export '../../pos/models/pos.dart';
export 'token.dart';
export 'tutorial.dart';
export '../../transactions/models/transaction.dart';
export 'user.dart';
export 'version.dart';

class NotificationModel {
  String id;
  String app;
  String kind;
  String entity;
  String message;
  String hash;
  String createdAt;
  String updatedAt;
  num v;
  dynamic data;

  NotificationModel.fromMap(dynamic obj) {
    id = obj['_id'];
    app = obj['app'];
    entity = obj['entity'];
    kind = obj['kind'];
    message = obj['message'];
    createdAt = obj['createdAt'];
    updatedAt = obj['updatedAt'];
    hash = obj['hash'];
    v = obj['__v'];
    if (obj['data'] != null) {
      data = obj['data'];
    }
  }
}
