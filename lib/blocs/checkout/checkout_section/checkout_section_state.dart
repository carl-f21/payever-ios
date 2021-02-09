import 'package:flutter/material.dart';

class CheckoutSectionScreenState {

  final bool isLoading;
  final bool isUpdating;
  final String business;

  CheckoutSectionScreenState({this.isLoading = false, this.isUpdating = false, this.business});

  CheckoutSectionScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
  }) {
    return CheckoutSectionScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business
    );
  }
}

class CheckoutSectionScreenSuccess extends CheckoutSectionScreenState {}

class CheckoutSectionScreenFailure extends CheckoutSectionScreenState {
  final String error;

  CheckoutSectionScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutSectionScreenFailure { error $error }';
  }
}