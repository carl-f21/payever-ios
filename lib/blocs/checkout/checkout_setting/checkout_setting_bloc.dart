import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import '../checkout_bloc.dart';
import 'checkout_setting.dart';

class CheckoutSettingScreenBloc extends Bloc<CheckoutSettingScreenEvent, CheckoutSettingScreenState> {

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutSettingScreenBloc({this.checkoutScreenBloc});

  @override
  CheckoutSettingScreenState get initialState => CheckoutSettingScreenState();

  @override
  Stream<CheckoutSettingScreenState> mapEventToState(
      CheckoutSettingScreenEvent event) async* {
    if (event is CheckoutSettingScreenInitEvent) {
      if (event.businessId != null) {
        yield state.copyWith(
          business: event.businessId,
          checkout: event.checkout,
        );
      }
    } else if (event is UpdateCheckoutSettingsEvent) {
      yield* updateCheckoutSettings();
    } else if (event is GetPhoneNumbers) {
      yield* getPhoneNumbers();
    } else if (event is UpdatePolicyEvent) {
      yield* updateChannelSetPolicyEnable(event.channelId, event.policyEnabled);
    }
  }

  Stream<CheckoutSettingScreenState> updateCheckoutSettings() async* {
    yield state.copyWith(isUpdating: true);
    Map<String, dynamic>body = state.checkout.settings.toDictionary();
    dynamic response = await api.patchCheckout(GlobalUtils.activeToken.accessToken, state.business, state.checkout.id, body);
    if (response is DioError) {
      yield CheckoutSettingScreenStateFailure(error: response.message);
    } else {
      yield CheckoutSettingScreenStateSuccess();
    }
    yield state.copyWith(isUpdating: false);
  }

  Stream<CheckoutSettingScreenState> getPhoneNumbers() async* {
    yield state.copyWith(isLoading: true,);
    List<IntegrationModel> connections = [];
    List<String> phoneNumbers = [];
    if (state.phoneNumbers.isEmpty) {
      // Get Connections
      if (checkoutScreenBloc.state.connections.isEmpty) {
        dynamic connectionResponse = await api.getConnections(state.business, token);
        if (connectionResponse is List) {
          connectionResponse.forEach((element) {
            connections.add(IntegrationModel.fromJson(element));
          });
        }
//        yield state.copyWith(connections: connections);
      } else {
        connections = checkoutScreenBloc.state.connections;
      }

      IntegrationModel twilioIntegration;
      List<IntegrationModel> list = connections.where((element) => element.integration == 'twilio').toList();
      if (list.length > 0) {
        twilioIntegration = list.first;
      }
      if (twilioIntegration != null) {
        dynamic phoneResponse = await api.getPhoneNumbers(state.business, token, twilioIntegration.id);
        if (phoneResponse is List) {
          phoneResponse.forEach((element) {
            phoneNumbers.add(element);
          });
        }
      }
    } else {
      phoneNumbers = state.phoneNumbers;
    }
    yield state.copyWith(isLoading:false, phoneNumbers: phoneNumbers);
  }

  Stream<CheckoutSettingScreenState> updateChannelSetPolicyEnable(String channelId, bool enabled) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.patchCheckoutChannelSetPolicy(GlobalUtils.activeToken.accessToken, state.business, channelId, enabled);
    if (response is DioError) {
      yield CheckoutSettingScreenStateFailure(error: response.message);
    } else {
      yield CheckoutSettingScreenStateSuccess();
    }
    yield state.copyWith(isUpdating: false);
  }
}