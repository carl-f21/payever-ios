import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_payment_setting/checkout_payment_setting.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/settings/models/models.dart';

class CheckoutPaymentSettingScreenBloc extends Bloc<CheckoutPaymentSettingScreenEvent, CheckoutPaymentSettingScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutPaymentSettingScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutPaymentSettingScreenState get initialState => CheckoutPaymentSettingScreenState();

  @override
  Stream<CheckoutPaymentSettingScreenState> mapEventToState(
      CheckoutPaymentSettingScreenEvent event) async* {
    if (event is CheckoutPaymentSettingScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(business: event.business, connectModel: event.connectModel);
      }
      yield* fetchInitialData(state.business);
    } else if (event is AddPaymentOptionEvent) {
      yield* addPaymentOption(event.name);
    } else if (event is DeletePaymentOptionEvent) {
      yield* deletePaymentOption(event.id);
    } else if (event is UpdatePaymentOptionEvent) {
      yield* updatePaymentOption(event.id, event.body);
    }
  }

  Stream<CheckoutPaymentSettingScreenState> fetchInitialData(String business) async* {

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
    List<BusinessProduct> businessProducts = [];
    dynamic response = await api.getBusinessProducts(token);

    if (response is List) {
      response.forEach((element) {
        businessProducts.add(BusinessProduct.fromMap(element));
      });
    }
    yield state.copyWith(
      isLoading: false,
      paymentVariants: paymentVariants,
      paymentOptions: paymentOptions,
      integration: integration,
      businessProducts: businessProducts,
    );
  }

  Stream<CheckoutPaymentSettingScreenState> deletePaymentOption(String id) async* {
    yield state.copyWith(deleting: int.parse(id));
    dynamic response = await api.deletePaymentOption(token, id);
    yield state.copyWith(deleting: 0);
    add(CheckoutPaymentSettingScreenInitEvent());
  }

  Stream<CheckoutPaymentSettingScreenState> addPaymentOption(String name) async* {
    yield state.copyWith(isAdding: true);
    Map<String, dynamic> body = {
      'name': name,
      'payment_method': state.connectModel.integration.name,
    };
    dynamic response = await api.addPaymentOption(token, state.business, body);

    yield state.copyWith(isAdding: false);
    yield CheckoutPaymentSettingScreenSuccess(business: state.business, connectModel: state.connectModel);
  }

  Stream<CheckoutPaymentSettingScreenState> updatePaymentOption(String id, Map<String, dynamic> body) async* {
    yield state.copyWith(isSaving: true);
    print(body);
    dynamic response = await api.updatePaymentOption(token, id, body);

    yield state.copyWith(isSaving: false);
    add(CheckoutPaymentSettingScreenInitEvent());
  }

}