import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/models/pos.dart';
import 'package:payever/commons/utils/common_utils.dart';
import '../bloc.dart';

class PosScreenBloc extends Bloc<PosScreenEvent, PosScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  PosScreenBloc({this.dashboardScreenBloc});
  ApiService api = ApiService();

  @override
  PosScreenState get initialState => PosScreenState();

  @override
  Stream<PosScreenState> mapEventToState(PosScreenEvent event) async* {
    if (event is PosScreenInitEvent) {
      yield state.copyWith(
          businessId: event.currentBusiness.id,
          activeBusiness: event.currentBusiness,
          channelSets: event.channelSets,
          activeTerminal: event.activeTerminal,
          terminals: event.terminals,
          defaultCheckout: event.defaultCheckout,
      );
      yield* fetchPos();
    } else if (event is GetPosIntegrationsEvent) {
      yield* getIntegrations();
    } else if (event is GetTerminalIntegrationsEvent) {
      yield* getTerminalIntegrations(event.businessId, event.terminalId);
    } else if (event is GetPosCommunications) {
      yield* getCommunications(event.businessId);
    } else if (event is GetPosDevicePaymentSettings) {
      yield* getDevicePaymentSettings(event.businessId);
    } else if (event is InstallDevicePaymentEvent) {
      yield* installDevicePayment(event.businessId);
    } else if (event is UninstallDevicePaymentEvent) {
      yield* uninstallDevicePayment(event.businessId);
    } else if (event is InstallQREvent) {
      yield* installQR(event.businessId, event.businessName, event.avatarUrl, event.url, event.id);
    } else if (event is UninstallQREvent) {
      yield* uninstallQR(event.businessId);
    } else if (event is InstallTwilioEvent) {
      yield* installTwilio(event.businessId);
    } else if (event is UninstallTwilioEvent) {
      yield* uninstallTwilio(event.businessId);
    } else if (event is InstallTerminalDevicePaymentEvent) {
      yield* installTerminalDevicePayment(event.payment, event.businessId, event.terminalId);
    } else if (event is UninstallTerminalDevicePaymentEvent) {
      yield* uninstallTerminalDevicePayment(event.payment, event.businessId, event.terminalId);
    } else if (event is UpdateDevicePaymentSettings) {
      yield state.copyWith(devicePaymentSettings: event.settings);
    } else if (event is SaveDevicePaymentSettings) {
      yield* saveDevicePaymentSettings(event.businessId, event.autoresponderEnabled, event.secondFactor, event.verificationType);
    } else if (event is UploadTerminalImage) {
      yield* uploadTerminalImage(event.businessId, event.file);
    } else if (event is CreatePosTerminalEvent) {
      yield* createTerminal(event.logo, event.name, event.businessId);
    } else if (event is UpdatePosTerminalEvent) {
      yield* updateTerminal(event.logo, event.name, event.terminalId);
    } else if (event is SetActiveTerminalEvent) {
      yield state.copyWith(activeTerminal: event.activeTerminal);
      yield* getTerminalIntegrations(event.businessId, event.activeTerminal.id);
    } else if (event is UpdateBlobImage) {
      yield state.copyWith(blobName: event.logo);
    } else if (event is SetDefaultTerminalEvent) {
      yield* activeTerminal(event.businessId, event.activeTerminal.id);
    } else if (event is DeleteTerminalEvent) {
      yield* deleteTerminal(event.activeTerminal.id);
    } else if (event is GetPosTerminalsEvent) {
      yield* fetchPos();
    } else if (event is CopyBusinessEvent) {
      yield state.copyWith(copiedBusiness: event.businessId, businessCopied: true);
    } else if (event is CopyTerminalEvent) {
      yield state.copyWith(copiedTerminal: event.terminal, terminalCopied: true);
    } else if (event is GetQRImage) {
      yield* getBlob(event.data, event.url);
    } else if (event is GenerateQRSettingsEvent) {
      yield* postGenerateQRSettings(event.businessId, event.businessName, event.avatarUrl, event.id, event.url);
    } else if (event is UpdateQRCodeSettings) {
      yield state.copyWith(fieldSetData: event.settings);
    } else if (event is SaveQRCodeSettings) {
      yield* saveQRCodeSettings(event.businessId, event.settings);
    } else if (event is GenerateQRCodeEvent) {
      yield* postGenerateQRCode(event.businessId, event.businessName,
          event.avatarUrl, event.id, event.url);
    } else if (event is GetTwilioSettings) {
      yield* getTwilioSettings(event.businessId);
    } else if (event is AddPhoneNumberSettings) {
      yield* addPhoneNumberSettings(event.businessId, event.action, event.id);
    } else if (event is SearchPhoneNumberEvent) {
      yield* searchPhoneNumbers(
        event.businessId,
        event.action,
        event.country,
        event.excludeAny,
        event.excludeForeign,
        event.excludeLocal,
        event.phoneNumber,
        event.id,
      );
    } else if (event is PurchaseNumberEvent) {
      yield* purchasePhoneNumber(event.businessId, event.action, event.phone, event.id, event.price);
    } else if (event is RemovePhoneNumberSettings) {
      yield* removePhoneNumber(event.businessId, event.action, event.id, event.sid);
    } else if (event is UpdateAddPhoneNumberSettings) {
      yield state.copyWith(settingsModel: event.settingsModel);
    } else if (event is RestoreQrCodeEvent) {
      yield* getPrefilledLink();
    } else if (event is UpdateChannelSetFlowEvent) {
      yield state.copyWith(channelSetFlow: event.channelSetFlow);
    }
  }

  Stream<PosScreenState> fetchPos() async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);
    List<Terminal> terminals = state.terminals;
    List<ChannelSet> channelSets = state.channelSets;
    // Get Terminals
    if (terminals == null || terminals.isEmpty) {
      dynamic terminalsObj = await api.getTerminal(state.businessId, token);
      if (terminalsObj is List) {
        terminalsObj.forEach((terminal) {
          terminals.add(Terminal.fromJson(terminal));
        });
      }
    }
    // Get ChannelSets
    if (channelSets == null || channelSets.isEmpty) {
      dynamic channelsObj = await api.getChannelSet(state.businessId, token);
      if (channelsObj is List) {
        channelsObj.forEach((channelSet) {
          channelSets.add(ChannelSet.fromJson(channelSet));
        });
      }
    }

    terminals.forEach((terminal) async {
      channelSets.forEach((channelSet) async {
        if (terminal.channelSet == channelSet.id) {
          if (terminal.paymentMethods == null || terminal.paymentMethods.isEmpty) {
            dynamic paymentObj = await api.getCheckoutIntegration(state.businessId, channelSet.checkout, token);
            if (paymentObj is List) {
              paymentObj.forEach((pm) {
                terminal.paymentMethods.add(pm);
              });
            }
          }

          if (terminal.paymentMethods == null) {
            dynamic daysObj = await api.getLastWeek(state.businessId, channelSet.id, token);
            if (daysObj is List) {
              int length = daysObj.length - 1;
              for (int i = length; i > length - 7; i--) {
                terminal.lastWeekAmount += Day.fromJson(daysObj[i]).amount;
              }
              daysObj.forEach((day) {
                terminal.lastWeek.add(Day.fromJson(day));
              });
            }
          }

          if (terminal.paymentMethods == null || terminal.paymentMethods.isEmpty) {
            dynamic productsObj = await api.getPopularWeek(state.businessId, channelSet.id, token);
            if (productsObj is List) {
              productsObj.forEach((product) {
                terminal.bestSales.add(Product.fromJson(product));
              });
            }
          }
        }
      });
    });
    if (terminals != null && terminals.isNotEmpty) {
      Terminal activeTerminal = terminals.firstWhere((element) => element.active);
      yield state.copyWith(activeTerminal: activeTerminal, terminals: terminals, terminalCopied: false, isLoading: false);
    } else {
      yield state.copyWith(terminals: terminals, terminalCopied: false, isLoading: false);
    }
    add(GetPosIntegrationsEvent());
  }

  Stream<PosScreenState> getIntegrations() async* {
    dynamic integrationObj = await api.getPosIntegrations(GlobalUtils.activeToken.accessToken, state.businessId);
    List<Communication> integrations = [];
    integrationObj.forEach((element) {
      integrations.add(Communication.fromJson(element));
    });
    yield state.copyWith(integrations: integrations);
    if (state.activeTerminal != null) {
      add(GetTerminalIntegrationsEvent(
          businessId: state.businessId, terminalId: state.activeTerminal.id));
    } else {
      print('There is no active Terminal');
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<PosScreenState> getTerminalIntegrations(String businessId, String terminalId) async* {
    dynamic integrationObj = await api.getTerminalIntegrations(GlobalUtils.activeToken.accessToken, businessId, terminalId);
    List<String> integrations = [];
    integrationObj.forEach((element) {
      integrations.add(element);
    });
    yield state.copyWith(terminalIntegrations: integrations, isLoading: false);
  }

  Stream<PosScreenState> getCommunications(String businessId) async* {
    dynamic communicationsObj = await api.getPosCommunications(GlobalUtils.activeToken.accessToken, businessId);
    List<Communication> communications = [];
    communicationsObj.forEach((element) {
      communications.add(Communication.fromJson(element));
    });
    yield state.copyWith(communications: communications);
  }

  Stream<PosScreenState> getDevicePaymentSettings(String businessId) async* {
    dynamic devicePaymentSettingsObj = await api.getPosDevicePaymentSettings(businessId, GlobalUtils.activeToken.accessToken);
    DevicePaymentSettings devicePayment = DevicePaymentSettings.fromJson(devicePaymentSettingsObj);
    yield state.copyWith(devicePaymentSettings: devicePayment, isLoading: false);
  }

  Stream<PosScreenState> installDevicePayment(String businessId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.patchPosConnectDevicePaymentInstall(GlobalUtils.activeToken.accessToken, businessId);
    add(GetPosIntegrationsEvent());
    add(GetPosDevicePaymentSettings(businessId: businessId));
  }

  Stream<PosScreenState> uninstallDevicePayment(String businessId) async* {
    dynamic response = await api.patchPosConnectDevicePaymentUninstall(GlobalUtils.activeToken.accessToken, businessId);
    add(GetPosIntegrationsEvent());
  }

  Stream<PosScreenState> installQR(String businessId, String businessName, String avatar, String url, String terminalId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.patchPosQrInstall(GlobalUtils.activeToken.accessToken, businessId);
    add(GetPosIntegrationsEvent());
    add(
      GenerateQRSettingsEvent(
        businessId: businessId,
        businessName: businessName,
        avatarUrl: avatar,
        id: terminalId,
        url: url,
      ),
    );
  }

  Stream<PosScreenState> uninstallQR(String businessId) async* {
    dynamic response = await api.patchPosQrUninstall(GlobalUtils.activeToken.accessToken, businessId);
    add(GetPosIntegrationsEvent());
  }

  Stream<PosScreenState> installTwilio(String businessId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.patchPosTwilioInstall(GlobalUtils.activeToken.accessToken, businessId);
    add(GetPosIntegrationsEvent());
    add(GetTwilioSettings(businessId: businessId));
  }

  Stream<PosScreenState> uninstallTwilio(String businessId) async* {
    dynamic response = await api.patchPosTwilioUninstall(GlobalUtils.activeToken.accessToken, businessId);
    add(GetPosIntegrationsEvent());
  }

  Stream<PosScreenState> installTerminalDevicePayment(String payment, String businessId, String terminalId) async* {
    List<String> terminalIntegrations = state.terminalIntegrations;
    terminalIntegrations.add(payment);
    yield state.copyWith(terminalIntegrations: terminalIntegrations);
    dynamic installPaymentObj = await api.patchPosTerminalDevicePaymentInstall(GlobalUtils.activeToken.accessToken, payment, businessId, terminalId);
    print(installPaymentObj);
    add(GetTerminalIntegrationsEvent(businessId: businessId, terminalId: terminalId));
  }

  Stream<PosScreenState> uninstallTerminalDevicePayment(String payment, String businessId, String terminalId) async* {
    List<String> terminalIntegrations = state.terminalIntegrations;
    terminalIntegrations.removeWhere((element) => element == payment);
    yield state.copyWith(terminalIntegrations: terminalIntegrations);
    dynamic installPaymentObj = await api.patchPosTerminalDevicePaymentUninstall(GlobalUtils.activeToken.accessToken, payment, businessId, terminalId);
    print(installPaymentObj);
    add(GetTerminalIntegrationsEvent(businessId: businessId, terminalId: terminalId));
  }

  Stream<PosScreenState> saveDevicePaymentSettings(String businessId, bool autoResponderEnabled, bool secondFactor, int verificationType) async* {
    yield state.copyWith(isUpdating: true);
    dynamic devicePaymentSettingsObj = await api.putDevicePaymentSettings(
      businessId,
      GlobalUtils.activeToken.accessToken,
      autoResponderEnabled,
      secondFactor,
      verificationType,
    );
    DevicePaymentSettings devicePayment = DevicePaymentSettings.fromJson(devicePaymentSettingsObj);
    yield state.copyWith(devicePaymentSettings: devicePayment, isLoading: false, isUpdating: false);
  }

  Stream<PosScreenState> uploadTerminalImage(String businessId, File file) async* {
    yield state.copyWith(blobName: '', isLoading: true);
    dynamic response = await api.postImageToBusiness(file, businessId, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isLoading: false);
  }

  Stream<PosScreenState> createTerminal(String logo, String name, String businessId) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.postTerminal(businessId, GlobalUtils.activeToken.accessToken, logo, name);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Create Terminal failed');
    }
    yield state.copyWith(blobName: '', isUpdating: false);
    yield* fetchPos();
  }

  Stream<PosScreenState> updateTerminal(String logo, String name, String terminalId) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.patchTerminal(state.businessId, GlobalUtils.activeToken.accessToken, logo, name, terminalId);
