import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class CheckoutPaymentSettingScreenEvent extends Equatable {
  CheckoutPaymentSettingScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutPaymentSettingScreenInitEvent extends CheckoutPaymentSettingScreenEvent {
  final String business;
  final ConnectModel connectModel;

  CheckoutPaymentSettingScreenInitEvent({
    this.business,
    this.connectModel,
  });

  @override
  List<Object> get props => [
    this.business,
    this.connectModel,
  ];
}

class AddPaymentOptionEvent extends CheckoutPaymentSettingScreenEvent {
  final String name;
  final String paymentMethod;

  AddPaymentOptionEvent({this.name, this.paymentMethod,});
}

class DeletePaymentOptionEvent extends CheckoutPaymentSettingScreenEvent {
  final String id;

  DeletePaymentOptionEvent({this.id});
}

class UpdatePaymentOptionEvent extends CheckoutPaymentSettingScreenEvent {
  final String id;
  final Map<String, dynamic> body;

  UpdatePaymentOptionEvent({this.id, this.body});
}