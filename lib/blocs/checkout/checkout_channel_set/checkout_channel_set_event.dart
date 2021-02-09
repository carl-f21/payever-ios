
import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class CheckoutChannelSetScreenEvent extends Equatable {
  CheckoutChannelSetScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutChannelSetScreenInitEvent extends CheckoutChannelSetScreenEvent {
  final String business;
  final String type;

  CheckoutChannelSetScreenInitEvent({
    this.business,
    this.type,
  });

  @override
  List<Object> get props => [
    this.business,
    this.type,
  ];
}

class GetChannelSetEvent extends CheckoutChannelSetScreenEvent {}

class UpdateChannelSet extends CheckoutChannelSetScreenEvent {

  final ChannelSet channelSet;
  final String checkoutId;
  UpdateChannelSet({this.channelSet, this.checkoutId});

  @override
  List<Object> get props => [
    this.channelSet,
    this.checkoutId,
  ];
}
