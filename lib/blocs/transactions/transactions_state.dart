import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class TransactionsScreenState {
  final bool isLoading;
  final bool isSearchLoading;
  final String searchText;
  final Transaction transaction;
  final List<Collection>collections;
  final PaginationData paginationData;
  final String wallpaper;
  final Business currentBusiness;
  final List<FilterItem> filterTypes;
  final String curSortType;
  final int page;

  TransactionsScreenState({
    this.isLoading = true,
    this.isSearchLoading = false,
    this.collections = const [],
    this.paginationData,
    this.searchText = '',
    this.transaction,
    this.wallpaper,
    this.currentBusiness,
    this.curSortType = 'date',
    this.filterTypes = const [],
    this.page = 1,
  });

  List<Object> get props => [
    this.isLoading,
    this.isSearchLoading,
    this.collections,
    this.paginationData,
    this.searchText,
    this.transaction,
    this.wallpaper,
    this.currentBusiness,
    this.curSortType,
    this.filterTypes,
    this.page,
  ];

  TransactionsScreenState copyWith({
    bool isLoading,
    bool isSearchLoading,
    String searchText,
    Transaction transaction,
    List<Collection>collections,
    PaginationData paginationData,
    String wallpaper,
    Business currentBusiness,
    List<FilterItem> filterTypes,
    String curSortType,
    int page,
  }) {
    return TransactionsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      searchText: searchText ?? this.searchText,
      collections: collections ?? this.collections,
      paginationData: paginationData ?? this.paginationData,
      transaction: transaction ?? this.transaction,
      wallpaper: wallpaper ?? this.wallpaper,
      currentBusiness: currentBusiness ?? this.currentBusiness,
      filterTypes: filterTypes ?? this.filterTypes,
      curSortType: curSortType ?? this.curSortType,
      page: page ?? this.page,
    );
  }
}

class TransactionsScreenSuccess extends TransactionsScreenState {}

class TransactionsScreenFailure extends TransactionsScreenState {
  final String error;

  TransactionsScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'Transactions Screen Failure { error $error }';
  }
}