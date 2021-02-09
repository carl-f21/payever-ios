
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

import 'connect.dart';

class ConnectScreenBloc extends Bloc<ConnectScreenEvent, ConnectScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  ConnectScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ConnectScreenState get initialState => ConnectScreenState();

  @override
  Stream<ConnectScreenState> mapEventToState(ConnectScreenEvent event) async* {
    if (event is ConnectScreenInitEvent) {
      yield state.copyWith(business: event.business);
      yield* fetchConnectInstallations(event.business);
    } else if (event is ConnectCategorySelected) {
      yield* selectCategory(event.category);
    } else if (event is InstallConnectAppEvent) {
      yield* installConnect(event.model);
    } else if (event is UninstallConnectAppEvent) {
      yield* unInstallConnect(event.model);
    } else if (event is ClearInstallEvent) {
      yield state.copyWith(installedConnect: '', uninstalledConnect: '');
    }
  }

  Stream<ConnectScreenState> fetchConnectInstallations(String business) async* {
    yield state.copyWith(isLoading: true);

    List<ConnectModel> connectInstallations = [];
    List<String> categories = [];
    List<CheckoutPaymentOption> paymentOptions = [];
    Map<String, PaymentVariant> paymentVariants = {};

    dynamic connectsResponse = await api.getConnectionIntegrations(
        token, business);
    if (connectsResponse is List) {
      connectsResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
      connectInstallations.forEach((element) {
        String category = element.integration.category;
        if (category != null) {
          if (!categories.contains(category)) {
            categories.add(category);
          }
        }
      });
      categories.insert(0, 'all');
    }

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
    yield state.copyWith(
      isLoading: false,
      paymentVariants: paymentVariants,
      paymentOptions: paymentOptions,
      categories: categories,
      selectedCategory: categories.length > 0 ? categories.first : '',
      connectInstallations: connectInstallations,
    );
  }

  Stream<ConnectScreenState> selectCategory(String category) async* {
    yield state.copyWith(selectedCategory: category, isLoading: true);
    List<ConnectModel> connectInstallations = [];
    if (category == 'all') {
      dynamic connectsResponse = await api.getConnectionIntegrations(token, state.business);
      if (connectsResponse is List) {
        connectsResponse.forEach((element) {
          connectInstallations.add(ConnectModel.toMap(element));
        });
      }
    } else {
      dynamic categoryResponse = await api.getConnectIntegrationByCategory(
          token, state.business, category);
      if (categoryResponse is List) {
        categoryResponse.forEach((element) {
          connectInstallations.add(ConnectModel.toMap(element));
        });
      }
    }

    yield state.copyWith(
        isLoading: false, connectInstallations: connectInstallations);
  }

  Stream<ConnectScreenState> installConnect(ConnectModel model) async* {
    yield state.copyWith(installingConnect: model.integration.name);
    if (model.integration.category == 'payments') {
      num id = 0;
      if (state.paymentVariants.containsKey(model.integration.name)) {
        PaymentVariant variant = state.paymentVariants[model.integration.name];
        id = variant.variants.first.id;
      }
      dynamic resetResponse = await api.resetPaymentCredential(token, state.business, model.integration.name, '$id');
    }

    dynamic response = await api.installConnect(token, state.business, model.integration.name);
    if (response is Map) {
      if (response['installed'] ?? false) {
        List<ConnectModel> models = [];
        models.addAll(state.connectInstallations);
        int index = models.indexOf(model);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        yield state.copyWith(connectInstallations: models);
      }
    }

    yield state.copyWith(installingConnect: '', installedConnect: model.integration.name);
  }

  Stream<ConnectScreenState> unInstallConnect(ConnectModel model) async* {
    yield state.copyWith(installingConnect: model.integration.name);
    if (model.integration.category == 'payments') {
      num id = 0;
      if (state.paymentVariants.containsKey(model.integration.name)) {
        PaymentVariant variant = state.paymentVariants[model.integration.name];
        id = variant.missingSteps.id;
      }
      dynamic resetResponse = await api.resetPaymentCredential(token, state.business, model.integration.name, '$id');
    }

    dynamic response = await api.unInstallConnect(token, state.business, model.integration.name);
    if (response is Map) {
      if (response['installed'] != null) {
        List<ConnectModel> models = [];
        models.addAll(state.connectInstallations);
        int index = models.indexOf(model);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        yield state.copyWith(connectInstallations: models);
      }
    }

    yield state.copyWith(installingConnect: '', uninstalledConnect: model.integration.name);
  }
}