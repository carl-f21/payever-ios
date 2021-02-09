import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';

class SearchScreenState {
  final bool isLoading;
  final List<Business> businesses;
  final List<Business> searchBusinesses;
  final List<Collection> searchTransactions;

  SearchScreenState({
    this.isLoading = false,
    this.businesses = const [],
    this.searchBusinesses = const [],
    this.searchTransactions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.businesses,
    this.searchBusinesses,
    this.searchTransactions,
  ];

  SearchScreenState copyWith({
    bool isLoading,
    List<Business> businesses,
    List<Business> searchBusinesses,
    List<Collection> searchTransactions,
  }){
    return SearchScreenState(
      isLoading: isLoading ?? this.isLoading,
      businesses: businesses ?? this.businesses,
      searchBusinesses: searchBusinesses ?? this.searchBusinesses,
      searchTransactions: searchTransactions ?? this.searchTransactions,
    );
  }
}

class SearchScreenStateSuccess extends SearchScreenState {}
class SetBusinessSuccess extends SearchScreenState {
  final FetchWallpaper wallpaper;
  final Business business;

  SetBusinessSuccess({ this.wallpaper, this.business}) : super();

  @override
  String toString() {
    return 'SetBusinessSuccess { $wallpaper }';
  }
}
class SearchScreenStateFailure extends SearchScreenState {}
