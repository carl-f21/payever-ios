import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/commons/models/user.dart';

class SwitcherScreenState {
  final bool isLoading;
  final List<Business> businesses;
  final User logUser;
  final Business active;
  final List<AppWidget> widgets;
  final FetchWallpaper wallpaper;

  SwitcherScreenState({
    this.isLoading = true,
    this.businesses = const [],
    this.logUser,
    this.active,
    this.widgets = const [],
    this.wallpaper,
  });

  List<Object> get props => [
    this.isLoading,
    this.businesses,
    this.logUser,
    this.active,
    this.widgets,
    this.wallpaper,
  ];

  SwitcherScreenState copyWith({
    bool isLoading,
    List<Business> businesses,
    User logUser,
    Business active,
    List<AppWidget> widgets,
    FetchWallpaper wallpaper,
  }){
    return SwitcherScreenState(
      isLoading: isLoading ?? this.isLoading,
      businesses: businesses ?? this.businesses,
      logUser: logUser ?? this.logUser,
      active: active ?? this.active,
      widgets: widgets ?? this.widgets,
      wallpaper: wallpaper ?? this.wallpaper,
    );
  }
}

class SwitcherScreenStateSuccess extends SwitcherScreenState {
  final FetchWallpaper wallpaper;
  final Business business;

  SwitcherScreenStateSuccess({ this.wallpaper, this.business}) : super();

  @override
  String toString() {
    return 'SwitcherScreenStateSuccess { $wallpaper }';
  }
}
class SwitcherScreenStateFailure extends SwitcherScreenState {}
