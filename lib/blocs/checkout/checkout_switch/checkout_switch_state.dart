import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

class CheckoutSwitchScreenState {
  final bool isLoading;
  final bool isUpdating;
  final String business;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;
  final String blobName;

  CheckoutSwitchScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.business,
    this.checkouts = const [],
    this.defaultCheckout,
    this.blobName,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.business,
    this.checkouts,
    this.defaultCheckout,
    this.blobName,
  ];

  CheckoutSwitchScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
    List<Checkout> checkouts,
    Checkout defaultCheckout,
    String blobName,
  }) {
    return CheckoutSwitchScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business,
      checkouts: checkouts ?? this.checkouts,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      blobName: blobName ?? this.blobName,
    );
  }
}

class CheckoutSwitchScreenStateSuccess extends CheckoutSwitchScreenState {}

class CheckoutSwitchScreenOpenStateSuccess extends CheckoutSwitchScreenState {}

class CheckoutSwitchScreenStateFailure extends CheckoutSwitchScreenState {
  final String error;

  CheckoutSwitchScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutSwitchScreenStateFailure { error $error }';
  }
}
