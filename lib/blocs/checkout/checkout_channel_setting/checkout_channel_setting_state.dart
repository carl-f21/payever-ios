import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutChannelSettingScreenState {
  final bool isLoading;
  final ConnectModel connectModel;
  final ShopSystem shopSystem;
  final List<APIkey> apiKeys;
  final String business;
  final bool isUpdating;

  CheckoutChannelSettingScreenState({
    this.isLoading = false,
    this.connectModel,
    this.shopSystem,
    this.apiKeys = const [],
    this.business,
    this.isUpdating = false,
  });

  List<Object> get props => [
    this.isLoading,
    this.connectModel,
    this.shopSystem,
    this.apiKeys,
    this.business,
    this.isUpdating,
  ];

  CheckoutChannelSettingScreenState copyWith({
    bool isLoading,
    ConnectModel connectModel,
    ShopSystem shopSystem,
    List<APIkey> apiKeys,
    String business,
    bool isUpdating,
  }) {
    return CheckoutChannelSettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      connectModel: connectModel ?? this.connectModel,
      shopSystem: shopSystem ?? this.shopSystem,
      apiKeys: apiKeys ?? this.apiKeys,
      business: business ?? this.business,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class CheckoutChannelSettingScreenSuccess extends CheckoutChannelSettingScreenState {}

class CheckoutChannelSettingScreenFailure extends CheckoutChannelSettingScreenState {
  final String error;

  CheckoutChannelSettingScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutChannelSettingScreenFailure { error $error }';
  }
}
