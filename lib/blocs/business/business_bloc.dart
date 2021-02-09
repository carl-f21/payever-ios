import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../bloc.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {

  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;
  BusinessBloc({this.dashboardScreenBloc, this.globalStateModel});

  ApiService api = ApiService();
  SharedPreferences preferences;
  String token = GlobalUtils.activeToken.accessToken;
  @override
  BusinessState get initialState => BusinessState();

  @override
  Stream<BusinessState> mapEventToState(BusinessEvent event) async* {
    preferences = await SharedPreferences.getInstance();
    if (event is BusinessFormEvent) {
      yield* loadBusinessForm(event.isRegister);
    } else if (event is GetIndustrySuggestionEvent) {
      yield* searchFilter(event.search);
    } else if (event is ClearSuggestionEvent) {
      yield state.copyWith(suggestions: []);
    } else if (event is RegisterBusinessEvent) {
      yield* registerBusiness(event.body);
    }
  }

  Stream<BusinessState> loadBusinessForm(bool isRegister) async* {
    yield state.copyWith(isLoading: true);
    BusinessFormData formData;
    dynamic formDataResponse = await api.getBusinessRegistrationFormData(token);
    if (formDataResponse is Map) {
      formData = BusinessFormData.fromMap(formDataResponse);
    }
    List<IndustryModel> industryList = [];
    if (formData != null) {
      formData.products.forEach((element) {
        industryList.addAll(element.industries);
      });
    }
    if (isRegister) {
      String userId = preferences.getString(GlobalUtils.USER_ID);
      if (userId != null && userId.isNotEmpty) {
        dynamic response = await api.putUser(token, userId);
        token = response['accessToken'];
        preferences.setString(GlobalUtils.TOKEN, token);
        GlobalUtils.activeToken.accessToken = token;
      }
    }
    yield state.copyWith(isLoading: false, formData: formData, industryList: industryList);
  }

  Stream<BusinessState> searchFilter(String query) async* {
    List<IndustryModel> matches = [];
    matches.addAll(getSuggestions(query));
    yield state.copyWith(suggestions: matches);
  }

  List<IndustryModel> getSuggestions(String query) {
    List<IndustryModel> matches = List();
    matches.addAll(state.industryList);

    matches.retainWhere((s) => Language.getCommerceOSStrings('assets.industry.${s.code}').toLowerCase().contains(query.toLowerCase()));
    matches.sort((a, b) {
      return Language.getCommerceOSStrings('assets.industry.${a.code}').compareTo(Language.getCommerceOSStrings('assets.industry.${b.code}'));
    });
    return matches;
  }
  
  Stream<BusinessState> registerBusiness(Map<String, dynamic> body,) async* {
    yield state.copyWith(isUpdating: true);
    String id = Uuid().v4();

    dynamic authResponse = await api.putAuth(token, id);
    if (authResponse is Map) {
      String accessToken = authResponse['accessToken'];
      GlobalUtils.activeToken.accessToken = accessToken;
      preferences.setString(GlobalUtils.TOKEN, accessToken);

      body['id'] = id;
      dynamic peAuthResponse = await api.peAuthToken(accessToken);
      dynamic businessResponse = await api.postBusiness(accessToken, body);
      if (businessResponse is Map) {
        Business business = Business.map(businessResponse);

        dynamic wallpapersObj = await api.getWallpaper(business.id, accessToken);
        FetchWallpaper fetchWallpaper = FetchWallpaper.map(wallpapersObj);
        preferences.setString(
            GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
        preferences.setString(GlobalUtils.BUSINESS, business.id);

        dynamic businessAppsObj = await api.getBusinessApps(
          business.id,
          accessToken,
        );
        List<BusinessApps> businessWidgets = [];
        businessAppsObj.forEach((item) {
          businessWidgets.add(BusinessApps.fromMap(item));
        });

        yield state.copyWith(isUpdating: false);
        yield BusinessSuccess(business: business, businessApps: businessWidgets, wallpaper: fetchWallpaper);
      } else {
        yield state.copyWith(isUpdating: false);
        yield BusinessFailure(error: 'Business Registration Failed');
      }
    } else {
      yield state.copyWith(isUpdating: false);
      yield BusinessFailure(error: 'Business Registration Failed');
    }
  }

}