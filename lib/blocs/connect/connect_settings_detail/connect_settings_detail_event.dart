
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class ConnectSettingsDetailScreenEvent extends Equatable {
  ConnectSettingsDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class ConnectSettingsDetailScreenInitEvent extends ConnectSettingsDetailScreenEvent {
  final String business;
  final ConnectModel connectModel;

  ConnectSettingsDetailScreenInitEvent({
    this.business,
    this.connectModel,
  });

  @override
  List<Object> get props => [
    this.business,
    this.connectModel,
  ];
}

class ConnectAddPaymentOptionEvent extends ConnectSettingsDetailScreenEvent {
  final String name;
  final String paymentMethod;

  ConnectAddPaymentOptionEvent({this.name, this.paymentMethod,});
}

class ConnectDeletePaymentOptionEvent extends ConnectSettingsDetailScreenEvent {
  final String id;

  ConnectDeletePaymentOptionEvent({this.id});
}

class ConnectUpdatePaymentOptionEvent extends ConnectSettingsDetailScreenEvent {
  final String id;
  final Map<String, dynamic> body;

  ConnectUpdatePaymentOptionEvent({this.id, this.body});
}