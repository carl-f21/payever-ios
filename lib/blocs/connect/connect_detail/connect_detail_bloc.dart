
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

import 'connect_detail.dart';

class ConnectDetailScreenBloc extends Bloc<ConnectDetailScreenEvent, ConnectDetailScreenState> {
  final ConnectScreenBloc connectScreenBloc;
  ConnectDetailScreenBloc({this.connectScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ConnectDetailScreenState get initialState => ConnectDetailScreenState();

  @override
  Stream<ConnectDetailScreenState> mapEventToState(ConnectDetailScreenEvent event) async* {
    if (event is ConnectDetailScreenInitEvent) {
      yield state.copyWith(business: event.business,
          editConnect: event.connectModel.integration,
          installed: event.connectModel.installed);
      yield* getConnectDetail(event.connectModel.integration.name);
    } else if (event is ConnectDetailEvent) {
      yield* getConnectDetail(event.name);
    } else if (event is AddReviewEvent) {
      yield* addReview(event.title, event.text, event.rate);
    } else if (event is InstallEvent) {
      yield* installConnect(state.editConnect);
    } else if (event is UninstallEvent) {
      yield* unInstallConnect(state.editConnect);
    } else if (event is InstallMoreConnectEvent) {
      yield* installMoreConnect(event.model);
    } else if (event is UninstallMoreConnectEvent) {
      yield* unInstallMoreConnect(event.model);
    } else if (event is ClearEvent) {
      yield state.copyWith(installedNewConnect: '', uninstalledNewConnect: '', isReview: false);
    }
  }

  Stream<ConnectDetailScreenState> getCategoryDetails(ConnectIntegration integration) async* {
    yield state.copyWith(categoryConnects: []);
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(token, state.business, integration.category);
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        ConnectModel cm = ConnectModel.toMap(element);
        if (cm.integration.id != integration.id) {
          connectInstallations.add(cm);
        }
      });
    }

