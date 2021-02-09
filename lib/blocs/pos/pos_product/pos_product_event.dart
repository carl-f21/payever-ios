import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/pos/models/pos.dart';
import 'package:payever/products/models/models.dart';


abstract class PosProductScreenEvent extends Equatable {
  PosProductScreenEvent();

  @override
  List<Object> get props => [];
}

class PosProductsScreenInitEvent extends PosProductScreenEvent {
  final String businessId;
  final List<ProductsModel> products;
  final Info productsInfo;

  PosProductsScreenInitEvent(this.businessId, this.products, this.productsInfo);

  @override
  List<Object> get props => [
    this.businessId,
    this.products,
    this.productsInfo,
  ];
}

class ProductsFilterEvent extends PosProductScreenEvent {
  final List<String> categories;
  final bool orderDirection;
  final String searchText;

  ProductsFilterEvent({
    this.orderDirection,
    this.searchText,
    this.categories,
  });

  @override
  List<Object> get props => [
    this.categories,
    this.orderDirection,
    this.searchText,
  ];
}

class ResetProductsFilterEvent extends PosProductScreenEvent{}

class ResetCardProgressEvent extends PosProductScreenEvent{}

class GetChannelSetFlowEvent extends PosProductScreenEvent{}

class CartOrderEvent extends PosProductScreenEvent{}

class UpdateProductChannelSetFlowEvent extends PosProductScreenEvent {
  final ChannelSetFlow channelSetFlow;
  UpdateProductChannelSetFlowEvent(this.channelSetFlow);

  @override
  List<Object> get props => [
    this.channelSetFlow,
  ];
}

@immutable
class PosProductsReloadEvent extends PosProductScreenEvent {}

@immutable
class PosProductsLoadMoreEvent extends PosProductScreenEvent {}