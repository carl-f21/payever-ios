import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';


abstract class PosProductDetailScreenEvent extends Equatable {
  PosProductDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class PosProductDetailScreenInitEvent extends PosProductDetailScreenEvent {
  final ChannelSetFlow channelSetFlow;

  PosProductDetailScreenInitEvent(this.channelSetFlow);
}

class CartProductEvent extends PosProductDetailScreenEvent {
  final Map body;

  CartProductEvent({this.body});

  @override
  List<Object> get props => [
    this.body,
  ];
}