    yield state.copyWith(categoryConnects: connectInstallations);
  }

  Stream<ConnectDetailScreenState> addReview(String title, String text, num rate) async* {
    if (title == null || title == '') {
      dynamic response = await api.patchConnectRating(token, state.editConnect.name, rate);
    } else {
      dynamic response = await api.patchConnectWriteReview(token, state.editConnect.name, title, text, rate);
    }
    yield state.copyWith(isReview: true);
    add(ConnectDetailEvent(name: state.editConnect.name));
  }

  Stream<ConnectDetailScreenState> getConnectDetail(String name) async* {
    yield state.copyWith(isLoading: true, isReview: false);
    dynamic response = await api.getConnectDetail(token, name);
    ConnectIntegration model = ConnectIntegration.toMap(response);
    yield state.copyWith(isLoading: false, editConnect: model);
    yield* getCategoryDetails(state.editConnect);
  }

  Stream<ConnectDetailScreenState> installConnect(ConnectIntegration model) async* {
    connectScreenBloc.state.copyWith(installingConnect: model.name);
    yield state.copyWith(installing: true);
    if (model.category == 'payments') {
      num id = 0;
      if (connectScreenBloc.state.paymentVariants.containsKey(model.name)) {
        PaymentVariant variant = connectScreenBloc.state.paymentVariants[model.name];
        id = variant.variants.first.id;
      }
      dynamic resetResponse = await api.resetPaymentCredential(token, state.business, model.name, '$id');
    }

    dynamic response = await api.installConnect(token, state.business, model.name);
    if (response is Map) {
      if (response['installed'] ?? false) {
        List<ConnectModel> models = [];
        models.addAll(connectScreenBloc.state.connectInstallations);
        int index = models.indexWhere((element) => element.integration.name == model.name);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        connectScreenBloc.state.copyWith(connectInstallations: models);
      }
    }
    connectScreenBloc.state.copyWith(installingConnect: '');
    yield state.copyWith(installing: false, installed: true);
  }

  Stream<ConnectDetailScreenState> unInstallConnect(ConnectIntegration model) async* {
    connectScreenBloc.state.copyWith(installingConnect: model.name);
    yield state.copyWith(installing: true);
    if (model.category == 'payments') {
      num id = 0;
      if (connectScreenBloc.state.paymentVariants.containsKey(model.name)) {
        PaymentVariant variant = connectScreenBloc.state.paymentVariants[model.name];
        id = variant.missingSteps.id;
      }
      dynamic resetResponse = await api.resetPaymentCredential(token, state.business, model.name, '$id');
    }

    dynamic response = await api.unInstallConnect(token, state.business, model.name);
    if (response is Map) {
      if (response['installed'] != null) {
        List<ConnectModel> models = [];
        models.addAll(connectScreenBloc.state.connectInstallations);
        int index = models.indexWhere((element) => element.integration.name == model.name);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        connectScreenBloc.state.copyWith(connectInstallations: models);
      }
    }
    connectScreenBloc.state.copyWith(installingConnect: '');
    yield state.copyWith(installing: false, installed: false);
  }

  Stream<ConnectDetailScreenState> installMoreConnect(ConnectModel model) async* {
    connectScreenBloc.state.copyWith(installingConnect: model.integration.name);
    yield state.copyWith(installingConnect: model.integration.name);
    if (model.integration.category == 'payments') {
      num id = 0;
      if (connectScreenBloc.state.paymentVariants.containsKey(model.integration.name)) {
        PaymentVariant variant = connectScreenBloc.state.paymentVariants[model.integration.name];
        id = variant.variants.first.id;
      }
      dynamic resetResponse = await api.resetPaymentCredential(token, state.business, model.integration.name, '$id');
    }

    dynamic response = await api.installConnect(token, state.business, model.integration.name);
    if (response is Map) {
      if (response['installed'] != null) {
        List<ConnectModel> models = [];
        models.addAll(connectScreenBloc.state.connectInstallations);
        int index = models.indexWhere((element) => element.integration.name == model.integration.name);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        connectScreenBloc.state.copyWith(connectInstallations: models);

        List<ConnectModel> moreConnects = [];
        moreConnects.addAll(state.categoryConnects);
        int indexMore = moreConnects.indexWhere((element) => element.integration.name == model.integration.name);
        ConnectModel mm = moreConnects[indexMore];
        mm.installed = response['installed'] ?? false;
        moreConnects[indexMore] = mm;
        state.copyWith(categoryConnects: models);
      }
    }
    connectScreenBloc.state.copyWith(installingConnect: '');
    yield state.copyWith(installing: false, installingConnect: '', installedNewConnect: model.integration.name);
  }

  Stream<ConnectDetailScreenState> unInstallMoreConnect(ConnectModel model) async* {
    connectScreenBloc.state.copyWith(installingConnect: model.integration.name);
    yield state.copyWith(installingConnect: model.integration.name);
    if (model.integration.category == 'payments') {
      num id = 0;
      if (connectScreenBloc.state.paymentVariants.containsKey(model.integration.name)) {
        PaymentVariant variant = connectScreenBloc.state.paymentVariants[model.integration.name];
        id = variant.missingSteps.id;
      }
      dynamic resetResponse = await api.resetPaymentCredential(token, state.business, model.integration.name, '$id');
    }

    dynamic response = await api.unInstallConnect(token, state.business, model.integration.name);
    if (response is Map) {
      if (response['installed'] != null) {
        List<ConnectModel> models = [];
        models.addAll(connectScreenBloc.state.connectInstallations);
        int index = models.indexWhere((element) => element.integration.name == model.integration.name);
        ConnectModel m = models[index];
        m.installed = response['installed'] ?? false;
        models[index] = m;
        connectScreenBloc.state.copyWith(connectInstallations: models);

        List<ConnectModel> moreConnects = [];
        moreConnects.addAll(state.categoryConnects);
        int indexMore = moreConnects.indexWhere((element) => element.integration.name == model.integration.name);
        ConnectModel mm = moreConnects[indexMore];
        mm.installed = response['installed'] ?? false;
        moreConnects[indexMore] = mm;
        state.copyWith(categoryConnects: models);
      }
    }
    connectScreenBloc.state.copyWith(installingConnect: '');
    yield state.copyWith(installing: false, installingConnect: '', uninstalledNewConnect: model.integration.name);
  }

}