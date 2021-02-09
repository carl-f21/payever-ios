import 'package:equatable/equatable.dart';

abstract class WelcomeScreenEvent extends Equatable {
  WelcomeScreenEvent();

  @override
  List<Object> get props => [];
}

class WelcomeScreenInitEvent extends WelcomeScreenEvent {
  final String uuid;
  final String businessId;

  WelcomeScreenInitEvent({this.uuid, this.businessId,});

  @override
  List<Object> get props => [
    this.uuid,
    this.businessId,
  ];
}

class ToggleEvent extends WelcomeScreenEvent {
  final String type;
  final String businessId;

  ToggleEvent({this.type, this.businessId,});

  @override
  List<Object> get props => [
    this.type,
    this.businessId,
  ];
}

