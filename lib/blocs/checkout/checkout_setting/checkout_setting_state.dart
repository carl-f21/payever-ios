import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

class CheckoutSettingScreenState {

  final bool isLoading;
  final bool isUpdating;
  final String business;
  final Checkout checkout;
  final List<String> phoneNumbers;

  CheckoutSettingScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.business,
    this.checkout,
    this.phoneNumbers = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.business,
    this.checkout,
    this.phoneNumbers,
  ];

  CheckoutSettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
    Checkout checkout,
    List<String> phoneNumbers,
  }) {
    return CheckoutSettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business,
      checkout: checkout ?? this.checkout,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
    );
  }
}

class CheckoutSettingScreenStateSuccess extends CheckoutSettingScreenState {}

class CheckoutSettingScreenStateFailure extends CheckoutSettingScreenState {
  final String error;

  CheckoutSettingScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutSwitchScreenStateFailure { error $error }';
  }
}