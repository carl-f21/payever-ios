import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutConnectScreenState {
  final bool isLoading;
  final String business;
  final List<CheckoutPaymentOption> paymentOptions;
  final Map<String, PaymentVariant> paymentVariants;
  final List<ConnectModel> connectInstallations;
  final String category;
  final String installing;

  CheckoutConnectScreenState({
    this.isLoading = false,
    this.business,
    this.paymentOptions = const [],
    this.paymentVariants = const {},
    this.connectInstallations = const [],
    this.category,
    this.installing,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.paymentOptions,
    this.paymentVariants,
    this.connectInstallations,
    this.category,
    this.installing,
  ];

  CheckoutConnectScreenState copyWith({
    bool isLoading,
    String business,
    List<CheckoutPaymentOption> paymentOptions,
    Map<String, PaymentVariant> paymentVariants,
    List<ConnectModel> connectInstallations,
    String category,
    String installing,
  }) {
    return CheckoutConnectScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      paymentVariants: paymentVariants ?? this.paymentVariants,
      connectInstallations: connectInstallations ?? this.connectInstallations,
      category: category ?? this.category,
      installing: installing ?? this.installing,
    );
  }
}

class CheckoutConnectScreenStateSuccess extends CheckoutConnectScreenState {}

class CheckoutConnectScreenStateFailure extends CheckoutConnectScreenState {
  final String error;

  CheckoutConnectScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutConnectScreenStateFailure { error $error }';
  }
}
