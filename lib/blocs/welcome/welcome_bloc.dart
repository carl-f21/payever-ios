import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/welcome/welcome_event.dart';
import 'package:payever/blocs/welcome/welcome_state.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';

class WelcomeScreenBloc extends Bloc<WelcomeScreenEvent, WelcomeScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  WelcomeScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  WelcomeScreenState get initialState => WelcomeScreenState();

  @override
  Stream<WelcomeScreenState> mapEventToState(WelcomeScreenEvent event) async* {
    if (event is ToggleEvent) {
      yield* toggleStatus(event.type, event.businessId);
    } else if (event is WelcomeScreenInitEvent) {
      yield* init(event.uuid, event.businessId);
    }
  }

  Stream<WelcomeScreenState> init(String uuid, String businessId) async* {
    dynamic response = await api.toggleInstalled(GlobalUtils.activeToken.accessToken, businessId, uuid);
  }

  Stream<WelcomeScreenState> toggleStatus(String type, String businessId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.toggleSetUpStatus(GlobalUtils.activeToken.accessToken, businessId, type);
    yield state.copyWith(isLoading: false);
    yield WelcomeScreenStateSuccess();
  }
}