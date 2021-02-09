import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

class CheckoutChannelSetScreenState {
  final bool isLoading;
  final List<ChannelSet> channelSets;
  final String business;
  final String type;

  CheckoutChannelSetScreenState({
    this.isLoading = false,
    this.channelSets = const [],
    this.business,
    this.type,
  });

  List<Object> get props => [
    this.isLoading,
    this.channelSets,
    this.business,
    this.type,
  ];

  CheckoutChannelSetScreenState copyWith({
    bool isLoading,
    List<ChannelSet> channelSets,
    String business,
    String type,
  }) {
    return CheckoutChannelSetScreenState(
      isLoading: isLoading ?? this.isLoading,
      channelSets: channelSets ?? this.channelSets,
      business: business ?? this.business,
      type: type ?? this.type,
    );
  }
}

class CheckoutChannelSetScreenSuccess extends CheckoutChannelSetScreenState {}

class CheckoutChannelSetScreenFailure extends CheckoutChannelSetScreenState {
  final String error;

  CheckoutChannelSetScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutChannelSetScreenFailure { error $error }';
  }
}
