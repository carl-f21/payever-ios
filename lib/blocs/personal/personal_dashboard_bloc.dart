import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'personal_dashboard.dart';

class PersonalDashboardScreenBloc extends Bloc<PersonalDashboardScreenEvent, PersonalDashboardScreenState> {
  
  PersonalDashboardScreenBloc();
  
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  PersonalDashboardScreenState get initialState => PersonalDashboardScreenState();

  @override
  Stream<PersonalDashboardScreenState> mapEventToState(
      PersonalDashboardScreenEvent event) async* {
    if (event is PersonalScreenInitEvent) {
      yield state.copyWith(
        business: event.business,
        personalWallpaper: event.personalWallpaper,
        curWall: event.curWall,
        user: event.user
      );
      if (event.isRefresh) {
        yield* getPersonalWidgets();
      }
    } else if (event is UpdatePersonalWallpaperEvent) {
      yield state.copyWith(personalWallpaper: event.personalWallpaper, curWall: event.curWall);
    }
  }

  Stream<PersonalDashboardScreenState> getPersonalWidgets() async* {
    yield state.copyWith(isLoading: true);
    List<BusinessApps> personalApps = [];

    dynamic businessAppsObj = await api.getPersonalApps(token);
    personalApps.clear();
    businessAppsObj.forEach((item) {
      personalApps.add(BusinessApps.fromMap(item));
    });

    dynamic response = await api.getWidgetsPersonal(token);
    List<AppWidget> widgetApps = [];
    if (response is List) {
      widgetApps.clear();
      response.forEach((item) {
        widgetApps.add(AppWidget.map(item));
      });
    }
    yield state.copyWith(isLoading: false, personalApps: personalApps, personalWidgets: widgetApps);
  }

}