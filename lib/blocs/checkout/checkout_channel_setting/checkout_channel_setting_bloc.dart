
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class CheckoutChannelSettingScreenBloc extends Bloc<CheckoutChannelSettingScreenEvent, CheckoutChannelSettingScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutChannelSettingScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutChannelSettingScreenState get initialState => CheckoutChannelSettingScreenState();

  @override
  Stream<CheckoutChannelSettingScreenState> mapEventToState(
      CheckoutChannelSettingScreenEvent event) async* {
    if (event is CheckoutChannelSettingScreenInitEvent) {
      yield state.copyWith(business: event.business, connectModel: event.connectModel);
      yield* getPlugins();
    } else if (event is GetPluginsEvent) {
      yield* getPlugins();
    } else if (event is CreateCheckoutAPIkeyEvent) {
      yield* createShopSystemAPIkey(event.name, event.redirectUri);
    } else if (event is DeleteCheckoutAPIkeyEvent) {
      yield* deleteShopSystemAPIkey(event.client);
    }
  }

  Stream<CheckoutChannelSettingScreenState> getPlugins() async* {
    if (state.shopSystem == null) {
      ShopSystem shopSystem; List<APIkey>apiKeys = [];
      yield state.copyWith(isLoading: true);
      dynamic response = await api.getPluginShopSystem(token, state.connectModel.integration.name);
      if (response is Map) {
        shopSystem = ShopSystem.fromJson(response);
      }
      List<String>clients = [];
      dynamic clientsResponse = await api.getShopSystemClients(token, state.business, state.connectModel.integration.name);
      if(clientsResponse is List){
        clientsResponse.forEach((element) {
          clients.add(element);
        });
      }
      dynamic apiKeysResponse = await api.getShopSystemAPIKeys(token, state.business, clients);
      if (apiKeysResponse is List) {
        apiKeysResponse.forEach((element) {
          APIkey apiKey = APIkey.fromJson(element);
          apiKeys.add(apiKey);
        });
      }
      yield state.copyWith(isLoading: false, shopSystem: shopSystem, apiKeys: apiKeys);
    }
  }


  Stream<CheckoutChannelSettingScreenState> createShopSystemAPIkey(String name, String redirectUri) async* {
    List<APIkey> apis = state.apiKeys;
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.createShopSystemAPIkey(
        token, state.business, name, redirectUri);
    if (response is DioError) {
      yield CheckoutChannelSettingScreenFailure(error: response.message);
    } else {
      APIkey apiKey = APIkey.fromJson(response);
      await api.postShopSystemApikey(token, state.business, apiKey.id, state.connectModel.integration.name);
      apis.add(apiKey);
      yield state.copyWith(isUpdating: false, apiKeys: apis);
    }
  }

  Stream<CheckoutChannelSettingScreenState> deleteShopSystemAPIkey(String client) async* {

    yield state.copyWith(isUpdating: true);
    dynamic response = await api.deleteShopSystemAPIkey(
        token, state.business, client);
    if (response is DioError) {
      yield CheckoutChannelSettingScreenFailure(error: response.message);
    } else {
      List<APIkey> apis = state.apiKeys;
      APIkey apIkey = apis.where((element) => element.id == client).toList().first;
      if(apIkey != null)
        apis.remove(apIkey);
      yield state.copyWith(isUpdating: false, apiKeys: apis);
    }
  }

}