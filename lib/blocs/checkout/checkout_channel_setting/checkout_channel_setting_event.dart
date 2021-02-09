
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class CheckoutChannelSettingScreenEvent extends Equatable {
  CheckoutChannelSettingScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutChannelSettingScreenInitEvent extends CheckoutChannelSettingScreenEvent {
  final String business;
  final ConnectModel connectModel;

  CheckoutChannelSettingScreenInitEvent({
    this.business,
    this.connectModel,
  });

  @override
  List<Object> get props => [
    this.business,
    this.connectModel,
  ];
}

class GetPluginsEvent extends CheckoutChannelSettingScreenEvent {}

class CreateCheckoutAPIkeyEvent extends CheckoutChannelSettingScreenEvent {
  final String name;
  final String redirectUri;

  CreateCheckoutAPIkeyEvent({
    this.name,
    this.redirectUri = '',
  });

  @override
  List<Object> get props => [
    this.name,
    this.redirectUri,
  ];
}

class DeleteCheckoutAPIkeyEvent extends CheckoutChannelSettingScreenEvent {
  final String client;

  DeleteCheckoutAPIkeyEvent({
    this.client,
  });

  @override
  List<Object> get props => [
    this.client,
  ];
}