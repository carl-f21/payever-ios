import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/switcher/switcher_event.dart';
import 'package:payever/blocs/switcher/switcher_state.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitcherScreenBloc extends Bloc<SwitcherScreenEvent, SwitcherScreenState> {
  SwitcherScreenBloc();

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  SwitcherScreenState get initialState => SwitcherScreenState();

  @override
  Stream<SwitcherScreenState> mapEventToState(
      SwitcherScreenEvent event) async* {
    if (event is SwitcherScreenInitialEvent) {
      yield* fetchBusiness();
    } else if (event is SwitcherSetBusinessEvent) {
      yield* fetchWallPaper(event.business);
    }
  }

  Stream<SwitcherScreenState> fetchBusiness() async* {
    yield state.copyWith(isLoading: true);

    List<Business> businesses = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = GlobalUtils.activeToken.accessToken;

    dynamic userobj = await api.getUser(token);
    User user = User.map(userobj);
    preferences.setString(GlobalUtils.LANGUAGE, user.language);
//    Language.language = parts._logUser.language;
//    Language(context);
//    Measurements.loadImages(context);

    dynamic businessesObj = await api.getBusinesses(token);
    businessesObj.forEach((item) {
      businesses.add(Business.map(item));
    });

    Business activeBusiness;
    List<Business> bList = businesses.where((element) => element.active).toList();
    if (bList.length > 0) {
      activeBusiness = bList.first;
    }
    if (activeBusiness == null) {
      add(SwitcherSetBusinessEvent(business: businesses.first));
    } else {
      yield state.copyWith(
        logUser: user,
        active: activeBusiness,
        businesses: businesses,
        isLoading: false,
      );
    }
  }

  Stream<SwitcherScreenState> fetchWallPaper(Business business) async* {
    dynamic enableResponse = await api.setEnableBusiness(business.id, GlobalUtils.activeToken.accessToken);
    dynamic wallpapersObj = await api.getWallpaper(business.id, GlobalUtils.activeToken.accessToken);
    FetchWallpaper fetchWallpaper = FetchWallpaper.map(wallpapersObj);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
        GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
    preferences.setString(GlobalUtils.BUSINESS, business.id);

    yield state.copyWith(wallpaper: fetchWallpaper, isLoading: false);
    yield SwitcherScreenStateSuccess(business: business, wallpaper: fetchWallpaper);
  }
}