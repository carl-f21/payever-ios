import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';

class ProductsScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final bool isSearching;
  final String businessId;
  final bool isProductMode;
  final List<ProductsModel> products;
  final List<ProductListModel> productLists;
  final List<CollectionModel> collections;
  final List<CollectionListModel> collectionLists;
  final Info productsInfo;
  final Info collectionInfo;
  final List<InventoryModel> inventories;
  final List<InventoryModel> updatedInventories;
  final InventoryModel inventory;
  final List<Categories> categories;
  final ProductsModel productDetail;
  final CollectionModel collectionDetail;
  final List<Tax> taxes;
  final List<Terminal> terminals;
  final List<ShopModel> shops;
  final dynamic billingSubscription;
  final num increaseStock;
  final List<ProductsModel> collectionProducts;
  final List<ProductsModel> deleteList;
  final List<ProductsModel> addList;
  final String searchText;
  final List<FilterItem> filterTypes;
  final String sortType;
  final bool updateSuccess;
  final bool addToCollection;

  ProductsScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.isSearching = false,
    this.isProductMode = true,
    this.businessId,
    this.products = const [],
    this.collections = const [],
    this.productLists = const [],
    this.collectionLists = const [],
    this.productsInfo,
    this.collectionInfo,
    this.inventories = const [],
    this.updatedInventories = const [],
    this.inventory,
    this.categories = const [],
    this.productDetail,
    this.taxes = const [],
    this.terminals = const [],
    this.shops = const [],
    this.billingSubscription,
    this.increaseStock = 0,
    this.collectionDetail,
    this.collectionProducts = const [],
    this.deleteList = const [],
    this.addList = const [],
    this.searchText = '',
    this.filterTypes = const [],
    this.sortType = 'createdAt',
    this.updateSuccess = false,
    this.addToCollection = false,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.isSearching,
    this.isProductMode,
    this.businessId,
    this.products,
    this.collections,
    this.productLists,
    this.collectionLists,
    this.productsInfo,
    this.collectionInfo,
    this.inventories,
    this.inventory,
    this.updatedInventories,
    this.categories,
    this.productDetail,
    this.taxes,
    this.terminals,
    this.shops,
    this.billingSubscription,
    this.increaseStock,
    this.collectionDetail,
    this.collectionProducts,
    this.searchText,
    this.filterTypes,
    this.sortType,
    this.updateSuccess,
    this.deleteList,
    this.addList,
    this.addToCollection,
  ];

  ProductsScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    bool isSearching,
    bool isProductMode,
    String businessId,
    List<ProductsModel> products,
    List<CollectionModel> collections,
    List<ProductListModel> productLists,
    List<CollectionListModel> collectionLists,
    Info productsInfo,
    Info collectionInfo,
    List<InventoryModel> inventories,
    List<InventoryModel> updatedInventories,
    InventoryModel inventory,
    List<Categories> categories,
    ProductsModel productDetail,
    List<Tax> taxes,
    List<Terminal> terminals,
    List<ShopModel> shops,
    dynamic billingSubscription,
    num increaseStock,
    List<ProductsModel> collectionProducts,
    List<ProductsModel> deleteList,
    List<ProductsModel> addList,
    CollectionModel collectionDetail,
    String searchText,
    List<FilterItem> filterTypes,
    String sortType,
    bool updateSuccess,
    bool addToCollection,
  }) {
    return ProductsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      isSearching: isSearching ?? this.isSearching,
      isProductMode: isProductMode ?? this.isProductMode,
      businessId: businessId ?? this.businessId,
      products: products ?? this.products,
      collections: collections ?? this.collections,
      productLists: productLists ?? this.productLists,
      collectionLists: collectionLists ?? this.collectionLists,
      productsInfo: productsInfo ?? this.productsInfo,
      collectionInfo: collectionInfo ?? this.collectionInfo,
      inventories: inventories ?? this.inventories,
      updatedInventories: updatedInventories ?? this.updatedInventories,
      inventory: inventory ?? this.inventory,
      categories: categories ?? this.categories,
      productDetail: productDetail ?? this.productDetail,
      taxes: taxes ?? this.taxes,
      terminals: terminals ?? this.terminals,
      shops: shops ?? this.shops,
      billingSubscription: billingSubscription ?? this.billingSubscription,
      increaseStock: increaseStock ?? this.increaseStock,
      collectionProducts: collectionProducts ?? this.collectionProducts,
      deleteList: deleteList ?? this.deleteList,
      addList: addList ?? this.addList,
      collectionDetail: collectionDetail ?? this.collectionDetail,
      searchText: searchText ?? this.searchText,
      filterTypes: filterTypes ?? this.filterTypes,
      sortType: sortType ?? this.sortType,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      addToCollection: addToCollection ?? this.addToCollection,
    );
  }
}

class ProductsScreenStateSuccess extends ProductsScreenState {
  final bool isLoading;

  ProductsScreenStateSuccess({this.isLoading = true});
}

class ProductsScreenStateFailure extends ProductsScreenState {
  final String error;

  ProductsScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ProductsScreenStateFailure { error $error }';
  }
}

class ProductsNotExist extends ProductsScreenState {
  final String error;

  ProductsNotExist({@required this.error}) : super();

  @override
  String toString() {
    return 'ProductsNotExist { error $error }';
  }
}

class CategoriesCreate extends ProductsScreenState { }
