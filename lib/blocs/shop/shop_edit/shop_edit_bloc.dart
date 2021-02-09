import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'shop_edit.dart';

class ShopEditScreenBloc
    extends Bloc<ShopEditScreenEvent, ShopEditScreenState> {
  final ShopScreenBloc shopScreenBloc;

  ShopEditScreenBloc(this.shopScreenBloc);

  ApiService api = ApiService();

  @override
  ShopEditScreenState get initialState => ShopEditScreenState();

  @override
  Stream<ShopEditScreenState> mapEventToState(
      ShopEditScreenEvent event) async* {
    if (event is ShopEditScreenInitEvent) {
      yield state.copyWith(
          activeShop: shopScreenBloc.state.activeShop,
          activeTheme: shopScreenBloc.state.activeTheme);
      yield* fetchSnapShot();
    }
  }

  Stream<ShopEditScreenState> fetchSnapShot() async* {
    if (state.activeTheme == null) {
      yield state.copyWith(isLoading: false);
      Fluttertoast.showToast(msg: 'There is no active Theme');
      return;
    }
    String token = GlobalUtils.activeToken.accessToken;
    String themeId = state.activeTheme.themeId;
    yield state.copyWith(isLoading: true);

    List<Preview> previews = [];
    List<ShopPage> pages = [];
    Map<String, dynamic> templates = {};
    List<Action>actions = [];
    Map<String, dynamic> stylesheets = {};
    dynamic response =
        await api.getShopEditPreViews(token, themeId);
    if (response is DioError) {
      Fluttertoast.showToast(msg: response.error);
    } else {
      if (response['source'] != null) {
        dynamic obj = response['source'];

        if (obj['previews'] != null) {
          Map<String, dynamic> previewObj = obj['previews'];
          previewObj.keys.forEach((element) {
            Preview preview = Preview();
            preview.id = element;
            preview.actionId = previewObj[element]['actionId'];
            preview.previewUrl = previewObj[element]['previewUrl'];
            previews.add(preview);
          });
        }
      }
    }

    dynamic response1 = await api.getShopSnapShot(token, themeId);
    if (response1 is DioError) {
      yield state.copyWith(isLoading: false);
    } else {
      // Pages
      if (response1['pages'] != null && response1['pages'] is Map) {
        Map<String, dynamic> obj = response1['pages'];
        obj.keys.forEach((element) {
            pages.add(ShopPage.fromJson(obj[element]));
        });
        print('Pages Length: ${pages.length}');
      }
      // Stylesheets Map /{deviceKey : {templateId : Background}}
      if (response1['stylesheets'] != null && response1['stylesheets'] is Map) {
        stylesheets = response1['stylesheets'];
      }
      // Templates
      if (response1['templates'] != null && response1['templates'] is Map) {
        templates = response1['templates'];
      }
    }

    Map<String, dynamic>query = {'limit': 20, 'offset': 0};
    dynamic response2 = await api.getShopEditActions(token, themeId, query);
    if (response2 is DioError) {
      yield state.copyWith(isLoading: false);
    } else {
      response2.forEach((element) {
        try {
          actions.add(Action.fromJson(element));
        } catch (e) {
          print('Action Parse Error:' + e.toString());
          print('Action Parse Element:' + element['id']);
        }
      });
      print('Action Count: ${actions.length}');
    }

    yield state.copyWith(
        previews: previews,
        pages: pages,
        stylesheets: stylesheets,
        templates: templates,
        actions: actions,
        isLoading: false);
  }

}
