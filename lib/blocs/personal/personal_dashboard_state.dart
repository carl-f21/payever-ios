import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/settings/models/models.dart';

class PersonalDashboardScreenState {
  final bool isLoading;
  final List<BusinessApps> personalApps;
  final List<AppWidget> personalWidgets;
  final bool isUpdating;
  final bool isDeleting;
  final bool isUpdatingBusinessImg;
  final bool uploadUserImage;
  final String business;
  final User user;
  final AuthUser authUser;
  final MyWallpaper personalWallpaper;
  final String curWall;

  PersonalDashboardScreenState({
    this.isLoading = false,
    this.personalApps = const[],
    this.personalWidgets = const[],
    this.isUpdating = false,
    this.isDeleting = false,
    this.isUpdatingBusinessImg = false,
    this.uploadUserImage = false,
    this.business,
    this.user,
    this.authUser,
    this.personalWallpaper,
    this.curWall,
  });

  List<Object> get props => [
    this.isLoading,
    this.personalApps,
    this.personalWidgets,
    this.isUpdating,
    this.isDeleting,
    this.isUpdatingBusinessImg,
    this.uploadUserImage,
    this.business,
    this.user,
    this.authUser,
    this.personalWallpaper,
    this.curWall,
  ];

  PersonalDashboardScreenState copyWith({
    bool isLoading,
    List<BusinessApps> personalApps,
    List<AppWidget> personalWidgets,
    bool isUpdating,
    bool isDeleting,
    User user,
    AuthUser authUser,
    MyWallpaper personalWallpaper,
    String curWall,
    String business,
  }) {
    return PersonalDashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
      personalApps: personalApps ?? this.personalApps,
      personalWidgets: personalWidgets ?? this.personalWidgets,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      isUpdatingBusinessImg: isUpdatingBusinessImg ?? this.isUpdatingBusinessImg,
      uploadUserImage: uploadUserImage ?? this.uploadUserImage,
      business: business ?? this.business,
      user: user ?? this.user,
      authUser: authUser ?? this.authUser,
      personalWallpaper: personalWallpaper ?? this.personalWallpaper,
      curWall: curWall ?? this.curWall,
    );
  }
}

class PersonalScreenStateFailure extends PersonalDashboardScreenState {
  final String error;

  PersonalScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'SettingScreenUpdateFailure { error $error }';
  }
}