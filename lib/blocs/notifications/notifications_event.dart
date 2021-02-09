import 'package:equatable/equatable.dart';

abstract class NotificationsScreenEvent extends Equatable {
  NotificationsScreenEvent();

  @override
  List<Object> get props => [];
}

class NotificationsScreenInitEvent extends NotificationsScreenEvent {
  final String uuid;
  final String businessId;

  NotificationsScreenInitEvent({this.uuid, this.businessId,});

  @override
  List<Object> get props => [
    this.uuid,
    this.businessId,
  ];
}
