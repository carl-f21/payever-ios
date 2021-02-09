import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';

abstract class PosScreenEvent extends Equatable {
  PosScreenEvent();

  @override
  List<Object> get props => [];
}

class PosScreenInitEvent extends PosScreenEvent {
  final Business currentBusiness;
  final List<Terminal> terminals;
  final List<ChannelSet> channelSets;
  final Terminal activeTerminal;
  final Checkout defaultCheckout;
  final List<ProductsModel> products;

  PosScreenInitEvent({
    this.currentBusiness,
    this.channelSets,
    this.terminals,
    this.activeTerminal,
    this.defaultCheckout,
    this.products,
  });

  @override
  List<Object> get props => [
    this.currentBusiness,
    this.channelSets,
    this.terminals,
    this.activeTerminal,
    this.defaultCheckout,
    this.products
  ];
}

class GetPosIntegrationsEvent extends PosScreenEvent {}

class GetTerminalIntegrationsEvent extends PosScreenEvent {
  final String businessId;
  final String terminalId;

  GetTerminalIntegrationsEvent({this.businessId, this.terminalId});

  @override
  List<Object> get props => [
    this.businessId,
    this.terminalId,
  ];
}

class GetPosCommunications extends PosScreenEvent {
  final String businessId;

  GetPosCommunications({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GetPosDevicePaymentSettings extends PosScreenEvent {
  final String businessId;

  GetPosDevicePaymentSettings({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class InstallDevicePaymentEvent extends PosScreenEvent {
  final String businessId;

  InstallDevicePaymentEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class UninstallDevicePaymentEvent extends PosScreenEvent {
  final String businessId;

  UninstallDevicePaymentEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class InstallQREvent extends PosScreenEvent {
  final String businessId;
  final String businessName;
  final String avatarUrl;
  final String id;
  final String url;

  InstallQREvent({
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  ];
}

class UninstallQREvent extends PosScreenEvent {
  final String businessId;

  UninstallQREvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class InstallTwilioEvent extends PosScreenEvent {
  final String businessId;

  InstallTwilioEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}




class UninstallTwilioEvent extends PosScreenEvent {
  final String businessId;

  UninstallTwilioEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class InstallTerminalDevicePaymentEvent extends PosScreenEvent {
  final String payment;
  final String businessId;
  final String terminalId;

  InstallTerminalDevicePaymentEvent({this.payment, this.businessId, this.terminalId});

  @override
  List<Object> get props => [
    this.payment,
    this.businessId,
    this.terminalId,
  ];
}

class UninstallTerminalDevicePaymentEvent extends PosScreenEvent {
  final String payment;
  final String businessId;
  final String terminalId;

  UninstallTerminalDevicePaymentEvent({this.payment, this.businessId, this.terminalId});

  @override
  List<Object> get props => [
    this.payment,
    this.businessId,
    this.terminalId,
  ];
}

class UpdateDevicePaymentSettings extends PosScreenEvent{
  final DevicePaymentSettings settings;

  UpdateDevicePaymentSettings({this.settings});

  @override
  List<Object> get props => [
    this.settings,
  ];

}

class UpdateQRCodeSettings extends PosScreenEvent{
  final dynamic settings;

  UpdateQRCodeSettings({this.settings});

  @override
  List<Object> get props => [
    this.settings,
  ];

}

class SaveQRCodeSettings extends PosScreenEvent{
  final dynamic settings;
  final String businessId;

  SaveQRCodeSettings({this.settings, this.businessId,});

  @override
  List<Object> get props => [
    this.settings,
    this.businessId,
  ];

}

class SaveDevicePaymentSettings extends PosScreenEvent{
  final String businessId;
  final bool autoresponderEnabled;
  final bool secondFactor;
  final int verificationType;

  SaveDevicePaymentSettings({
    this.businessId,
    this.autoresponderEnabled,
    this.secondFactor,
    this.verificationType,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.autoresponderEnabled,
    this.secondFactor,
    this.verificationType,
  ];
}

class UploadTerminalImage extends PosScreenEvent{
  final File file;
  final String businessId;
  UploadTerminalImage({this.file, this.businessId});

  @override
  List<Object> get props => [
    this.file,
    this.businessId,
  ];
}

class UpdateBlobImage extends PosScreenEvent{
  final String logo;
  UpdateBlobImage({this.logo});

  @override
  List<Object> get props => [
    this.logo,
  ];
}

class CreatePosTerminalEvent extends PosScreenEvent{
  final String businessId;
  final String logo;
  final String name;
  CreatePosTerminalEvent({this.name, this.businessId, this.logo});

  @override
  List<Object> get props => [
    this.name,
    this.logo,
    this.businessId,
  ];
}

class UpdatePosTerminalEvent extends PosScreenEvent{
  final String logo;
  final String name;
  final String terminalId;
  UpdatePosTerminalEvent({this.name, this.logo, this.terminalId});

  @override
  List<Object> get props => [
    this.name,
    this.logo,
    this.terminalId,
  ];
}

class SetActiveTerminalEvent extends PosScreenEvent{
  final Terminal activeTerminal;
  final String businessId;

  SetActiveTerminalEvent({this.activeTerminal, this.businessId});

  @override
  List<Object> get props => [
    this.activeTerminal,
    this.businessId,
  ];
}

class SetDefaultTerminalEvent extends PosScreenEvent{
  final Terminal activeTerminal;
  final String businessId;

  SetDefaultTerminalEvent({this.activeTerminal, this.businessId});

  @override
  List<Object> get props => [
    this.activeTerminal,
    this.businessId,
  ];
}

class DeleteTerminalEvent extends PosScreenEvent{
  final Terminal activeTerminal;

  DeleteTerminalEvent({this.activeTerminal});

  @override
  List<Object> get props => [
    this.activeTerminal,
  ];
}

class GetPosTerminalsEvent extends PosScreenEvent {
  final Terminal activeTerminal;

  GetPosTerminalsEvent({
    this.activeTerminal,
  });

  @override
  List<Object> get props => [
    this.activeTerminal,
  ];
}

class CopyTerminalEvent extends PosScreenEvent {
  final String businessId;
  final Terminal terminal;

  CopyTerminalEvent({
    this.businessId,
    this.terminal,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.terminal,
  ];
}

class CopyBusinessEvent extends PosScreenEvent {
  final String businessId;

  CopyBusinessEvent({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GenerateQRCodeEvent extends PosScreenEvent {
  final String businessId;
  final String businessName;
  final String avatarUrl;
  final String id;
  final String url;

  GenerateQRCodeEvent({
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  ];
}

class GenerateQRSettingsEvent extends PosScreenEvent {
  final String businessId;
  final String businessName;
  final String avatarUrl;
  final String id;
  final String url;

  GenerateQRSettingsEvent({
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  ];
}

class GetTwilioSettings extends PosScreenEvent {
  final String businessId;

  GetTwilioSettings({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GetAddTwilioPhoneFrom extends PosScreenEvent {
  final String businessId;

  GetAddTwilioPhoneFrom({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class AddPhoneNumberSettings extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;

  AddPhoneNumberSettings({
    this.businessId,
    this.action,
    this.id,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
  ];
}

class RemovePhoneNumberSettings extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;
  final String sid;

  RemovePhoneNumberSettings({
    this.businessId,
    this.action,
    this.id,
    this.sid,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
    this.sid,
  ];
}

class SearchPhoneNumberEvent extends PosScreenEvent {
  final String businessId;
  final String action;
  final String country;
  final bool excludeAny;
  final bool excludeForeign;
  final bool excludeLocal;
  final String id;
  final String phoneNumber;

  SearchPhoneNumberEvent({
    this.businessId,
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
    this.businessId,
    this.action,
    this.country,
    this.excludeAny,
    this.excludeForeign,
    this.excludeLocal,
    this.id,
    this.phoneNumber,
  ];
}

class PurchaseNumberEvent extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;
  final String phone;
  final String price;

  PurchaseNumberEvent({
    this.businessId,
    this.action,
    this.id,
    this.phone,
    this.price,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
    this.phone,
    this.price,
  ];
}

class UpdateAddPhoneNumberSettings extends PosScreenEvent {
  final AddPhoneNumberSettingsModel settingsModel;

  UpdateAddPhoneNumberSettings({
    this.settingsModel,
  });

  @override
  List<Object> get props => [
    this.settingsModel,
  ];
}

class UpdateAddPhoneNumber extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;
  final String value;
  final String phone;

  UpdateAddPhoneNumber({
    this.businessId,
    this.action,
    this.id,
    this.value,
    this.phone,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
    this.value,
    this.phone,
  ];
}

class GetQRImage extends PosScreenEvent {
  final dynamic data;
  final String url;

  GetQRImage({
    this.data,
    this.url,
  });

  @override
  List<Object> get props => [
    this.data,
    this.url,
  ];
}

class RestoreQrCodeEvent extends PosScreenEvent{}

class UpdateChannelSetFlowEvent extends PosScreenEvent {
  final ChannelSetFlow channelSetFlow;
  UpdateChannelSetFlowEvent(this.channelSetFlow);

  @override
  List<Object> get props => [
    this.channelSetFlow,
  ];
}