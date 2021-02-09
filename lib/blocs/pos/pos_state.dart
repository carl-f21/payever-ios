import 'package:flutter/cupertino.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';

class PosScreenState {
  final bool isLoading;
  final bool isLoadingQrcode; // & Cart Progress Flag
  final bool isSearching;
  final String businessId;
  final List<Terminal> terminals;
  final List<ChannelSet> channelSets;
  final Business activeBusiness;
  final Checkout defaultCheckout;
  final Terminal activeTerminal;
  final ChannelSetFlow channelSetFlow;
  final bool businessCopied;
  final bool terminalCopied;
  final List<Communication> integrations;
  final List<Communication> communications;
  final DevicePaymentSettings devicePaymentSettings;
  final bool showCommunications;
  final List<String> terminalIntegrations;
  final String blobName;
  final bool isUpdating;
  final String copiedBusiness;
  final Terminal copiedTerminal;
  final dynamic qrForm;
  final dynamic twilioForm;
  final List twilioAddPhoneForm;
  final AddPhoneNumberSettingsModel settingsModel;
  final List<CountryDropdownItem> dropdownItems;
  final dynamic fieldSetData;
  final dynamic qrImage;

  PosScreenState({
    this.isLoading = true,
    this.isUpdating = false,
    this.isSearching = false,
    this.isLoadingQrcode = false,
    this.activeBusiness,
    this.defaultCheckout,
    this.channelSetFlow,
    this.terminals = const [],
    this.channelSets = const [],
    this.activeTerminal,
    this.businessId,
    this.businessCopied = false,
    this.terminalCopied = false,
    this.integrations = const [],
    this.terminalIntegrations = const [],
    this.communications = const [],
    this.devicePaymentSettings,
    this.showCommunications = false,
    this.blobName = '',
    this.copiedBusiness,
    this.copiedTerminal,
    this.qrForm,
    this.twilioForm,
    this.twilioAddPhoneForm = const [],
    this.settingsModel,
    this.dropdownItems = const [],
    this.fieldSetData,
    this.qrImage,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isSearching,
    this.isLoadingQrcode,
    this.terminals,
    this.channelSets,
    this.activeBusiness,
    this.defaultCheckout,
    this.channelSetFlow,
    this.businessId,
    this.activeTerminal,
    this.businessCopied,
    this.terminalCopied,
    this.integrations,
    this.terminalIntegrations,
    this.communications,
    this.devicePaymentSettings,
    this.showCommunications,
    this.blobName,
    this.copiedBusiness,
    this.copiedTerminal,
    this.qrForm,
    this.twilioForm,
    this.twilioAddPhoneForm,
    this.settingsModel,
    this.dropdownItems,
    this.fieldSetData,
    this.qrImage,
  ];

  PosScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isSearching,
    bool isLoadingQrcode,
    Business activeBusiness,
    Checkout defaultCheckout,
    ChannelSetFlow channelSetFlow,
    String businessId,
    List<Terminal> terminals,
    List<ChannelSet> channelSets,
    Terminal activeTerminal,
    bool businessCopied,
    bool terminalCopied,
    List<Communication> integrations,
    List<String> terminalIntegrations,
    List<Communication> communications,
    DevicePaymentSettings devicePaymentSettings,
    bool showCommunications,
    String blobName,
    Terminal copiedTerminal,
    String copiedBusiness,
    dynamic qrForm,
    dynamic twilioForm,
    List twilioAddPhoneForm,
    AddPhoneNumberSettingsModel settingsModel,
    List<CountryDropdownItem> dropdownItems,
    dynamic fieldSetData,
    dynamic qrImage,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isSearching: isSearching ?? this.isSearching,
      isLoadingQrcode: isLoadingQrcode ?? this.isLoadingQrcode,
      activeBusiness: activeBusiness ?? this.activeBusiness,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      terminals: terminals ?? this.terminals,
      channelSets: channelSets ?? this.channelSets,
      businessId: businessId ?? this.businessId,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      businessCopied: businessCopied ?? this.businessCopied,
      terminalCopied: terminalCopied ?? this.terminalCopied,
      integrations: integrations ?? this.integrations,
      terminalIntegrations: terminalIntegrations ?? this.terminalIntegrations,
      communications: communications ?? this.communications,
      devicePaymentSettings: devicePaymentSettings ?? this.devicePaymentSettings,
      showCommunications: showCommunications ?? this.showCommunications,
      blobName: blobName ?? this.blobName,
      copiedBusiness: copiedBusiness,
      copiedTerminal: copiedTerminal,
      qrForm: qrForm ?? this.qrForm,
      twilioForm: twilioForm ?? this.twilioForm,
      twilioAddPhoneForm: twilioAddPhoneForm ?? this.twilioAddPhoneForm,
      settingsModel: settingsModel ?? this.settingsModel,
      dropdownItems: dropdownItems ?? this.dropdownItems,
      fieldSetData: fieldSetData ?? this.fieldSetData,
      qrImage: qrImage ?? this.qrImage,
    );
  }
}

class PosScreenSuccess extends PosScreenState {}

class PosScreenFailure extends PosScreenState {
  final String error;

  PosScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'PosScreenFailure { error $error }';
  }
}
class DevicePaymentInstallSuccess extends PosScreenState {
  final DevicePaymentInstall install;

  DevicePaymentInstallSuccess({ this.install}) : super();

  @override
  String toString() {
    return 'DevicePaymentInstallSuccess { error $install }';
  }
}