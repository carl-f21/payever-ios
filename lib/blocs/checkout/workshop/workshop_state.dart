import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/pos/models/pos.dart';

class WorkshopScreenState {
  final Business activeBusiness;
  final Checkout defaultCheckout;
  final Terminal activeTerminal;
  final String channelSetId;

  final bool isLoading;
  final bool isLoadingQrcode;
  final bool isUpdating;
  final bool isReset;
  final bool isApprovedStep;
  final bool isCheckingEmail;
  final bool isAvailable;
  final bool isValid;

  final ChannelSetFlow channelSetFlow;
  final int updatePayflowIndex;
  final dynamic qrForm;
  final dynamic qrImage;
  final String prefilledLink;
  final User user;
  final PayResult payResult;

  WorkshopScreenState({
    this.isLoading = false,
    this.isLoadingQrcode = false,
    this.isUpdating = false,
    this.isApprovedStep = false,
    this.isReset = false,
    this.isCheckingEmail = false,
    this.updatePayflowIndex = -1,
    this.activeBusiness,
    this.activeTerminal,
    this.channelSetId,
    this.channelSetFlow,
    this.defaultCheckout,
    this.isAvailable = false,
    this.isValid = false,
    this.qrForm,
    this.qrImage,
    this.prefilledLink,
    this.user,
    this.payResult,
  });

  List<Object> get props => [
        this.isLoading,
        this.isLoadingQrcode,
        this.isUpdating,
        this.isApprovedStep,
        this.isReset,
        this.isCheckingEmail,
        this.updatePayflowIndex,
        this.activeBusiness,
        this.activeTerminal,
        this.defaultCheckout,
        this.channelSetId,
        this.channelSetFlow,
        this.isAvailable,
        this.isValid,
        this.qrForm,
        this.qrImage,
        this.prefilledLink,
        this.user,
        this.payResult,
  ];

  WorkshopScreenState copyWith({
    bool isLoading,
    bool isLoadingQrcode,
    bool isUpdating,
    bool isReset,
    bool isApprovedStep,
    String channelSetId,
    bool isCheckingEmail,
    int updatePayflowIndex,
    Business activeBusiness,
    Terminal activeTerminal,
    ChannelSetFlow channelSetFlow,
    Checkout defaultCheckout,
    bool isAvailable,
    bool isValid,
    dynamic qrForm,
    dynamic qrImage,
    String prefilledLink,
    User user,
    PayResult payResult,
  }) {
    return WorkshopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingQrcode: isLoadingQrcode ?? this.isLoadingQrcode,
      isUpdating: isUpdating ?? this.isUpdating,
      isApprovedStep: isApprovedStep ?? this.isApprovedStep,
      isReset: isReset ?? this.isReset,
      isCheckingEmail: isCheckingEmail ?? this.isCheckingEmail,
      isAvailable: isAvailable ?? this.isAvailable,
      isValid: isValid ?? this.isValid,
      updatePayflowIndex: updatePayflowIndex ?? this.updatePayflowIndex,
      activeBusiness: activeBusiness ?? this.activeBusiness,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      channelSetId: channelSetId ?? this.channelSetId,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      qrForm: qrForm,
      qrImage: qrImage,
      prefilledLink: prefilledLink ?? this.prefilledLink,
      user: user ?? this.user,
      payResult: payResult ?? this.payResult,
    );
  }
}

class WorkshopScreenStateSuccess extends WorkshopScreenState {}

class WorkshopScreenStateFailure extends WorkshopScreenState {
  final String error;

  WorkshopScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutScreenStateFailure { error $error }';
  }
}

class WorkshopOrderSuccess extends WorkshopScreenState {}

class WorkshopScreenPaySuccess extends WorkshopScreenState {}