import 'package:flutter/cupertino.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/settings/models/models.dart';

class BusinessState {
  final bool isLoading;
  final bool isUpdating;
  final BusinessFormData formData;
  final List<IndustryModel> industryList;
  final List<IndustryModel> suggestions;

  BusinessState({
    this.isLoading = false,
    this.isUpdating = false,
    this.formData,
    this.industryList = const [],
    this.suggestions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.formData,
    this.industryList,
    this.suggestions,
  ];

  BusinessState copyWith({
    bool isLoading,
    bool isUpdating,
    BusinessFormData formData,
    List<IndustryModel> industryList,
    List<IndustryModel> suggestions,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      formData: formData ?? this.formData,
      industryList: industryList ?? this.industryList,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

class BusinessSuccess extends BusinessState {
  final Business business;
  final List<BusinessApps> businessApps;
  final FetchWallpaper wallpaper;

  BusinessSuccess({this.business, this.businessApps, this.wallpaper});
}

class BusinessFailure extends BusinessState {
  final String error;

  BusinessFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'BusinessFailure { error $error }';
  }
}
