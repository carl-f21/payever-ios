import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:http/http.dart' as http;
import 'package:payever/theme.dart';

import 'checkout.dart';

class CheckoutScreenBloc extends Bloc<CheckoutScreenEvent, CheckoutScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;

  CheckoutScreenBloc({this.dashboardScreenBloc, this.globalStateModel});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutScreenState get initialState => CheckoutScreenState();

  @override
  Stream<CheckoutScreenState> mapEventToState(
      CheckoutScreenEvent event) async* {
    if (event is CheckoutScreenInitEvent) {
      yield state.copyWith(
        activeBusiness: event.business,
        activeTerminal: event.terminal,
        checkouts: event.checkouts,
        defaultCheckout: event.defaultCheckout,
        channelSets: event.channelSets,
      );
      yield* fetchConnectInstallations(state.activeBusiness.id, isLoading: true);
    } else if (event is GetPaymentConfig) {
      yield* getPaymentData();
    } else if (event is GetChannelConfig) {
      yield* getChannelConfig();
    } else if (event is GetConnectConfig) {
      yield* getConnectConfig();
    } else if (event is GetChannelSet) {
      yield* getCheckoutFlow();
    } else if (event is ReorderSection1Event) {
      yield* reorderSections1(event.oldIndex, event.newIndex);
    } else if (event is ReorderSection2Event) {
      yield* reorderSections2(event.oldIndex, event.newIndex);
    } else if (event is GetSectionDetails) {
      yield* getSectionDetails();
    } else if (event is UpdateCheckoutSections) {
      yield* updateCheckoutSections();
    } else if (event is AddSectionEvent) {
      yield state.copyWith(addSection: event.section,);
      yield* getAvailableSections();
    } else if (event is RemoveSectionEvent) {
      yield* removeSection(event.section);
    } else if (event is AddSectionToStepEvent) {
      yield* addSection(event.section, event.step);
    } else if (event is GetOpenUrlEvent) {
      yield state.copyWith(openUrl: event.openUrl);
    } else if (event is FinanceExpressTypeEvent) {
      yield* getFinanceExpressType(event.type);
    } else if (event is UpdateFinanceExpressTypeEvent) {
      yield* updateFinanceExpressType(event.type);
    } else if (event is GetQrIntegration) {
      yield* getQrIntegration();
    } else if (event is ClearQrIntegration) {
      yield state.copyWith(qrForm: null, qrImage: null, qrIntegration: null);
    } else if (event is GetDevicePaymentSettings) {
      yield* getDevicePaymentSettings(state.activeBusiness.id);
    } else if (event is UpdateCheckoutDevicePaymentSettings) {
      yield state.copyWith(devicePaymentSettings: event.settings);
    } else if (event is SaveCheckoutDevicePaymentSettings) {
      yield* saveDevicePaymentSettings();
    } else if (event is GetCheckoutTwilioSettings) {
      yield* getTwilioSettings();
    } else if (event is AddCheckoutPhoneNumberSettings) {
      yield* addPhoneNumberSettings(event.action, event.id);
    } else if (event is SearchCheckoutPhoneNumberEvent) {
      yield* searchPhoneNumbers(
        event.action,
        event.country,
        event.excludeAny,
        event.excludeForeign,
        event.excludeLocal,
        event.phoneNumber,
        event.id,
      );
    } else if (event is PurchaseCheckoutNumberEvent) {
      yield* purchasePhoneNumber(event.action, event.phone, event.id, event.price);
    } else if (event is RemoveCheckoutPhoneNumberSettings) {
      yield* removePhoneNumber(event.action, event.id, event.sid);
    } else if (event is UpdateCheckoutAddPhoneNumberSettings) {
      yield state.copyWith(settingsModel: event.settingsModel);
    } else if (event is InstallCheckoutPaymentEvent) {
      yield* installPayment(event.integrationModel);
    } else if (event is UninstallCheckoutPaymentEvent) {
      yield* uninstallPayment(event.integrationModel);
    } else if (event is InstallCheckoutIntegrationEvent) {
      yield* installIntegration(event.integrationId);
    } else if (event is BusinessUploadEvent) {
      yield* uploadBusiness(event.body);
    } else if (event is CheckoutUpdateChannelSetFlowEvent) {
      yield state.copyWith(channelSetFlow: event.channelSetFlow);
    } else if (event is CheckoutGetPrefilledLinkEvent) {
      yield* getPrefilledLink(event.isCopyLink);
    } else if (event is CheckoutGetPrefilledQRCodeEvent) {
      yield* getPrefilledQrcode();
    }
  }

  Stream<CheckoutScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);

    List<Checkout> checkouts = state.checkouts;
    List<String> integrations = [];
    Checkout defaultCheckout;
    if (checkouts == null || checkouts.isEmpty) {
      dynamic checkoutsResponse = await api.getCheckout(token, business);
      if (checkoutsResponse is List) {
        checkoutsResponse.forEach((element) {
          checkouts.add(Checkout.fromJson(element));
        });
      }
    }

    if (state.defaultCheckout == null) {
      List defaults = checkouts.where((element) => element.isDefault).toList();

      if (defaults.length > 0) {
        defaultCheckout = defaults.first;
      } else {
        if (checkouts.length > 0) {
          defaultCheckout = checkouts.first;
        }
      }
    } else {
      defaultCheckout = state.defaultCheckout;
    }

    if (defaultCheckout != null) {
      dynamic integrationsResponse = await api.getCheckoutIntegration(
          business, defaultCheckout.id, token);

      if (integrationsResponse is List) {
        integrationsResponse.forEach((element) {
          integrations.add(element);
        });
      }
    }

    await api.toggleSetUpStatus(token, business, 'checkout');
    dynamic response = await api.getAvailableSections(
        token, state.activeBusiness.id, defaultCheckout.id);
    List<Section> availableSections = [];
    if (response is List) {
      response.forEach((element) {
        availableSections.add(Section.fromJson(element));
      });
    }
    Map<String, PaymentVariant> paymentVariants = {};
    dynamic paymentVariantsResponse = await api.getPaymentVariants(
        token, business);
    if (paymentVariantsResponse is Map) {
      paymentVariantsResponse.keys.toList().forEach((key) {
        dynamic value = paymentVariantsResponse[key];
        if (value is Map) {
          PaymentVariant variant = PaymentVariant.fromMap(value);
          if (variant != null) {
            paymentVariants[key] = variant;
          }
        }
      });
    }

    yield state.copyWith(
      checkouts: checkouts,
      integrations: integrations,
      defaultCheckout: defaultCheckout,
      availableSections: availableSections,
      paymentVariants: paymentVariants,
    );

    add(GetChannelSet());
  }

  Stream<CheckoutScreenState> getCheckoutFlow() async* {
    List<ChannelSet> channelSets = state.channelSets;
    if (channelSets == null || channelSets.isEmpty) {
      print('get ChannelSets...');
      dynamic channelSetResponse = await api.getChannelSet(state.activeBusiness.id, token);
      if (channelSetResponse is List) {
        channelSetResponse.forEach((element) {
          ChannelSet channelSet = ChannelSet.fromJson(element);
          if (channelSet.checkout != null &&
              channelSet.checkout == state.defaultCheckout.id)
            channelSets.add(ChannelSet.fromJson(element));
        });
      }
    }

    ChannelSet channelSet = channelSets.firstWhere((element) =>
    (element.checkout == state.defaultCheckout.id && element.type == 'link'));

    CheckoutFlow checkoutFlow;
    dynamic channelFlowResponse = await api.getCheckoutChannelFlow(
        token, channelSet.id);
    if (channelFlowResponse is Map) {
      checkoutFlow = CheckoutFlow.fromJson(channelFlowResponse);
    }
    yield state.copyWith(
      channelSets: channelSets,
      channelSet: channelSet,
      checkoutFlow: checkoutFlow,
      isLoading: false,
    );
  }

  Stream<CheckoutScreenState> getPaymentData() async* {
    yield state.copyWith(loadingPaymentOption: true);
    List<ConnectModel> integrations = [];
    dynamic integrationsResponse = await api.getCheckoutIntegrations(
        state.activeBusiness.id, token);
    if (integrationsResponse is List) {
      integrationsResponse.forEach((element) {
        integrations.add(ConnectModel.toMap(element));
      });
    }

    List<IntegrationModel> connections = [];
    List<IntegrationModel> checkoutConnections = [];

    dynamic connectionResponse = await api.getConnections(
        state.activeBusiness.id, token);
    if (connectionResponse is List) {
      connectionResponse.forEach((element) {
        connections.add(IntegrationModel.fromJson(element));
      });
    }

    dynamic checkoutConnectionResponse = await api.getCheckoutConnections(
        state.activeBusiness.id, token, state.defaultCheckout.id);
    if (checkoutConnectionResponse is List) {
      checkoutConnectionResponse.forEach((element) {
        checkoutConnections.add(IntegrationModel.fromJson(element));
      });
    }

    yield state.copyWith(
      loadingPaymentOption: false,
      connects: integrations,
      connections: connections,
      checkoutConnections: checkoutConnections,
    );
  }

  Stream<CheckoutScreenState> getChannelConfig() async* {
    if (state.channelItems.length == 0) {
      yield state.copyWith(
        loadingChannel: true,
      );
    }
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(
        token, state.activeBusiness.id, 'shopsystems');
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    List<BusinessApps> businessApps = [];
    businessApps.addAll(dashboardScreenBloc.state.businessWidgets);

    List<ChannelItem> items = [];
    List<String> titles = [];
    List<ChannelSet> list = [];
    list.addAll(state.channelSets);
    for (ChannelSet channelSet in list) {
      if (!titles.contains(channelSet.type)) {
        titles.add(channelSet.type);
      }
    }
    for (String title in titles) {
      if (title == 'link') {
        ChannelItem item = new ChannelItem(
          title: 'Pay by Link',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pay_link.svg', height: 24, color: iconColor(),),
        );
        items.insert(0, item);
      } else if (title == 'finance_express') {
        ChannelItem item1 = new ChannelItem(
          title: 'Text Link',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pay_link.svg', height: 24, color: iconColor()),
        );
        items.add(item1);
        ChannelItem item2 = new ChannelItem(
          title: 'Button',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/button.svg', height: 24, color: iconColor()),
        );
        items.add(item2);
        ChannelItem item3 = new ChannelItem(
            title: 'Calculator',
            button: 'Edit',
            checkValue: null,
            image: SvgPicture.asset('assets/images/calculator.svg', height: 24, color: iconColor())
        );
        items.add(item3);
        ChannelItem item4 = new ChannelItem(
          title: 'Bubble',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/bubble.svg', height: 24, color: iconColor()),
        );
        items.add(item4);
      } else if (title == 'marketing') {
        ChannelItem item = new ChannelItem(
          title: 'Mail',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/mailicon.svg', height: 24, color: iconColor()),
        );
        items.add(item);
      } else if (title == 'pos') {
        ChannelItem item = new ChannelItem(
          title: 'Point of Sale',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pos.svg', height: 24, color: iconColor()),
        );
        items.add(item);
      } else if (title == 'shop') {
        ChannelItem item = new ChannelItem(
          title: 'Shop',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/shopicon.svg', height: 24, color: iconColor()),
        );
        items.add(item);
      } else {
        ConnectModel connectModel = connectInstallations.firstWhere((
            element) => element.integration.name == title);
        if (connectModel != null) {
          String iconType = connectModel.integration.displayOptions.icon ?? '';
          iconType = iconType.replaceAll('#icon-', '');
          iconType = iconType.replaceAll('#', '');

          ChannelItem item = new ChannelItem(
            title: Language.getPosConnectStrings(
                connectModel.integration.displayOptions.title),
            button: 'Open',
            checkValue: connectModel.installed,
            image: SvgPicture.asset(
              Measurements.channelIcon(iconType), height: 24, color: iconColor()),
            model: connectModel,
          );
          items.add(item);
        }
      }
    }

    yield state.copyWith(
      loadingChannel: false,
      channelItems: items,
    );
  }

  Stream<CheckoutScreenState> getConnectConfig() async* {
    yield state.copyWith(
      loadingConnect: true,
    );
    List<ConnectModel> connectInstallations = [];
    dynamic accountingResponse = await api.getConnectIntegrationByCategory(
        token, state.activeBusiness.id, 'accounting');
    if (accountingResponse is List) {
      accountingResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    dynamic categoryResponse = await api.getConnectIntegrationByCategory(
        token, state.activeBusiness.id, 'communications');
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    List<BusinessApps> businessApps = [];
    businessApps.addAll(dashboardScreenBloc.state.businessWidgets);

    List<ChannelItem> items = [];
    for (ConnectModel connectModel in connectInstallations) {
      if (connectModel != null) {
        String iconType = connectModel.integration.displayOptions.icon ?? '';
        iconType = iconType.replaceAll('#icon-', '');
        iconType = iconType.replaceAll('#', '');

        ChannelItem item = new ChannelItem(
          name:connectModel.integration.name,
          title: Language.getPosConnectStrings(
              connectModel.integration.displayOptions.title),
          button: 'Open',
          checkValue: connectModel.installed,
          image: SvgPicture.asset(
            Measurements.channelIcon(iconType), height: 24, color:iconColor()
          ),
        );
        items.add(item);
      }
    }

    yield state.copyWith(
      loadingConnect: false,
      connectItems: items,
    );
  }

  Stream<CheckoutScreenState> getSectionDetails() async* {
    if (state.checkoutFlow == null) {
      return;
    }

    List<Section> sections = [];
    List<Section> sections1 = [];
    List<Section> sections2 = [];
    sections.addAll(state.checkoutFlow.sections);
    for (int i = 0; i < sections.length; i++) {
      Section section = sections[i];
      if (section.code == 'order') {
        sections1.add(section);
      } else if (section.code == 'send_to_device') {
        sections1.add(section);
      } else if (section.code == 'choosePayment') {
        sections2.add(section);
      } else if (section.code == 'payment') {
        sections2.add(section);
      } else if (section.code == 'address') {
        sections2.add(section);
      } else if (section.code == 'user') {
        sections2.add(section);
      }
    }

    yield state.copyWith(
      sections1: sections1,
      sections2: sections2,
    );
  }

  Stream<CheckoutScreenState> updateCheckoutSections() async* {
    yield state.copyWith(
      sectionUpdate: true,
    );

    List<Section> sections = [];
    sections.addAll(state.sections1);
    sections.addAll(state.sections2);
    Map<String, dynamic> body = {};
    List<Map<String, dynamic>> sectionMapList = [];
    sections.forEach((section) {
      sectionMapList.add(section.toJson());
    });

    body['sections'] = sectionMapList;
    dynamic sectionsResponse = await api.patchCheckout(
        token, state.activeBusiness.id, state.defaultCheckout.id, body);

    ChannelSet channelSet = state.channelSets.firstWhere((element) =>
    (element.checkout == state.defaultCheckout.id && element.type == 'link'));
    CheckoutFlow checkoutFlow;
    dynamic channelFlowResponse = await api.getCheckoutChannelFlow(
        token, channelSet.id);
    if (channelFlowResponse is Map) {
      checkoutFlow = CheckoutFlow.fromJson(channelFlowResponse);
    }

    yield state.copyWith(
      sectionUpdate: false,
      checkoutFlow: checkoutFlow,
    );
  }

  Stream<CheckoutScreenState> reorderSections1(int oldIndex,
      int newIndex) async* {
    List<Section> sections1 = [];
    sections1.addAll(state.sections1);
    final item = sections1[oldIndex];
    sections1.removeAt(oldIndex);
    sections1.insert(newIndex, item);

    yield state.copyWith(sections1: sections1);
  }

  Stream<CheckoutScreenState> reorderSections2(int oldIndex,
      int newIndex) async* {
    List<Section> sections2 = [];
    sections2.addAll(state.sections2);
    final item = sections2[oldIndex];
    sections2.removeAt(oldIndex);
    sections2.insert(newIndex, item);

    yield state.copyWith(sections2: sections2);
  }

  Stream<CheckoutScreenState> getAvailableSections() async* {
    List<Section> availableSections = [];
    availableSections.addAll(state.availableSections);
    List<Section> available1 = [];
    List<Section> available2 = [];

    if (state.sections1.length > 1) {
    } else {
      List list = availableSections.where((element) =>
      element.code == 'send_to_device').toList();
      if (list.length > 0) {
        available1.add(list.first);
      }
    }

    print('Available Step1 => ${available1.toList()}');
    if (state.sections2.length > 3) {
    } else {
      List listUser = availableSections.where((element) =>
      element.code == 'user').toList();
      List listAddress = availableSections.where((element) =>
      element.code == 'address').toList();
      if (state.sections2
          .where((element) => element.code == 'user')
          .toList()
          .length == 0) {
        if (listUser.length > 0) {
          available2.add(listUser.first);
        }
      }
      if (state.sections2
          .where((element) => element.code == 'address')
          .toList()
          .length == 0) {
        if (listUser.length > 0) {
          available2.add(listAddress.first);
        }
      }

    }
    yield state.copyWith(availableSections1: available1, availableSections2: available2);
  }

  Stream<CheckoutScreenState> removeSection(Section section) async* {
    List<Section> section1 = [];
    List<Section> section2 = [];
    section1.addAll(state.sections1);
    section2.addAll(state.sections2);
    if (section.code == 'user') {
      int index = section2.indexWhere((element) => element.code == 'user');
      if (index >= 0) {
        section2.removeAt(index);
      }
    } else if (section.code == 'address') {
      int index = section2.indexWhere((element) => element.code == 'address');
      if (index >= 0) {
        section2.removeAt(index);
      }
    } else if (section.code == 'send_to_device') {
      int index = section1.indexWhere((element) => element.code == 'send_to_device');
      if (index >= 0) {
        section1.removeAt(index);
      }
    }

    yield state.copyWith(sections1: section1, sections2: section2);
  }

  Stream<CheckoutScreenState> addSection(Section section, int step) async* {
    List<Section> section1 = [];
    List<Section> section2 = [];
    section1.addAll(state.sections1);
    section2.addAll(state.sections2);
    if (step == 1) {
      if (section.code == 'send_to_device') {
        section1.add(section);
      }
    } else {
      if (section.code == 'user') {
        section2.add(section);
      } else if (section.code == 'address') {
        section2.add(section);
      }
    }

    yield state.copyWith(sections1: section1, sections2: section2);
    add(AddSectionEvent(section: step));
  }

  Stream<CheckoutScreenState> getFinanceExpressType(Finance type) async* {
    yield state.copyWith(isLoading: true);
    ChannelSet channelSetFinance = state.channelSets.firstWhere((element) =>
    (element.checkout == state.defaultCheckout.id && element.type == 'finance_express'));
    if (channelSetFinance == null || channelSetFinance.id == null) {
      yield CheckoutScreenStateFailure(error: 'Something wrong!');
      return;
    }
    switch(type) {
      case Finance.TEXT_LINK:
        if (state.financeTextLink != null) {
          yield state.copyWith(isLoading: false);
        } else {
          dynamic response = await api.getFinanceExpressSettings(channelSetFinance.id,
              FinanceType[type]);
          if (response is DioError) {
            yield CheckoutScreenStateFailure(error: response.message);
          } else if (response is Map) {
            FinanceExpress express = FinanceExpress.fromJson(response);
            yield state.copyWith(isLoading: false, financeTextLink: express);
          } else {
            yield CheckoutScreenStateFailure(error: 'Something wrong!');
          }
        }
        break;
      case Finance.BUTTON:
        if (state.financeButton != null) {
          yield state.copyWith(isLoading: false);
        } else {
          dynamic response = await api.getFinanceExpressSettings(channelSetFinance.id,
              FinanceType[type]);
          if (response is DioError) {
            yield CheckoutScreenStateFailure(error: response.message);
          } else if (response is Map) {
            FinanceExpress express = FinanceExpress.fromJson(response);
            yield state.copyWith(isLoading: false, financeButton: express);
          } else {
            yield CheckoutScreenStateFailure(error: 'Something wrong!');
          }
        }
        break;
      case Finance.CALCULATOR:
        if (state.financeCalculator != null) {
          yield state.copyWith(isLoading: false);
        } else {
          dynamic response = await api.getFinanceExpressSettings(channelSetFinance.id,
              FinanceType[type]);
          if (response is DioError) {
            yield CheckoutScreenStateFailure(error: response.message);
          } else if (response is Map) {
            FinanceExpress express = FinanceExpress.fromJson(response);
            yield state.copyWith(isLoading: false, financeCalculator: express);
          } else {
            yield state.copyWith(isLoading: false, financeCalculator: FinanceExpress());
          }
        }
        break;
      case Finance.BUBBLE:
        if (state.financeBubble != null) {
          yield state.copyWith(isLoading: false);
        } else {
          dynamic response = await api.getFinanceExpressSettings(channelSetFinance.id,
              FinanceType[type]);
          if (response is DioError) {
            yield CheckoutScreenStateFailure(error: response.message);
          } else if (response is Map) {
            FinanceExpress express = FinanceExpress.fromJson(response);
            yield state.copyWith(isLoading: false, financeBubble: express);
          } else {
            yield state.copyWith(isLoading: false, financeBubble: FinanceExpress());
          }
        }
        break;
    }
  }

  Stream<CheckoutScreenState> updateFinanceExpressType(Finance type) async* {
    yield state.copyWith(isUpdating: true);
    ChannelSet channelSetFinance = state.channelSets.firstWhere((element) =>
    (element.checkout == state.defaultCheckout.id && element.type == 'finance_express'));
    if (channelSetFinance == null || channelSetFinance.id == null) {
      yield CheckoutScreenStateFailure(error: 'Something wrong!');
      return;
    }
    switch(type) {
      case Finance.TEXT_LINK:
          Map<String, dynamic>body = state.financeTextLink.toJson();
          dynamic response = await api.updateFinanceExpressSettings(channelSetFinance.id,
              FinanceType[type], body);
          if (response is DioError) {
            yield CheckoutScreenStateFailure(error: response.message);
          } else if (response is Map) {
            yield state.copyWith(isUpdating: false,);
          } else {
            yield CheckoutScreenStateFailure(error: 'Something wrong!');
          }
        break;
      case Finance.BUTTON:
        Map<String, dynamic>body = state.financeButton.toJson();
        dynamic response = await api.updateFinanceExpressSettings(channelSetFinance.id,
            FinanceType[type], body);
        if (response is DioError) {
          yield CheckoutScreenStateFailure(error: response.message);
        } else if (response is Map) {
          yield state.copyWith(isUpdating: false,);
        } else {
          yield CheckoutScreenStateFailure(error: 'Something wrong!');
        }
        break;
      case Finance.CALCULATOR:
        Map<String, dynamic>body = state.financeCalculator.toJson();
        dynamic response = await api.updateFinanceExpressSettings(channelSetFinance.id,
            FinanceType[type], body);
        if (response is DioError) {
          yield CheckoutScreenStateFailure(error: response.message);
        } else if (response is Map) {
          yield state.copyWith(isUpdating: false,);
        } else {
          yield CheckoutScreenStateFailure(error: 'Something wrong!');
        }
        break;
      case Finance.BUBBLE:
        Map<String, dynamic>body = state.financeBubble.toJson();
        dynamic response = await api.updateFinanceExpressSettings(channelSetFinance.id,
            FinanceType[type], body);
        if (response is DioError) {
          yield CheckoutScreenStateFailure(error: response.message);
        } else if (response is Map) {
          yield state.copyWith(isUpdating: false,);
        } else {
          yield CheckoutScreenStateFailure(error: 'Something wrong!');
        }
        break;
    }
  }

  Stream<CheckoutScreenState> getQrIntegration() async* {
    ConnectIntegration integration;
    dynamic integrationResponse = await api.getConnectIntegration(token, 'qr');
    if (integrationResponse is Map) {
      integration = ConnectIntegration.toMap(integrationResponse);
    }

    if (state.activeTerminal == null) {
      return;
    }

    dynamic response = await api.postGenerateTerminalQRCode(
      GlobalUtils.activeToken.accessToken,
      state.activeBusiness.id,
      state.activeBusiness.name,
      '$imageBase${state.activeTerminal.logo}',
      state.activeTerminal.id,
      '${Env.checkout}/pay/create-flow-from-qr/channel-set-id/${state.activeTerminal.channelSet}',
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
    http.Response qrResponse;
    if (imageData != null) {
      var headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${GlobalUtils.activeToken.accessToken}',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
      };
      print('url => $imageData');
      qrResponse = await http.get(
        imageData,
        headers:  headers,
      );
    }
    yield state.copyWith(qrIntegration: integration, qrForm: response, qrImage: qrResponse.bodyBytes);

  }

  Stream<CheckoutScreenState> getDevicePaymentSettings(String businessId) async* {
    dynamic devicePaymentSettingsObj = await api.getPosDevicePaymentSettings(businessId, GlobalUtils.activeToken.accessToken);
    DevicePaymentSettings devicePayment = DevicePaymentSettings.fromJson(devicePaymentSettingsObj);
    yield state.copyWith(devicePaymentSettings: devicePayment,);
  }

  Stream<CheckoutScreenState> saveDevicePaymentSettings() async* {
    yield state.copyWith(isUpdating: true);
    dynamic devicePaymentSettingsObj = await api.putDevicePaymentSettings(
      state.activeBusiness.id,
      GlobalUtils.activeToken.accessToken,
      state.devicePaymentSettings.autoresponderEnabled,
      state.devicePaymentSettings.secondFactor,
      state.devicePaymentSettings.verificationType,
    );
    DevicePaymentSettings devicePayment = DevicePaymentSettings.fromJson(devicePaymentSettingsObj);
    yield state.copyWith(devicePaymentSettings: devicePayment, isLoading: false, isUpdating: false);
  }


  Stream<CheckoutScreenState> getTwilioSettings() async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getTwilioSettings(
      GlobalUtils.activeToken.accessToken,
      state.activeBusiness.id,
    );
    yield state.copyWith(twilioForm: response, isLoading: false);
  }

  Stream<CheckoutScreenState> addPhoneNumberSettings(
      String action,
      String id,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.addPhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      state.activeBusiness.id,
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

  Stream<CheckoutScreenState> searchPhoneNumbers(
      String action,
      String country,
      bool excludeAny,
      bool excludeForeign,
      bool excludeLocal,
      String phoneNumber,
      String id,
      ) async* {
    yield state.copyWith(isPhoneSearch: true);
    dynamic response = await api.searchPhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      state.activeBusiness.id,
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

    yield state.copyWith(twilioAddPhoneForm: contentData, settingsModel: model, isPhoneSearch: false);
  }

  Stream<CheckoutScreenState> purchasePhoneNumber(
      String action,
      String phone,
      String id,
      String price,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.purchasePhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      state.activeBusiness.id,
      action,
      phone,
      id,
      price,
    );
    yield state.copyWith(isLoading: false);
    add(GetCheckoutTwilioSettings());
  }

  Stream<CheckoutScreenState> removePhoneNumber(
      String action,
      String id,
      String sid,
      ) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.removePhoneNumberSettings(
      GlobalUtils.activeToken.accessToken,
      state.activeBusiness.id,
      action,
      id,
      sid,
    );
    yield state.copyWith(twilioForm: response, isLoading: false);
  }

  Stream<CheckoutScreenState> installPayment(IntegrationModel integrationModel) async* {
    dynamic response = await api.installCheckoutPayment(token, state.activeBusiness.id, state.defaultCheckout.id, integrationModel.id);
    List<IntegrationModel> connections = [];
    dynamic checkoutConnectionResponse = await api.getCheckoutConnections(
        state.activeBusiness.id, token, state.defaultCheckout.id);
    if (checkoutConnectionResponse is List) {
      checkoutConnectionResponse.forEach((element) {
        connections.add(IntegrationModel.fromJson(element));
      });
    }
    yield state.copyWith(checkoutConnections: connections);
  }

  Stream<CheckoutScreenState> uninstallPayment(IntegrationModel integrationModel) async* {
    dynamic response = await api.uninstallCheckoutPayment(token, state.activeBusiness.id, state.defaultCheckout.id, integrationModel.id);
    List<IntegrationModel> connections = [];
    dynamic checkoutConnectionResponse = await api.getCheckoutConnections(
        state.activeBusiness.id, token, state.defaultCheckout.id);
    if (checkoutConnectionResponse is List) {
      checkoutConnectionResponse.forEach((element) {
        connections.add(IntegrationModel.fromJson(element));
      });
    }
    yield state.copyWith(checkoutConnections: connections);
  }

  Stream<CheckoutScreenState> installIntegration(String integrationId) async* {
    List<String> integrations = state.integrations;
    bool install = !integrations.contains(integrationId);
    dynamic response = await api.installCheckoutConnectIntegration(token, state.activeBusiness.id, state.defaultCheckout.id, integrationId, install);
    if (response is DioError) {
      yield CheckoutScreenConnectInstallStateFailure(error: response.message);
    } else {
      if (install) {
        integrations.add(integrationId);
      } else {
        integrations.remove(integrationId);
      }
      yield state.copyWith(integrations: integrations);
    }

  }

  Stream<CheckoutScreenState> uploadBusiness(Map body) async* {
    yield state.copyWith(isUpdating: true);
    print(body);
    dynamic response = await api.patchUpdateBusiness(token, state.activeBusiness.id, body);
    if (response is DioError) {
      yield CheckoutScreenConnectInstallStateFailure(error: response.error);
    } else if (response is Map){
      dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(business: Business.map(response)));
      globalStateModel.setCurrentBusiness(Business.map(response),
          notify: true);
      yield state.copyWith(isUpdating: false);
    } else {
      yield CheckoutScreenConnectInstallStateFailure(error: 'Update Business name failed');
      yield state.copyWith(isUpdating: false);
    }
  }

  Stream<CheckoutScreenState> getPrefilledLink(bool isCoplyLink) async* {
    Map<String, dynamic> data = {
      'flow': state.channelSetFlow.toJson(),
      'force_choose_payment_only_and_submit': false,
      'force_no_header': false,
      'force_no_order': true,
      'force_payment_only': false,
      'generate_payment_code': true,
      'open_next_step_on_init': false,
    };
    if (isCoplyLink) {
      yield state.copyWith(isLoadingPrefilledLink: true);
    } else {
      yield state.copyWith(isLoadingQrcode: true);
    }

    dynamic qrcodelinkResponse = await api.getChannelSetQRcode(token, data);
    if (qrcodelinkResponse is Map) {
      String id = qrcodelinkResponse['id'];
      String prefilledLink = '${Env.wrapper}/pay/restore-flow-from-code/$id';
      yield state.copyWith(isLoadingQrcode: !isCoplyLink,
          prefilledLink: prefilledLink);
      if (isCoplyLink) {
        Clipboard.setData(ClipboardData(
            text:prefilledLink));
        Fluttertoast.showToast(msg: 'Copied Prefilled Link.');
        yield state.copyWith(isLoadingPrefilledLink: false);
      } else {
        add(CheckoutGetPrefilledQRCodeEvent());
      }
    } else {
      yield state.copyWith(isLoadingQrcode: false);
    }
  }

  Stream<CheckoutScreenState> getPrefilledQrcode() async* {
    if (state.prefilledLink == null || state.prefilledLink.isEmpty) {
      Fluttertoast.showToast(msg: 'Something wrong.');
      return;
    }

    dynamic response = await api.postGenerateTerminalQRCode(
      token,
      state.activeBusiness.id,
      state.activeBusiness.name,
      '$imageBase${state.activeTerminal.logo}',
      state.activeTerminal.id,
      state.prefilledLink,
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
    http.Response qrResponse;
    if (imageData != null) {
      var headers = {
        HttpHeaders.authorizationHeader:
        'Bearer ${GlobalUtils.activeToken.accessToken}',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
      };
      print('url => $imageData');
      qrResponse = await http.get(
        imageData,
        headers: headers,
      );
    }
    yield state.copyWith(isLoadingQrcode: false,qrForm: response, qrImage: qrResponse.bodyBytes);
    await Future.delayed(const Duration(milliseconds: 500));
    yield state.copyWith(qrForm: null, qrImage: null);
  }

}