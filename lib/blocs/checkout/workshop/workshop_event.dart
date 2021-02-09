import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/pos/models/pos.dart';

abstract class WorkshopScreenEvent extends Equatable {
  WorkshopScreenEvent();

  @override
  List<Object> get props => [];
}

class WorkshopScreenInitEvent extends WorkshopScreenEvent {
  final Business activeBusiness;
  final Terminal activeTerminal;
  final String channelSetId;
  final Checkout defaultCheckout;
  final ChannelSetFlow channelSetFlow;

  WorkshopScreenInitEvent({
    this.channelSetFlow,
    this.activeBusiness,
    this.activeTerminal,
    this.defaultCheckout,
    this.channelSetId,
  });

  @override
  List<Object> get props => [
        this.activeBusiness,
        this.activeTerminal,
        this.defaultCheckout,
        this.channelSetId,
        this.channelSetFlow,
      ];
}

class PatchCheckoutFlowOrderEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowOrderEvent({
    this.body,
  });

  @override
  List<Object> get props => [
        this.body,
      ];
}

class PatchCheckoutFlowAddressEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowAddressEvent({
    this.body,
  });

  @override
  List<Object> get props => [
        this.body,
      ];
}

class PayWireTransferEvent extends WorkshopScreenEvent {}

class PayCreditPaymentEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PayCreditPaymentEvent(this.body);

  @override
  List<Object> get props => [
    this.body,
  ];
}

class GetPrefilledLinkEvent extends WorkshopScreenEvent {
  final bool isCopyLink;

  GetPrefilledLinkEvent({this.isCopyLink = true});

  @override
  List<Object> get props => [
        this.isCopyLink,
      ];
}

class GetPrefilledQRCodeEvent extends WorkshopScreenEvent {}

class EmailValidationEvent extends WorkshopScreenEvent {
  final String email;

  EmailValidationEvent({this.email});

  @override
  List<Object> get props => [
        this.email,
      ];
}

class PayflowLoginEvent extends WorkshopScreenEvent {
  final String email;
  final String password;

  PayflowLoginEvent({this.email, this.password});

  @override
  List<Object> get props => [this.email, this.password];
}

class PayInstantPaymentEvent extends WorkshopScreenEvent {
  final String paymentMethod;
  final Map<String, dynamic> body;

  PayInstantPaymentEvent({this.paymentMethod, this.body});

  @override
  List<Object> get props => [
    this.paymentMethod,
    this.body,
      ];
}

class ResetApprovedStepFlagEvent extends WorkshopScreenEvent {}
class RefreshWorkShopEvent extends WorkshopScreenEvent {}

class CartUpdateEvent extends WorkshopScreenEvent {
  final Map body;

  CartUpdateEvent({this.body});

  @override
  List<Object> get props => [
    this.body,
  ];
}