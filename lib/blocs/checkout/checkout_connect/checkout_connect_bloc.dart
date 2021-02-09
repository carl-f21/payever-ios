import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutConnectScreenBloc extends Bloc<CheckoutConnectScreenEvent, CheckoutConnectScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutConnectScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutConnectScreenState get initialState => CheckoutConnectScreenState();

  @override
  Stream<CheckoutConnectScreenState> mapEventToState(
      CheckoutConnectScreenEvent event) async* {
    if (event is CheckoutConnectScreenInitEvent) {
      yield state.copyWith(business: event.business, category: event.category);
      yield* fetchInitialData(event.business);
    } else if (event is InstallCheckoutConnect) {
      yield* installCheckoutConnect(event.connectModel);
    }
  }

  Stream<CheckoutConnectScreenState> fetchInitialData(String business) async* {

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
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(
        token, state.business, state.category);
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    yield state.copyWith(
      isLoading: false,
      paymentVariants: paymentVariants,
      paymentOptions: paymentOptions,
      connectInstallations: connectInstallations,
    );
  }

  Stream<CheckoutConnectScreenState> installCheckoutConnect(ConnectModel model) async* {
    yield state.copyWith(installing: model.integration.name);
    dynamic response = await api.installConnect(token, state.business, model.integration.name);
    if (response is Map) {
      if (response['installed'] ?? false) {
        List<ConnectModel> models = [];
        models.addAll(state.connectInstallations);
        int index = models.indexOf(model);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        yield state.copyWith(connectInstallations: models, installing: '');
      } else {
        yield state.copyWith(installing: '');
      }
    } else {
      yield state.copyWith(installing: '');
    }
  }
}