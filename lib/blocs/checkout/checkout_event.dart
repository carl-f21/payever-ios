import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';

abstract class CheckoutScreenEvent extends Equatable {
  CheckoutScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutScreenInitEvent extends CheckoutScreenEvent {
  final Business business;
  final Terminal terminal;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;
  final List<ChannelSet> channelSets;

  CheckoutScreenInitEvent({
    this.business,
    this.terminal,
    this.checkouts,
    this.defaultCheckout,
    this.channelSets,
  });

  @override
  List<Object> get props => [
    this.business,
    this.terminal,
    this.checkouts,
    this.defaultCheckout,
    this.channelSets,
  ];
}

class GetChannelSet extends CheckoutScreenEvent {}

class GetPaymentConfig extends CheckoutScreenEvent {

}

class GetChannelConfig extends CheckoutScreenEvent {

}

class GetConnectConfig extends CheckoutScreenEvent {

}

class GetSectionDetails extends CheckoutScreenEvent {

}

class UpdateCheckoutSections extends CheckoutScreenEvent {
}


class ReorderSection1Event extends CheckoutScreenEvent {
  final int oldIndex;
  final int newIndex;

  ReorderSection1Event({this.oldIndex, this.newIndex});
}

class ReorderSection2Event extends CheckoutScreenEvent {
  final int oldIndex;
  final int newIndex;

  ReorderSection2Event({this.oldIndex, this.newIndex});
}

class ReorderSection3Event extends CheckoutScreenEvent {
  final int oldIndex;
  final int newIndex;

  ReorderSection3Event({this.oldIndex, this.newIndex});
}

class AddSectionEvent extends CheckoutScreenEvent {
  final int section;
  AddSectionEvent({this.section});
}

class RemoveSectionEvent extends CheckoutScreenEvent {
  final Section section;
  RemoveSectionEvent({this.section});
}

class AddSectionToStepEvent extends CheckoutScreenEvent {
  final Section section;
  final int step;
  AddSectionToStepEvent({this.section, this.step});
}

class GetOpenUrlEvent extends CheckoutScreenEvent {
  final String openUrl;

  GetOpenUrlEvent(this.openUrl);
}

class FinanceExpressTypeEvent extends CheckoutScreenEvent {
  final Finance type;

  FinanceExpressTypeEvent(this.type);

}

class UpdateFinanceExpressTypeEvent extends CheckoutScreenEvent {
  final Finance type;

  UpdateFinanceExpressTypeEvent(this.type);

}

class GetQrIntegration extends CheckoutScreenEvent {}

class ClearQrIntegration extends CheckoutScreenEvent {}

class GetDevicePaymentSettings extends CheckoutScreenEvent {}

class UpdateCheckoutDevicePaymentSettings extends CheckoutScreenEvent{
  final DevicePaymentSettings settings;

  UpdateCheckoutDevicePaymentSettings({this.settings});

  @override
  List<Object> get props => [
    this.settings,
  ];
}

class SaveCheckoutDevicePaymentSettings extends CheckoutScreenEvent{}

class GetCheckoutTwilioSettings extends CheckoutScreenEvent {}

class GetCheckoutAddTwilioPhoneFrom extends CheckoutScreenEvent {}

class AddCheckoutPhoneNumberSettings extends CheckoutScreenEvent {
  final String action;
  final String id;

  AddCheckoutPhoneNumberSettings({
    this.action,
    this.id,
  });

  @override
  List<Object> get props => [
    this.action,
    this.id,
  ];
}

class RemoveCheckoutPhoneNumberSettings extends CheckoutScreenEvent {
  final String action;
  final String id;
  final String sid;

  RemoveCheckoutPhoneNumberSettings({
    this.action,
    this.id,
    this.sid,
  });

  @override
  List<Object> get props => [
    this.action,
    this.id,
    this.sid,
  ];
}

class SearchCheckoutPhoneNumberEvent extends CheckoutScreenEvent {
  final String action;
  final String country;
  final bool excludeAny;
  final bool excludeForeign;
  final bool excludeLocal;
  final String id;
  final String phoneNumber;

  SearchCheckoutPhoneNumberEvent({
    this.action,
    this.country,
    this.excludeAny,
    this.excludeForeign,
    this.excludeLocal,
    this.id,
    this.phoneNumber,
  });

  @override
  List<Object> get props => [
    this.action,
    this.country,
    this.excludeAny,
    this.excludeForeign,
    this.excludeLocal,
    this.id,
    this.phoneNumber,
  ];
}

class PurchaseCheckoutNumberEvent extends CheckoutScreenEvent {
  final String action;
  final String id;
  final String phone;
  final String price;

  PurchaseCheckoutNumberEvent({
    this.action,
    this.id,
    this.phone,
    this.price,
  });

  @override
  List<Object> get props => [
    this.action,
    this.id,
    this.phone,
    this.price,
  ];
}

class UpdateCheckoutAddPhoneNumberSettings extends CheckoutScreenEvent {
  final AddPhoneNumberSettingsModel settingsModel;

  UpdateCheckoutAddPhoneNumberSettings({
    this.settingsModel,
  });

  @override
  List<Object> get props => [
    this.settingsModel,
  ];
}

class UpdateCheckoutAddPhoneNumber extends CheckoutScreenEvent {
  final String action;
  final String id;
  final String value;
  final String phone;

  UpdateCheckoutAddPhoneNumber({
    this.action,
    this.id,
    this.value,
    this.phone,
  });

  @override
  List<Object> get props => [
    this.action,
    this.id,
    this.value,
    this.phone,
  ];
}

class UninstallCheckoutPaymentEvent extends CheckoutScreenEvent {
  final IntegrationModel integrationModel;
  UninstallCheckoutPaymentEvent({this.integrationModel});
}

class InstallCheckoutPaymentEvent extends CheckoutScreenEvent {
  final IntegrationModel integrationModel;
  InstallCheckoutPaymentEvent({this.integrationModel});
}

class InstallCheckoutIntegrationEvent extends CheckoutScreenEvent {
  final String integrationId;

  InstallCheckoutIntegrationEvent({this.integrationId});
}

class BusinessUploadEvent extends CheckoutScreenEvent {
  final Map<String, dynamic> body;
  BusinessUploadEvent(this.body);

  @override
  List<Object> get props => [body];
}

class CheckoutUpdateChannelSetFlowEvent extends CheckoutScreenEvent {
  final ChannelSetFlow channelSetFlow;
  CheckoutUpdateChannelSetFlowEvent(this.channelSetFlow);

  @override
  List<Object> get props => [channelSetFlow];
}

class CheckoutGetPrefilledLinkEvent extends CheckoutScreenEvent {
  final bool isCopyLink;

  CheckoutGetPrefilledLinkEvent({this.isCopyLink = true});

  @override
  List<Object> get props => [
    this.isCopyLink,
  ];
}

class CheckoutGetPrefilledQRCodeEvent extends CheckoutScreenEvent {}