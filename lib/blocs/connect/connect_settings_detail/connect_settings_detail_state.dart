
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ConnectSettingsDetailScreenState {
  final bool isLoading;
  final bool isAdding;
  final bool isSaving;
  final num deleting;
  final String business;
  final List<CheckoutPaymentOption> paymentOptions;
  final Map<String, PaymentVariant> paymentVariants;
  final List<ConnectModel> connectInstallations;
  final ConnectModel connectModel;
  final ConnectIntegration integration;

  ConnectSettingsDetailScreenState({
    this.isLoading = false,
    this.isAdding = false,
    this.isSaving = false,
    this.deleting,
    this.business,
    this.paymentOptions = const [],
    this.paymentVariants = const {},
    this.connectInstallations = const [],
    this.connectModel,
    this.integration,
  });

  List<Object> get props => [
    this.isLoading,
    this.isAdding,
    this.isSaving,
    this.deleting,
    this.business,
    this.paymentOptions,
    this.paymentVariants,
    this.connectInstallations,
    this.connectModel,
    this.integration,
  ];

  ConnectSettingsDetailScreenState copyWith({
    bool isLoading,
    bool isAdding,
    bool isSaving,
    num deleting,
    String business,
    List<CheckoutPaymentOption> paymentOptions,
    Map<String, PaymentVariant> paymentVariants,
    List<ConnectModel> connectInstallations,
    ConnectModel connectModel,
    ConnectIntegration integration
  }) {
    return ConnectSettingsDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      isSaving: isSaving ?? this.isSaving,
      deleting: deleting ?? this.deleting,
      business: business ?? this.business,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      paymentVariants: paymentVariants ?? this.paymentVariants,
      connectInstallations: connectInstallations ?? this.connectInstallations,
      connectModel: connectModel ?? this.connectModel,
      integration: integration ?? this.integration,
    );
  }
}

class ConnectSettingsDetailScreenSuccess extends ConnectSettingsDetailScreenState {
  final String business;
  final ConnectModel connectModel;

  ConnectSettingsDetailScreenSuccess({this.business, this.connectModel,});
}

class ConnectSettingsDetailScreenFailure extends ConnectSettingsDetailScreenState {
  final String error;

  ConnectSettingsDetailScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ConnectSettingsDetailScreenFailure { error $error }';
  }
}
