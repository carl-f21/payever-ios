import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/settings/models/models.dart';

abstract class PersonalDashboardScreenEvent extends Equatable {
  PersonalDashboardScreenEvent();

  @override
  List<Object> get props => [];
}

class PersonalScreenInitEvent extends PersonalDashboardScreenEvent {
  final User user;
  final MyWallpaper personalWallpaper;
  final String curWall;
  final bool isRefresh;
  final String business;
  PersonalScreenInitEvent({
    this.business,
    this.user,
    this.personalWallpaper,
    this.curWall,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [
    this.business,
    this.user,
    this.personalWallpaper,
    this.curWall,
  ];
}

class UpdatePersonalWallpaperEvent extends PersonalScreenInitEvent {
  final String curWall;
  final MyWallpaper personalWallpaper;
  UpdatePersonalWallpaperEvent({
    this.curWall,
    this.personalWallpaper,
  });

  @override
  List<Object> get props => [
        this.curWall,this.personalWallpaper,
      ];
}
