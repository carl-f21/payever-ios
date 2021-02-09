import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class TransactionsScreenEvent extends Equatable {
  TransactionsScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionsScreenInitEvent extends TransactionsScreenEvent {
  final Business currentBusiness;

  TransactionsScreenInitEvent(this.currentBusiness);

  @override
  List<Object> get props => [
    this.currentBusiness,
  ];

}

class FetchTransactionsEvent extends TransactionsScreenEvent {
  final String searchText;
  final int page;
  final List<FilterItem> filterBy;
  final String sortBy;

  FetchTransactionsEvent({
    this.searchText,
    this.filterBy,
    this.sortBy,
    this.page,
  });

  @override
  List<Object> get props => [
    this.searchText,
    this.filterBy,
    this.sortBy,
    this.page,
  ];
}

class UpdateSearchText extends TransactionsScreenEvent {
  final String searchText;

  UpdateSearchText({
    this.searchText,
  });

  List<Object> get props => [
    this.searchText,
  ];
}

class UpdateFilterTypes extends TransactionsScreenEvent {
  final List<FilterItem> filterTypes;

  UpdateFilterTypes({
    this.filterTypes,
  });

  List<Object> get props => [
    this.filterTypes,
  ];
}

class UpdateSortType extends TransactionsScreenEvent {
  final String sortType;

  UpdateSortType({
    this.sortType,
  });

  List<Object> get props => [
    this.sortType,
  ];
}

class LoadMoreTransactionsEvent extends TransactionsScreenEvent{}

class RefreshTransactionsEvent extends TransactionsScreenEvent{}