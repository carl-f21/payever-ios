
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

import 'connect_settings_detail.dart';

class ConnectSettingsDetailScreenBloc extends Bloc<ConnectSettingsDetailScreenEvent, ConnectSettingsDetailScreenState> {
  final ConnectScreenBloc connectScreenBloc;
  ConnectSettingsDetailScreenBloc({this.connectScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ConnectSettingsDetailScreenState get initialState => ConnectSettingsDetailScreenState();

  @override
  Stream<ConnectSettingsDetailScreenState> mapEventToState(ConnectSettingsDetailScreenEvent event) async* {
    if (event is ConnectSettingsDetailScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(business: event.business);
      }
      if (event.connectModel != null) {
        yield state.copyWith(connectModel: event.connectModel);
      }
      yield* fetchInitialData(state.business);
    } else if (event is ConnectAddPaymentOptionEvent) {
      yield* addPaymentOption(event.name);
    } else if (event is ConnectDeletePaymentOptionEvent) {
      yield* deletePaymentOption(event.id);
    } else if (event is ConnectUpdatePaymentOptionEvent) {
      yield* updatePaymentOption(event.id, event.body);
    }
  }

  Stream<ConnectSettingsDetailScreenState> fetchInitialData(String business) async* {

    yield state.copyWith(isLoading: true);
    List<CheckoutPaymentOption> paymentOptions = [];
    Map<String, PaymentVariant> paymentVariants = {};

    dynamic paymentOptionsResponse = await api.getPaymentOptions(token);
    if (paymentOptionsResponse is List) {
      paymentOptionsResponse.forEach((element) {
        paymentOptions.add(CheckoutPaymentOption.fromJson(element));
      });
    }

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
        return;
      });
    }

    dynamic integrationResponse = await api.getConnectDetail(token, state.connectModel.integration.name);
    ConnectIntegration integration;
    if (integrationResponse is Map) {
      integration = ConnectIntegration.toMap(integrationResponse);
    }

    yield state.copyWith(
      isLoading: false,
      paymentVariants: paymentVariants,
      paymentOptions: paymentOptions,
      integration: integration,
    );
  }

  Stream<ConnectSettingsDetailScreenState> deletePaymentOption(String id) async* {
    yield state.copyWith(deleting: int.parse(id));
    dynamic response = await api.deletePaymentOption(token, id);
    yield state.copyWith(deleting: 0);
    add(ConnectSettingsDetailScreenInitEvent());
  }

  Stream<ConnectSettingsDetailScreenState> addPaymentOption(String name) async* {
    yield state.copyWith(isAdding: true);
    Map<String, dynamic> body = {
      'name': name,
      'payment_method': state.connectModel.integration.name,
    };
    dynamic response = await api.addPaymentOption(token, state.business, body);

    yield state.copyWith(isAdding: false);
    yield ConnectSettingsDetailScreenSuccess(business: state.business, connectModel: state.connectModel);
  }

  Stream<ConnectSettingsDetailScreenState> updatePaymentOption(String id, Map<String, dynamic> body) async* {
    yield state.copyWith(isSaving: true);
    print(body);
    dynamic response = await api.updatePaymentOption(token, id, body);

    yield state.copyWith(isSaving: false);
    add(ConnectSettingsDetailScreenInitEvent());
  }
}