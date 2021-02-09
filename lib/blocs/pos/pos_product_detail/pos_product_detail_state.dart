

import 'package:payever/checkout/models/models.dart';

class PosProductDetailScreenState {
  final bool isLoading;
  final bool isUpdating;
  final ChannelSetFlow channelSetFlow;

  PosProductDetailScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.channelSetFlow,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.channelSetFlow,
  ];

  PosProductDetailScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    ChannelSetFlow channelSetFlow
  }) {
    return PosProductDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
    );
  }
}

class PosProductDetailScreenSuccess extends PosProductDetailScreenState{}