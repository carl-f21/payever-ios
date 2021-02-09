import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/products/models/models.dart';

abstract class ProductsScreenEvent extends Equatable {
  ProductsScreenEvent();

  @override
  List<Object> get props => [];
}

class ProductsScreenInitEvent extends ProductsScreenEvent {
  final String currentBusinessId;

  ProductsScreenInitEvent({
    this.currentBusinessId,
  });

  @override
  List<Object> get props => [
    this.currentBusinessId,
  ];
}

class CheckProductItem extends ProductsScreenEvent {
  final ProductListModel model;

  CheckProductItem({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class CheckCollectionItem extends ProductsScreenEvent {
  final CollectionListModel model;

  CheckCollectionItem({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

@immutable
class ProductsReloadEvent extends ProductsScreenEvent {
}

@immutable
class ProductsLoadMoreEvent extends ProductsScreenEvent {}

@immutable
class CollectionsReloadEvent extends ProductsScreenEvent {
}

@immutable
class CollectionsLoadMoreEvent extends ProductsScreenEvent {}

@immutable
class SelectAllProductsEvent extends ProductsScreenEvent {}

@immutable
class UnSelectProductsEvent extends ProductsScreenEvent {}

@immutable
class AddToCollectionEvent extends ProductsScreenEvent {}

@immutable
class DeleteProductsEvent extends ProductsScreenEvent {
  final List<ProductsModel> models;

  DeleteProductsEvent({this.models});
  @override
  List<Object> get props => [
    this.models,
  ];
}

@immutable
class SelectAllCollectionsEvent extends ProductsScreenEvent {}

@immutable
class UnSelectCollectionsEvent extends ProductsScreenEvent {}

@immutable
class DeleteCollectionProductsEvent extends ProductsScreenEvent {}

@immutable
class DeleteSingleProduct extends ProductsScreenEvent {
  final ProductListModel product;

  DeleteSingleProduct({this.product});

  @override
  List<Object> get props => [
    this.product,
  ];
}

@immutable
class GetInventoriesEvent extends ProductsScreenEvent {}

class GetProductDetails extends ProductsScreenEvent {
  final ProductsModel productsModel;
  final String businessId;

  GetProductDetails({this.productsModel, this.businessId});
  @override
  List<Object> get props => [
    this.productsModel,
    this.businessId,
  ];
}

class UpdateProductDetail extends ProductsScreenEvent {
  final ProductsModel productsModel;
  final num increaseStock;
  final InventoryModel inventoryModel;
  final List<InventoryModel> inventories;

  UpdateProductDetail({this.productsModel, this.increaseStock, this.inventoryModel, this.inventories,});
  @override
  List<Object> get props => [
    this.productsModel,
    this.increaseStock,
    this.inventoryModel,
    this.inventories,
  ];
}

class SaveProductDetail extends ProductsScreenEvent {
  final ProductsModel productsModel;

  SaveProductDetail({this.productsModel});
  @override
  List<Object> get props => [
    this.productsModel,
  ];
}

class CreateProductEvent extends ProductsScreenEvent {
  final ProductsModel productsModel;

  CreateProductEvent({this.productsModel});
  @override
  List<Object> get props => [
    this.productsModel,
  ];
}

class UploadImageToProduct extends ProductsScreenEvent {
  final File file;

  UploadImageToProduct({this.file,});
  @override
  List<Object> get props => [
    this.file,
  ];
}

class GetCollectionDetail extends ProductsScreenEvent {
  final CollectionModel collection;
  final List<ProductsModel> addProducts;

  GetCollectionDetail({this.collection, this.addProducts});
  @override
  List<Object> get props => [
    this.collection,
    this.addProducts,
  ];
}


class UpdateCollectionDetail extends ProductsScreenEvent {
  final CollectionModel collectionModel;
  final List<ProductsModel> collectionProducts;
  final List<ProductsModel> deleteList;

  UpdateCollectionDetail({this.collectionModel, this.collectionProducts, this.deleteList});
  @override
  List<Object> get props => [
    this.collectionModel,
    this.collectionProducts,
    this.deleteList,
  ];
}

class SaveCollectionDetail extends ProductsScreenEvent {
  final CollectionModel collectionModel;
  final List<ProductsModel> deleteList;

  SaveCollectionDetail({this.collectionModel, this.deleteList});
  @override
  List<Object> get props => [
    this.collectionModel,
    this.deleteList,
  ];
}

class CreateCollectionEvent extends ProductsScreenEvent {
  final CollectionModel collectionModel;

  CreateCollectionEvent({this.collectionModel, });
  @override
  List<Object> get props => [
    this.collectionModel,
  ];
}

class UploadImageToCollection extends ProductsScreenEvent {
  final File file;

  UploadImageToCollection({this.file,});
  @override
  List<Object> get props => [
    this.file,
  ];
}


class UpdateProductSearchText extends ProductsScreenEvent {
  final String searchText;

  UpdateProductSearchText({
    this.searchText,
  });

  List<Object> get props => [
    this.searchText,
  ];
}

class UpdateProductFilterTypes extends ProductsScreenEvent {
  final List<FilterItem> filterTypes;

  UpdateProductFilterTypes({
    this.filterTypes,
  });

  List<Object> get props => [
    this.filterTypes,
  ];
}

class UpdateProductSortType extends ProductsScreenEvent {
  final String sortType;

  UpdateProductSortType({
    this.sortType,
  });

  List<Object> get props => [
    this.sortType,
  ];
}

class CancelProductEdit extends ProductsScreenEvent {

  CancelProductEdit();

  List<Object> get props => [
  ];
}

class CreateCategoryEvent extends ProductsScreenEvent {
  final String title;

  CreateCategoryEvent({this.title});
  @override
  List<Object> get props => [
    this.title,
  ];
}

class SwitchProductCollectionMode extends ProductsScreenEvent {
  final bool isProductMode;
  SwitchProductCollectionMode({this.isProductMode = true});

  List<Object> get props => [
    this.isProductMode,
  ];
}