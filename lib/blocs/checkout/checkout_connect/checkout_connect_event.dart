import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class CheckoutConnectScreenEvent extends Equatable {
  CheckoutConnectScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutConnectScreenInitEvent extends CheckoutConnectScreenEvent {
  final String business;
  final String category;

  CheckoutConnectScreenInitEvent({
    this.business,
    this.category,
  });

  @override
  List<Object> get props => [
    this.business,
    this.category,
  ];
}

class InstallCheckoutConnect extends CheckoutConnectScreenEvent {
  final ConnectModel connectModel;

  InstallCheckoutConnect({this.connectModel});
}