//    Terminal terminal = Terminal.toMap(response);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Update Terminal failed');
    }
    yield state.copyWith(blobName: '', isUpdating: false);
    yield* fetchPos();
  }

  Stream<PosScreenState> activeTerminal(String businessId, String terminalId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.patchActiveTerminal(GlobalUtils.activeToken.accessToken, businessId, terminalId);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Active Terminal failed');
    }
    yield* fetchPos();
  }

  Stream<PosScreenState> deleteTerminal(String terminalId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.deleteTerminal(GlobalUtils.activeToken.accessToken, state.businessId, terminalId);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Delete Terminal failed');
    }
    yield* fetchPos();
  }

  Stream<PosScreenState> postGenerateQRCode(
      String businessId,
      String businessName,
      String avatarUrl,
      String id,
      String url,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.postGenerateTerminalQRCode(
      GlobalUtils.activeToken.accessToken,
      businessId,
      businessName,
      avatarUrl,
      id,
      url,
    );
    String imageData;
    if (response is Map) {
      dynamic form = response['form'];
      String contentType = form['contentType'] != null
          ? form['contentType']
          : '';
      dynamic content = form['content'] != null ? form['content'] : null;
      if (content != null) {
        List<dynamic> contentData = content[contentType];
        for (int i = 0; i < contentData.length; i++) {
          dynamic data = content[contentType][i];
          if (data['data'] != null) {
            List<dynamic> list = data['data'];
            for (dynamic w in list) {
              if (w[0]['type'] == 'image') {
                imageData = w[0]['value'];
              }
            }
          }
        }
      }
    }

    yield state.copyWith(qrForm: response, isLoading: false);
    add(GetQRImage(url: imageData));
  }

  Stream<PosScreenState> getPrefilledLink() async* {
    if (state.channelSetFlow == null)
      return;
    yield state.copyWith(isLoading: true);
    Map<String, dynamic>flowBody = state.channelSetFlow.toJson();
    flowBody.remove('amount');
    Map<String, dynamic> data = {
      'flow': flowBody,
      'force_no_header': false,
      'force_no_order': true,
      'generate_payment_code': true,
      'source': 'qr',
    };

    dynamic qrcodelinkResponse = await api.getChannelSetQRcode(GlobalUtils.activeToken.accessToken, data);
    if (qrcodelinkResponse is Map) {
      String id = qrcodelinkResponse['id'];
      String prefilledLink = '${Env.wrapper}/pay/restore-flow-from-code/$id';
      print('prefilled link: $prefilledLink');
      dynamic response = await api.postGenerateTerminalQRCode(
        GlobalUtils.activeToken.accessToken,
        state.businessId,
        dashboardScreenBloc.state.activeBusiness.name,
        '$imageBase${dashboardScreenBloc.state.activeTerminal.logo}',
        dashboardScreenBloc.state.activeTerminal.id,
        prefilledLink,
      );

      String imageData;
      if (response is Map) {
        dynamic form = response['form'];
        String contentType =
        form['contentType'] != null ? form['contentType'] : '';
        dynamic content = form['content'] != null ? form['content'] : null;
        if (content != null) {
          List<dynamic> contentData = content[contentType];
          for (int i = 0; i < contentData.length; i++) {
            dynamic data = content[contentType][i];
            if (data['data'] != null) {
              List<dynamic> list = data['data'];
              for (dynamic w in list) {
                if (w[0]['type'] == 'image') {
                  imageData = w[0]['value'];
                }
              }
            }
          }
        }
      }
      yield state.copyWith(qrForm: response, isLoading: false);
      add(GetQRImage(url: imageData));
    } else {
      yield state.copyWith(isLoadingQrcode: false);
    }
  }

  Stream<PosScreenState> postGenerateQRSettings(
      String businessId,
      String businessName,
      String avatarUrl,
      String id,
      String url,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.postGenerateTerminalQRSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
      businessName,
      avatarUrl,
      id,
      url,
    );
    dynamic fieldsetData;
    if (response is Map) {
      dynamic form = response['form'];
      String contentType = form['contentType'] != null
          ? form['contentType']
          : '';
      dynamic content = form['content'] != null ? form['content'] : null;
      if (content != null) {
        List<dynamic> contentData = content[contentType];
        for (int i = 0; i < contentData.length; i++) {
          dynamic data = content[contentType][i];
          if (data['fieldsetData'] != null) {
            fieldsetData = data['fieldsetData'];
          }
        }
      }
    }
    yield state.copyWith(qrForm: response, fieldSetData: fieldsetData, isLoading: false);
    add(GetQRImage(data: fieldsetData));
  }

  Stream<PosScreenState> saveQRCodeSettings(
      String businessId,
      dynamic data,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.saveGenerateTerminalQRSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
      data
    );
    dynamic fieldsetData;
    if (response is Map) {
      dynamic form = response['form'];
      String contentType = form['contentType'] != null
          ? form['contentType']
          : '';
      dynamic content = form['content'] != null ? form['content'] : null;
      if (content != null) {
        List<dynamic> contentData = content[contentType];
        for (int i = 0; i < contentData.length; i++) {
          dynamic data = content[contentType][i];
          if (data['fieldsetData'] != null) {
            fieldsetData = data['fieldsetData'];
          } else if (data['data'] != null) {
            List<dynamic> list = data['data'];
            for (dynamic w in list) {
              if (w[0]['type'] == 'image') {
              }
            }
          }
        }
      }
    }

    yield state.copyWith(qrForm: response, fieldSetData: fieldsetData, isLoading: false);
    add(GetQRImage(data: fieldsetData));
  }

  Stream<PosScreenState> getTwilioSettings(
      String businessId,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getTwilioSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
    );
    yield state.copyWith(twilioForm: response, isLoading: false);
  }

  Stream<PosScreenState> addPhoneNumberSettings(
      String businessId,
      String action,
      String id,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.addPhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
      action,
      id,
    );
    List<CountryDropdownItem> dropdownItems = [];
    AddPhoneNumberSettingsModel model = AddPhoneNumberSettingsModel();
    dynamic fieldsetData = {};
    List contentData = [];
    if (response != null) {
      if (response is Map) {
        dynamic form = response['form'];
        if (form['actionContext'] is Map) {
          model.id = form['actionContext']['id'];
        } else if (form['actionContext'] is String){
          model.id = form['actionContext'];
        }
        dynamic content = form['content'] != null ? form['content'] : null;
        if (content != null) {
          if (content['fieldset'] != null) {
            List<dynamic> contentFields = content['fieldset'];
            contentFields.forEach((field) {
              if (field['type'] == 'select') {
                dynamic selectSettings = field['selectSettings'];
                if (selectSettings != null) {
                  if (selectSettings['options'] != null) {
                    List<dynamic> options = selectSettings['options'];
                    options.forEach((element) {
                      CountryDropdownItem item = CountryDropdownItem(
                          label: element['label'], value: element['value']);
                      if (!dropdownItems.contains(item)) {
                        dropdownItems.add(item);
                      }
                    });
                    print(content['fieldsetData']);
                  }
                }
              }
            });
          }
          if (content['fieldsetData'] != null) {
            fieldsetData = content['fieldsetData'];
            model.excludeLocal = fieldsetData['excludeLocal'];
            model.excludeForeign = fieldsetData['excludeForeign'];
          }

          if (content['data'] != null) {
            contentData = content['data'];
          }
        }
      }
    }
    model.country = dropdownItems.firstWhere((element) => element.value == fieldsetData['country']);

    yield state.copyWith(dropdownItems: dropdownItems, settingsModel: model, isLoading: false, twilioAddPhoneForm: contentData);
  }

  Stream<PosScreenState> searchPhoneNumbers(
      String businessId,
      String action,
      String country,
      bool excludeAny,
      bool excludeForeign,
      bool excludeLocal,
      String phoneNumber,
      String id,
      ) async* {
    yield state.copyWith(isSearching: true);
    dynamic response = await api.searchPhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
      action,
      country,
      excludeAny,
      excludeForeign,
      excludeLocal,
      phoneNumber,
      id,
    );
    List<CountryDropdownItem> dropdownItems = [];
    AddPhoneNumberSettingsModel model = AddPhoneNumberSettingsModel();
    dynamic fieldsetData = {};
    List contentData = [];
    if (response != null) {
      if (response is Map) {
        dynamic form = response['form'];
        if (form['actionContext'] is Map) {
          model.id = form['actionContext']['id'];
        } else if (form['actionContext'] is String){
          model.id = form['actionContext'];
        }
        dynamic content = form['content'] != null ? form['content'] : null;
        if (content != null) {
          if (content['fieldset'] != null) {
            List<dynamic> contentFields = content['fieldset'];
            contentFields.forEach((field) {
              if (field['type'] == 'select') {
                dynamic selectSettings = field['selectSettings'];
                if (selectSettings != null) {
                  if (selectSettings['options'] != null) {
                    List<dynamic> options = selectSettings['options'];
                    options.forEach((element) {
                      CountryDropdownItem item = CountryDropdownItem(
                          label: element['label'], value: element['value']);
                      if (!dropdownItems.contains(item)) {
                        dropdownItems.add(item);
                      }
                    });
                    print(content['fieldsetData']);
                  }
                }
              }
            });
          }
          if (content['fieldsetData'] != null) {
            fieldsetData = content['fieldsetData'];
            model.excludeLocal = fieldsetData['excludeLocal'];
            model.excludeForeign = fieldsetData['excludeForeign'];
          }

          if (content['data'] != null) {
            contentData = content['data'];
          }
        }
      }
    }
    model.country = dropdownItems.firstWhere((element) => element.value == fieldsetData['country']);

    yield state.copyWith(twilioAddPhoneForm: contentData, settingsModel: model, isSearching: false);
  }

  Stream<PosScreenState> purchasePhoneNumber(
      String businessId,
      String action,
      String phone,
      String id,
      String price,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.purchasePhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
      action,
      phone,
      id,
      price,
    );
    yield state.copyWith(isLoading: false);
    add(GetTwilioSettings(businessId: businessId));
  }

  Stream<PosScreenState> removePhoneNumber(
      String businessId,
      String action,
      String id,
      String sid,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.removePhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      businessId,
      action,
      id,
      sid,
    );
    yield state.copyWith(twilioForm: response, isLoading: false);
  }

  Stream<PosScreenState> getBlob(dynamic w, String url) async* {
    print('qrcode url: $url');
    http.Response response =  await api.getQrcode(GlobalUtils.activeToken.accessToken, url, w);
    if (response is http.Response) {
      print('qrcode url: $url');
      yield state.copyWith(qrImage: response.bodyBytes);
    }
  }
}