import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/env.dart';

import 'notifications.dart';

class NotificationsScreenBloc extends Bloc<NotificationsScreenEvent, NotificationsScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  NotificationsScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  NotificationsScreenState get initialState => NotificationsScreenState();

  @override
  Stream<NotificationsScreenState> mapEventToState(NotificationsScreenEvent event) async* {
    if (event is NotificationsScreenInitEvent) {
      yield* init(event.uuid, event.businessId);
    }
  }

  Stream<NotificationsScreenState> init(String uuid, String businessId) async* {
  }

  Stream<NotificationsScreenState> toggleStatus(String type, String businessId) async* {
  }
}