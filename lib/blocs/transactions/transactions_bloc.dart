import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';

import '../bloc.dart';

class TransactionsScreenBloc
    extends Bloc<TransactionsScreenEvent, TransactionsScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  TransactionsScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();

  @override
  TransactionsScreenState get initialState => TransactionsScreenState();

  @override
  Stream<TransactionsScreenState> mapEventToState(
      TransactionsScreenEvent event) async* {
    if (event is TransactionsScreenInitEvent) {
      yield state.copyWith(
          currentBusiness: event.currentBusiness, page: 1, isLoading: true);
      yield* fetchTransactions('', 'date', [], 1);
    } else if (event is FetchTransactionsEvent) {
      yield* fetchTransactions(
          event.searchText, event.sortBy, event.filterBy, event.page);
    } else if (event is UpdateSearchText) {
      yield state.copyWith(
          searchText: event.searchText, page: 1, isSearchLoading: true);
      yield* fetchTransactions(
          state.searchText, state.curSortType, state.filterTypes, state.page);
    } else if (event is UpdateFilterTypes) {
      yield state.copyWith(
          filterTypes: event.filterTypes, page: 1, isSearchLoading: true);
      yield* fetchTransactions(
          state.searchText, state.curSortType, state.filterTypes, state.page);
    } else if (event is UpdateSortType) {
      yield state.copyWith(
          curSortType: event.sortType, page: 1, isSearchLoading: true);
      yield* fetchTransactions(
          state.searchText, state.curSortType, state.filterTypes, state.page);
    } else if (event is LoadMoreTransactionsEvent) {
      yield* loadMoreTransactions();
    } else if (event is RefreshTransactionsEvent) {
      yield* fetchTransactions('', 'date', [], 1);
    }
  }

  Stream<TransactionsScreenState> fetchTransactions(String search,
      String sortType, List<FilterItem> filterTypes, int page) async* {
    String queryString = '';
    String sortQuery = 'orderBy=created_at&direction=desc&';
    if (sortType == 'date') {
      sortQuery = 'orderBy=created_at&direction=desc&';
    } else if (sortType == 'total_high') {
      sortQuery = 'orderBy=total&direction=desc&';
    } else if (sortType == 'total_low') {
      sortQuery = 'orderBy=total&direction=asc&';
    } else if (sortType == 'customer_name') {
      sortQuery = 'orderBy=customer_name&direction=asc&';
    }
    queryString =
        '?${sortQuery}limit=50&query=$search&page=$page&currency=${state.currentBusiness.currency}';
    if (filterTypes.length > 0) {
      for (int i = 0; i < filterTypes.length; i++) {
        FilterItem item = filterTypes[i];
        String filterType = item.type;
        String filterCondition = item.condition;

        String filterConditionString = 'filters[$filterType][$i][condition]';

        if (item.condition == 'between') {
          String filterValueString = 'filters[$filterType][$i][value][0][from]';
          String filterValueString1 = 'filters[$filterType][$i][value][0][to]';
          String filterValue = item.value;
          String filterValue1 = item.value1;
          String queryTemp =
              '&$filterConditionString=$filterCondition&$filterValueString=$filterValue&$filterValueString1=$filterValue1';
          queryString = '$queryString$queryTemp';
        } else {
          String filterValue = item.value;
          String filterValueString = 'filters[$filterType][$i][value]';
          String queryTemp =
              '&$filterConditionString=$filterCondition&$filterValueString=$filterValue';
          queryString = '$queryString$queryTemp';
        }
      }
    }
    try {
      dynamic obj = await api.getTransactionList(state.currentBusiness.id,
          GlobalUtils.activeToken.accessToken, queryString);

      Transaction transaction = Transaction.fromJson(obj);
      List<Collection> collections = [];
      if (GlobalUtils.isBusinessMode) {
        collections.addAll(transaction.collection);
      } else {
        collections = transaction.collection
            .where((element) =>
                element.businessUuid == null || element.businessUuid.isEmpty)
            .toList();
      }

      yield state.copyWith(
          isLoading: false,
          isSearchLoading: false,
          transaction: transaction,
          collections: collections,
          paginationData: transaction.paginationData);
    } catch (error) {
      if (error.toString().contains('401')) {
        GlobalUtils.clearCredentials();
        yield TransactionsScreenFailure(error: error.toString());
      }
      yield state.copyWith(isLoading: false, isSearchLoading: false);
      print(onError.toString());
    }
  }

  Stream<TransactionsScreenState> loadMoreTransactions() async* {
    String queryString = '';
    String sortQuery = '';
    if (state.curSortType == 'date') {
      sortQuery = 'orderBy=created_at&direction=desc&';
    } else if (state.curSortType == 'total_high') {
      sortQuery = 'orderBy=total&direction=desc&';
    } else if (state.curSortType == 'total_low') {
      sortQuery = 'orderBy=total&direction=asc&';
    } else if (state.curSortType == 'customer_name') {
      sortQuery = 'orderBy=customer_name&direction=asc&';
    }

    int page = state.paginationData == null ? 1 : state.paginationData.page + 1;
    queryString =
        '?${sortQuery}limit=50&query=${state.searchText}&page=$page&currency=${state.paginationData.currency}';
    if (state.filterTypes.length > 0) {
      for (int i = 0; i < state.filterTypes.length; i++) {
        FilterItem item = state.filterTypes[i];
        String filterType = item.type;
        String filterCondition = item.condition;
        String filterValue = item.value;
        String filterConditionString = 'filters[$filterType][$i][condition]';
        String filterValueString = 'filters[$filterType][$i][value]';
        String queryTemp =
            '&$filterConditionString=$filterCondition&$filterValueString=$filterValue';
        queryString = '$queryString$queryTemp';
      }
    }

    dynamic response = await api.getTransactionList(
        dashboardScreenBloc.state.activeBusiness.id,
        GlobalUtils.activeToken.accessToken,
        queryString);
    Transaction transaction = Transaction.fromJson(response);
    List<Collection> collections = state.collections;
    if (transaction.collection.isNotEmpty) {
      if (GlobalUtils.isBusinessMode) {
        collections.addAll(transaction.collection);
      } else {
        List<Collection> collections1 = transaction.collection.where((element) =>
        element.businessUuid == null || element.businessUuid.isEmpty)
            .toList();
        if (collections1 != null && collections1.isNotEmpty)
          collections.addAll(collections1);
      }
    }

    yield state.copyWith(
        transaction: transaction,
        collections: collections,
        paginationData: transaction.paginationData);
  }
}
