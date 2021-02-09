import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';

class CheckoutSettingScreenEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class CheckoutSettingScreenInitEvent extends CheckoutSettingScreenEvent {
  final String businessId;
  final Checkout checkout;
  CheckoutSettingScreenInitEvent({
    this.businessId,
    this.checkout,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.checkout,
  ];
}

class UpdateCheckoutSettingsEvent extends CheckoutSettingScreenEvent {}

class GetPhoneNumbers extends CheckoutSettingScreenEvent {}

class UpdatePolicyEvent extends CheckoutSettingScreenEvent {

  final String channelId;
  final bool policyEnabled;

  UpdatePolicyEvent({this.channelId, this.policyEnabled});

  @override
  List<Object> get props => [
    this.channelId,
    this.policyEnabled,
  ];
}