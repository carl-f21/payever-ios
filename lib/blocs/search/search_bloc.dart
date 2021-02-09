import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/search/search_event.dart';
import 'package:payever/blocs/search/search_state.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  SearchScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  SearchScreenState get initialState => SearchScreenState();

  @override
  Stream<SearchScreenState> mapEventToState(
      SearchScreenEvent event) async* {
    if (event is SearchEvent) {
      yield* search(event.key, event.businessId);
    } else if (event is SetBusinessEvent) {
      yield* setBusiness(event.business);
    }
  }

  Stream<SearchScreenState> search(String key, String businessId) async* {

    yield state.copyWith(isLoading: true);
    if (key == '') {
      yield state.copyWith(isLoading: false, searchTransactions: [], searchBusinesses: []);
      return;
    }
    List<Business> businesses = [];
    if (state.businesses.length > 0) {
    }
    businesses.addAll(state.businesses);
    if (businesses.length == 0) {
      dynamic businessResponse = await api.getBusinesses(GlobalUtils.activeToken.accessToken);
      businessResponse.forEach((element) {
        businesses.add(Business.map(element));
      });
      yield state.copyWith(businesses: businesses);
    }
    List<Business> searchBusinessResult = [];
    searchBusinessResult = businesses.where((element) {
      if (element.name.toLowerCase().contains(key.toLowerCase())) {
        return true;
      }
      if (element.email.toLowerCase().contains(key.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();

    List<Collection> searchTransactionsResult = [];
    String sortQuery = '?orderBy=created_at&direction=desc&query=$key&limit=8';

    dynamic obj = await api.getTransactionList(businessId, GlobalUtils.activeToken.accessToken, sortQuery);
    Transaction transaction = Transaction.fromJson(obj);

    if (GlobalUtils.isBusinessMode) {
      searchTransactionsResult.addAll(transaction.collection);
    } else {
      List<Collection> collections = transaction.collection
          .where((element) =>
              element.businessUuid == null || element.businessUuid.isEmpty)
          .toList();
      if (collections != null && collections.isNotEmpty) {
        searchTransactionsResult.addAll(collections);
      }
    }
    print('Business Mode => ${GlobalUtils.isBusinessMode}');
    print('searchBusinessResult=> $searchBusinessResult');
    print('searchTransactionsResult=> $searchTransactionsResult');
    if (searchBusinessResult.length > 4) {
      yield state.copyWith(
        isLoading: false,
        searchBusinesses: searchBusinessResult.sublist(0, 4),
        searchTransactions: searchTransactionsResult.isEmpty
            ? []
            : searchTransactionsResult.length > 4
                ? searchTransactionsResult.sublist(0, 4)
                : searchTransactionsResult.sublist(
                    0, searchTransactionsResult.length - 1),
      );
    } else {
      if (searchTransactionsResult.length > 8 - searchBusinessResult.length) {
        yield state.copyWith(
          isLoading: false,
          searchBusinesses: searchBusinessResult,
          searchTransactions: searchTransactionsResult.sublist(0, 8 - searchBusinessResult.length),
        );
      } else {
        yield state.copyWith(
          isLoading: false,
          searchBusinesses: searchBusinessResult,
          searchTransactions: searchTransactionsResult,
        );
      }
    }

  }

  Stream<SearchScreenState> setBusiness(Business business) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getWallpaper(business.id, GlobalUtils.activeToken.accessToken);
    FetchWallpaper fetchWallpaper = FetchWallpaper.map(response);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
          GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
    preferences.setString(GlobalUtils.BUSINESS, business.id);
    yield state.copyWith(isLoading: false);
    yield SetBusinessSuccess(wallpaper: fetchWallpaper, business: business);
  }

}